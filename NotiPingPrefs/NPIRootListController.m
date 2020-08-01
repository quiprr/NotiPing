#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NPIRootListController.h"
#import "spawn.h"

@implementation NPIRootListController

- (NSMutableArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/dev.ametrine.notiping.plist"];
    id object = [dict objectForKey:[specifier propertyForKey:@"key"]];
    if (!object) {
        object = [specifier propertyForKey:@"default"];
    }
    return object;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/dev.ametrine.notiping.plist"];
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
    }
    [dict setObject:value forKey:[specifier propertyForKey:@"key"]];
    [dict writeToFile:@"/var/mobile/Library/Preferences/dev.ametrine.notiping.plist" atomically:YES];
}

- (void)sbreload {
	pid_t pid;
    const char* args[] = {"sbreload", NULL};
    posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
}

- (void)openGitHub
{
	NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/ItHertzSoGood/notiping"] options:options completionHandler:nil];
}

- (void)openTwitter
{
	NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/quiprr"] options:options completionHandler:nil];
}

- (void)openWebsite
{
	NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ametrine.dev/"] options:options completionHandler:nil];
}

- (void)openReddit
{
	NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://reddit.com/u/quiprr"] options:options completionHandler:nil];
}

@end