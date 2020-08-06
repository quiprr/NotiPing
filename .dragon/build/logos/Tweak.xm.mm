#line 1 "Tweak.xm"
#import "NSTask.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SBIconController : UIViewController
- (void)executePing;
@end

BOOL timerAdded = NO;
NSDictionary *rootDict;


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBIconController; 
static void (*_logos_orig$_ungrouped$SBIconController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL SBIconController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBIconController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL SBIconController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBIconController$executePing(_LOGOS_SELF_TYPE_NORMAL SBIconController* _LOGOS_SELF_CONST, SEL); 

#line 12 "Tweak.xm"

static void _logos_method$_ungrouped$SBIconController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL SBIconController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$SBIconController$viewDidLoad(self, _cmd);

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



static void _logos_method$_ungrouped$SBIconController$executePing(_LOGOS_SELF_TYPE_NORMAL SBIconController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

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

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBIconController = objc_getClass("SBIconController"); { MSHookMessageEx(_logos_class$_ungrouped$SBIconController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$SBIconController$viewDidLoad, (IMP*)&_logos_orig$_ungrouped$SBIconController$viewDidLoad);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconController, @selector(executePing), (IMP)&_logos_method$_ungrouped$SBIconController$executePing, _typeEncoding); }} }
#line 55 "Tweak.xm"
