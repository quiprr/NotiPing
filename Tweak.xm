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
    NSLog(@"[NotiPing] Preferences loaded.");

    if (shouldEnableNotiPing) {
        if (!timerAdded) {
            timerAdded = YES;
            [NSTimer scheduledTimerWithTimeInterval:putIntoNSTimer target:self selector:@selector(executePing) userInfo:nil repeats:YES];
            NSLog(@"[NotiPing] NSTimer created. Now we wait!");
        }
    }
}

%new

- (void)executePing {

    NSLog(@"Reloading Preferences...");
    NSString *ipAddress = [rootDict objectForKey:@"ipAddress"];
    NSLog(@"Preferences reloaded.");

    NSLog(@"[NotiPing] shouldEnableNotiPing YES; running ping");
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/ping";
    task.arguments = @[ipAddress, @"-c", @"1"];
    [task launch];
    [task waitUntilExit];
    NSLog(@"[NotiPing] ping command finished");

    if (task.terminationStatus == 1) {
        NSLog(@"[NotiPing] if statement called");
        NSLog(@"[NotiPing] running UIAlertController");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"NotiPing"
                           message:@"The server you specified did not give a response."
                           preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {}];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
%end
