//
//  LKAppMenuManager.m
//  Lookin
//
//  Created by Li Kai on 2019/3/20.
//  https://lookin.work
//

#import "LKAppMenuManager.h"
#import "LKNavigationManager.h"
#import "LKLaunchWindowController.h"
#import "LKLaunchViewController.h"
#import "LKPreviewController.h"
#import "LKStaticWindowController.h"
#import "LKStaticViewController.h"
#import "LKPreferenceManager.h"
#import "LKStaticHierarchyDataSource.h"
#import "LKWindowController.h"
#include <mach-o/dyld.h>
#import <Sparkle/Sparkle.h>
@import AppCenter;
@import AppCenterAnalytics;

static NSUInteger const kTag_About = 11;
static NSUInteger const kTag_Preferences = 12;
static NSUInteger const kTag_CheckUpdates = 13;

static NSUInteger const kTag_Reload = 21;
static NSUInteger const kTag_Dimension = 22;
static NSUInteger const kTag_ZoomIn = 23;
static NSUInteger const kTag_ZoomOut = 24;
static NSUInteger const kTag_DecreaseInterspace = 25;
static NSUInteger const kTag_IncreaseInterspace = 26;
static NSUInteger const kTag_Expansion = 27;
static NSUInteger const kTag_Filter = 28;
static NSUInteger const kTag_DelayReload = 29;
static NSUInteger const kTag_OpenInNewWindow = 31;
static NSUInteger const kTag_Export = 32;

static NSUInteger const kTag_ShowFramework = 50;
static NSUInteger const kTag_CocoaPods = 51;
static NSUInteger const kTag_ShowWebsite = 52;
static NSUInteger const kTag_ShowConfig = 53;
static NSUInteger const kTag_ShowLookiniOS = 54;
static NSUInteger const kTag_MethodTrace = 55;
static NSUInteger const kTag_DeveloperProfile = 56;

static NSUInteger const kTag_GitHub = 57;
static NSUInteger const kTag_LookinClientGitHub = 58;
static NSUInteger const kTag_LookinServerGitHub = 59;

static NSUInteger const kTag_ReportIssues = 60;
static NSUInteger const kTag_Email = 61;
static NSUInteger const kTag_LookinClientGitHubIssues = 62;
static NSUInteger const kTag_LookinServerGitHubIssues = 63;
static NSUInteger const kTag_Weibo = 64;

static NSUInteger const kTag_CopyPod = 66;
static NSUInteger const kTag_CopySPM = 67;
static NSUInteger const kTag_MoreIntegrationGuide = 68;
static NSUInteger const kTag_ReduceReloadTime = 69;

@interface LKAppMenuManager ()

@property(nonatomic, copy) NSDictionary<NSNumber *, NSString *> *delegatingTagToSelMap;

@end

@implementation LKAppMenuManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKAppMenuManager *instance = nil