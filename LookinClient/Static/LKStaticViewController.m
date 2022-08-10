//
//  LKMainViewController.m
//  Lookin
//
//  Created by Li Kai on 2018/8/4.
//  https://lookin.work
//

#import "LKStaticViewController.h"
#import "LKSplitView.h"
#import "LKStaticHierarchyDataSource.h"
#import "LKStaticHierarchyController.h"
#import "LKPreviewController.h"
#import "LKDashboardViewController.h"
#import "LKLaunchViewController.h"
#import "LKProgressIndicatorView.h"
#import "LKWindowController.h"
#import "LKStaticWindowController.h"
#import "LKTipsView.h"
#import "LKAppsManager.h"
#import "LKStaticAsyncUpdateManager.h"
#import "LKNavigationManager.h"
#import "LKConsoleViewController.h"
#import "LookinDisplayItem.h"
#import "LKTutorialManager.h"
#import "LKPreferenceManager.h"
#import "LKMeasureController.h"
@import AppCenter;
@import AppCenterAnalytics;

@interface LKStaticViewController () <NSSplitViewDelegate>

@property(nonatomic, strong) LKSplitView *mainSplitView;
@property(nonatomic, strong) LKSplitView *rightSplitView;
@property(nonatomic, strong) LKBaseView *splitTopView;

@property(nonatomic, strong) LKTipsView *imageSyncTipsView;
@property(nonatomic, strong) LKRedTipsView *tooLargeToSyncScreenshotTipsView;
@property(nonatomic, strong) LKTipsView *userConfigNoPreviewTipsView;
@property(nonatomic, strong) LKTipsView *noPreviewTipView;
@property(nonatomic, strong) LKTipsView *tutorialTipView;
@property(nonatomic, strong) LKTipsView *delayReloadTipView;

@property(nonatomic, strong) LKDashboardViewController *dashboardController;
@property(nonatomic, strong) LKStaticHierarchyController *hierarchyController;
@property(nonatomic, strong) LKConsoleViewController *consoleController;
@property(nonatomic, strong) LKMeasureController *measureController;

@end

@implementation LKStaticViewController

- (NSView *)makeContainerView {
    self.mainSplitView = [LKSplitView new];
    self.mainSplitView.didFinishFirstLayout = 