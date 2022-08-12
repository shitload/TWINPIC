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
    self.mainSplitView.didFinishFirstLayout = ^(LKSplitView *view) {
        CGFloat x = MIN(MAX(350, view.bounds.size.width * .3), 700);
        [view setPosition:x ofDividerAtIndex:0];
    };
    self.mainSplitView.arrangesAllSubviews = NO;
    self.mainSplitView.vertical = YES;
    self.mainSplitView.dividerStyle = NSSplitViewDividerStyleThin;
    self.mainSplitView.delegate = self;
    return self.mainSplitView;
}

- (void)setView:(NSView *)view {
    [super setView:view];
    
    LKPreferenceManager *preferenceManager = [LKPreferenceManager mainManager];
    [preferenceManager.isMeasuring subscribe:self action:@selector(_handleToggleMeasure:) relatedObject:nil];
    
    LKStaticHierarchyDataSource *dataSource = [LKStaticHierarchyDataSource sharedInstance];
    
    self.hierarchyController = [[LKStaticHierarchyController alloc] initWithDataSource:dataSource];
    [self addChildViewController:self.hierarchyController];
    [self.mainSplitView addArrangedSubview:self.hierarchyController.view];
    
    self.rightSplitView = [LKSplitView new];
    self.rightSplitView.arrangesAllSubviews = YES;
    self.rightSplitView.vertical = NO;
    self.rightSplitView.dividerStyle = NSSplitViewDividerStyleThin;
    self.rightSplitView.delegate = self;
    [self.mainSplitView addArrangedSubview:self.rightSplitView];
    
    self.splitTopView = [LKBaseView new];
    [self.rightSplitView addArrangedSubview:self.splitTopView];
    
    _viewsPreviewController = [[LKPreviewController alloc] initWithDataSource:dataSource];
    self.viewsPreviewController.staticViewController = self;
    [self.splitTopView addSubview:self.viewsPreviewController.view];
    [self addChildViewController:self.viewsPreviewController];
    
    self.dashboardController = [[LKDashboardViewController alloc] initWithStaticDataSource:dataSource];
    [self.splitTopView addSubview:self.dashboardController.view];
    [self addChildViewController:self.dashboardController];
    
    self.measureController = [[LKMeasureController alloc] initWithDataSource:dataSource];
    self.measureController.view.hidden = YES;
    [self.splitTopView addSubview:self.measureController.view];
    [self addChildViewController:self.measureController];
    
    self.imageSyncTipsView = [LKTipsView new];
    self.imageSyncTipsView.hidden = YES;
    [self.view a