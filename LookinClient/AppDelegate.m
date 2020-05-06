//
//  AppDelegate.m
//  Lookin
//
//  Created by Li Kai on 2018/8/4.
//  https://lookin.work
//

#import "AppDelegate.h"
#import "LKNavigationManager.h"
#import "LKConnectionManager.h"
#import "LKPreferenceManager.h"
#import "LKAppMenuManager.h"
#import "LKLaunchWindowController.h"
#import "LookinDocument.h"
#import "NSString+Score.h"
#import "LookinDashboardBlueprint.h"
#import "LKPreferenceManager.h"
@import AppCenter;
@import AppCenterAnalytics;
@import AppCenterCrashes;

@interface AppDelegate ()

@property(nonatomic, assign) BOOL launchedToOpenFile;

@end

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    [[LKAppMenuManager sharedInstance] setup];
    
    [RACObserve([LKPreferenceManager mainManager], appearanceType) subscribeNext:^(NSNumber *number) {
        LookinPreferredAppeanranceType type = [number integerValue];
        switch (type) {
            case LookinPreferredAppeanranceTypeDark:
                NSApp.appearance = [NSAppearance appearanceNamed:NSAppearanceNameDarkAqua];
                break;
            case LookinPreferredAppeanranceTypeLight:
                NSApp.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
                break;
            default:
            