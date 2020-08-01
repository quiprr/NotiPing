#import "Foundation/Foundation.h"
#import "UIKit/UIKit.h"

@interface NSTask : NSObject
@property (copy) NSString *launchPath;
@property (copy) NSString *currentDirectoryPath;
@property (copy) NSDictionary <NSString *, NSString *> *environment;
@property (copy) NSArray <NSString *> *arguments;
@property (retain) id standardInput;
@property (retain) id standardOutput;
@property (retain) id standardError;
@property (readonly, getter=isRunning) BOOL running;
@property (readonly) int processIdentifier;
@property (readonly) int terminationStatus;
- (instancetype)init;
+ (NSTask *)launchedTaskWithLaunchPath:(NSString *)path arguments:(NSArray <NSString *> *)arguments;
- (void)launch;
- (void)waitUntilExit;
- (BOOL)suspend;
- (BOOL)resume;
- (void)interrupt;
- (void)terminate;
@end
