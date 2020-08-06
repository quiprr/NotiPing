#import "NSTask.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SBIconController : UIViewController
- (void)executePing;
@end

BOOL timerAdded = NO;
NSDictionary *rootDict;

%hook SBIconController
- (void)viewDidLoad {
    %orig;

    rootDict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/dev.ametrine.notiping.plist"];
    BOOL shouldEnableNotiPing = [[rootDict objectForKey:@"enableTweak"] boolValue];
    NSNumber *timerDelay = [rootDict objectForKey:@"timerDelay"];
    double putIntoNSTimer = [timerDelay doubleValue];

    if (shouldEnableNotiPing) {
        if (!timerAdded) {
            timerAdded = YES;
            [NSTimer scheduledTimerWithTimeInterval:putIntoNSTimer target:self selector:@selector(executePing) userInfo:nil repeats:YES];
        }
    }
}

%new

- (void)executePing {

    NSString *ipAddress = [rootDict objectForKey:@"ipAddress"];
    NSString *alertText = [rootDict objectForKey:@"alertText"];

    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/ping";
    task.arguments = @[ipAddress, @"-c", @"1"];
    [task launch];
    [task waitUntilExit];

    if (task.terminationStatus == 1) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"NotiPing"
                           message:alertText
                           preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                               handler:nil];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
%end