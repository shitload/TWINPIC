//
//  LKNavigationManager.m
//  Lookin
//
//  Created by Li Kai on 2018/11/3.
//  https://lookin.work
//

#import "LKNavigationManager.h"
#import "LKLaunchWindowController.h"
#import "LKStaticWindowController.h"
#import "LKPreferenceWindowController.h"
#import "LKStaticViewController.h"
#import "LKPreviewController.h"
#import "LKPreviewController.h"
#import "LKAppsManager.h"
#import "LookinHierarchyFile.h"
#import "LKReadWindowController.h"
#import "LKMethodTraceWindowController.h"
#import "LKConsoleViewController.h"
#import "LKPreferenceManager.h"
#import "LKAboutWindowController.h"
@import AppCenter;
@import AppCenterAnalytics;

@interface LKNavigationManager ()

@property(nonatomic, strong) LKPreferenceWindowController *preferenceWindowController;
@property(nonatomic, strong) LKAboutWindowController *aboutWindowController;

@end

@implementation LKNavigationManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKNavigationManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)showLaunch {
    _launchWindowController = [[LKLaunchWindowController alloc