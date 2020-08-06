#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface NPISubPageController : PSListController
- (NSMutableArray *)specifiers;
- (id)readPreferenceValue:(PSSpecifier *)specifier;
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier;
@end