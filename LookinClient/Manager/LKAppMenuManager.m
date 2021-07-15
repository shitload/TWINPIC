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
    static LKAppMenuManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)setup {
    self.delegatingTagToSelMap = @{
                                   @(kTag_Reload):NSStringFromSelector(@selector(appMenuManagerDidSelectReload)),
                                   @(kTag_Dimension):NSStringFromSelector(@selector(appMenuManagerDidSelectDimension)),
                                   @(kTag_ZoomIn):NSStringFromSelector(@selector(appMenuManagerDidSelectZoomIn)),
                                   @(kTag_ZoomOut):NSStringFromSelector(@selector(appMenuManagerDidSelectZoomOut)),
                                   @(kTag_DecreaseInterspace):NSStringFromSelector(@selector(appMenuManagerDidSelectDecreaseInterspace)),
                                   @(kTag_IncreaseInterspace):NSStringFromSelector(@selector(appMenuManagerDidSelectIncreaseInterspace)),
                                   @(kTag_Expansion):NSStringFromSelector(@selector(appMenuManagerDidSelectExpansionIndex:)),
                                   @(kTag_Export):NSStringFromSelector(@selector(appMenuManagerDidSelectExport)),
                                   @(kTag_OpenInNewWindow):NSStringFromSelector(@selector(appMenuManagerDidSelectOpenInNewWindow)),
                                   @(kTag_Filter):NSStringFromSelector(@selector(appMenuManagerDidSelectFilter)),
                                   @(kTag_DelayReload):NSStringFromSelector(@selector(appMenuManagerDidSelectDelayReload)),
                                   @(kTag_MethodTrace):NSStringFromSelector(@selector(appMenuManagerDidSelectMethodTrace)),
    };
    
    NSMenu *menu = [NSApp mainMenu];
    
    // Lookin
    NSMenu *menu_lookin = [menu itemAtIndex:0].submenu;
    menu_lookin.autoenablesItems = NO;
    menu_lookin.delegate = self;
    
    NSMenuItem *menuItem_about = [menu_lookin itemWithTag:kTag_About];
    menuItem_about.target = self;
    menuItem_about.action = @selector(_handleAbout);
    
    // Lookin - 偏好设置
    NSMenuItem *menuItem_preferences = [menu_lookin itemWithTag:kTag_Preferences];
    menuItem_preferences.target = self;
    menuItem_preferences.action = @selector(_handlePreferences);
    
    NSMenuItem *menuItem_checkUpdates = [menu_lookin itemWithTag:kTag_CheckUpdates];
    menuItem_checkUpdates.target = self;
    menuItem_checkUpdates.action = @selector(_handleCheckUpdates);
    
    // 文件
    NSMenu *menu_file = [menu itemAtIndex:1].submenu;
    menu_file.autoenablesItems = NO;
    menu_file.delegate = self;
    
    // 视图
    NSMenu *menu_view = [menu itemAtIndex:3].submenu;
    menu_view.autoenablesItems = NO;
    menu_view.delegate = self;
    
    // 帮助
    NSMenu *menu_help = [menu itemAtIndex:5].submenu;
    menu_help.autoenablesItems = YES;
    menu_help.delegate = self;
    
    // 帮助 - 显示 Framework
    NSMenuItem *menuItem_showFramework = [menu_help itemWithTag:kTag_ShowFramework];
    menuItem_showFramework.target = self;
    menuItem_showFramework.action = @selector(_handleShowFramework);
    
    // 帮助 - CocoaPods
    NSMenuItem *menuItem_cocoaPods = [menu_help itemWithTag:kTag_CocoaPods];
    menuItem_cocoaPods.target = self;
    menuItem_cocoaPods.action = @selector(_handleShowCocoaPods);
    
    // 帮助 - 官方网站
    NSMenuItem *menuItem_showWebsite = [menu_help itemWithTag:kTag_ShowWebsite];
    menuItem_showWebsite.target = self;
    menuItem_showWebsite.action = @selector(_handleShowWebsite);
    
    // 帮助 - 创建配置文件
    NSMenuItem *menuItem_showConfig = [menu_help itemWithTag:kTag_ShowConfig];
    menuItem_showConfig.target = self;
    menuItem_showConfig.action = @selector(_handleShowConfig);
    
    // 帮助 - 在 iOS 上使用 Lookin
    NSMenuItem *menuItem_showLookiniOS = [menu_help itemWithTag:kTag_ShowLookiniOS];
    menuItem_showLookiniOS.target = self;
    menuItem_showLookiniOS.action = @selector(_handleShowLookiniOS);
    
    NSMenuItem *menuItem_viewDeveloperProfile = [menu_help itemWithTag:kTag_DeveloperProfile];
    menuItem_viewDeveloperProfile.target = self;
    menuItem_viewDeveloperProfile.action = @selector(_handleShowDeveloperProfile);
    
    NSMenu *sourceCodeMenu = [menu_help itemWithTag:kTag_GitHub].submenu;
    {
        NSMenuItem *item = [sourceCodeMenu itemWithTag:kTag_LookinClientGitHub];
        item.target = self;
        item.action = @selector(_handleShowLookinClientGithub);
    }
    
    {
        NSMenuItem *item = [sourceCodeMenu itemWithTag:kTag_LookinServerGitHub];
        item.target = self;
        item.action = @selector(_handleShowLookinServerGithub);
    }
    
    NSMenu *issuesMenu = [menu_help itemWithTag:kTag_ReportIssues].submenu;
    {
        NSMenuItem *item = [issuesMenu itemWithTag:kTag_Email];
        item.target = self;
        item.action = @selector(_handleEmail);
    }
    {
        NSMenuItem *item = [issuesMenu itemWithTag:kTag_LookinClientGitHubIssues];
        item.target = self;
        item.action = @selector(_handleClientIssues);
    }
    {
        NSMenuItem *item = [issuesMenu itemWithTag:kTag_LookinServerGitHubIssues];
        item.target = self;
        item.action = @selector(_handleServerIssues);
    }
    {
        NSMenuItem *item = [issuesMenu itemWithTag:kTag_Weibo];
        item.target = self;
        item.action = @selector(_handleWeibo);
    }
    
    {
        NSMenuItem *item = [menu_help itemWithTag:kTag_CopyPod];
        item.target = self;
        item.action = @selector(_handleCopyPod);
    }
    {
        NSMenuItem *item = [menu_help itemWithTag:kTag_CopySPM];
        item.target = self;
        item.action = @selector(_handleCopySPM);
    }
    {
        NSMenuItem *item = [menu_help itemWithTag:kTag_MoreIntegrationGuide];
        item.target = self;
        item.action = @selector(_handleOpenMoreIntegrationGuide);
    }
    {
        NSMenuItem *item = [menu_help itemWithTag:kTag_ReduceReloadTime];
        item.target = self;
        item.action = @selector(_handleCustomUserConfig);
    }
    
    NSArray *itemArray = [menu_file.itemArray arrayByAddingObjectsFromArray:menu_view.itemArray];
    [itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *selString = self.delegatingTagToSelMap[@(obj.tag)];
        if (selString) {
            if (obj.hasSubmenu) {
                if (obj.tag == kTag_Expansion) {
                    // 视图 - 深度
                    [obj.submenu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull expansionSubItem, NSUInteger idx, BOOL * _Nonnull stop) {
                        expansionSubItem.target = self;
                        expansionSubItem.representedObject = @(idx);
                        expansionSubItem.action = @selector(_handleExpansion:);
                  