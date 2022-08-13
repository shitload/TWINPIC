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
    [self.view addSubview:self.imageSyncTipsView];
    
    self.delayReloadTipView = [LKTipsView new];
    self.delayReloadTipView.hidden = YES;
    [self.view addSubview:self.delayReloadTipView];
    
    self.tooLargeToSyncScreenshotTipsView = [LKRedTipsView new];
    self.tooLargeToSyncScreenshotTipsView.image = NSImageMake(@"icon_info");
    self.tooLargeToSyncScreenshotTipsView.title = NSLocalizedString(@"Image is too large to be displayed.", nil);
    self.tooLargeToSyncScreenshotTipsView.hidden = YES;
    [self.view addSubview:self.tooLargeToSyncScreenshotTipsView];
    
    self.noPreviewTipView = [LKTipsView new];
    self.noPreviewTipView.image = NSImageMake(@"icon_hide");
    self.noPreviewTipView.title = NSLocalizedString(@"The screenshot of selected item is not displayed.", nil);
    self.noPreviewTipView.buttonText = NSLocalizedString(@"Display", nil);
    self.noPreviewTipView.target = self;
    self.noPreviewTipView.clickAction = @selector(_handleNoPreviewTipView);
    self.noPreviewTipView.hidden = YES;
    [self.view addSubview:self.noPreviewTipView];
    
    self.userConfigNoPreviewTipsView = [LKTipsView new];
    self.userConfigNoPreviewTipsView.image = NSImageMake(@"icon_hide");
    self.userConfigNoPreviewTipsView.title = NSLocalizedString(@"The screenshot is not displayed due to the config in iOS App.", nil);
    self.userConfigNoPreviewTipsView.buttonText = NSLocalizedString(@"Details", nil);
    self.userConfigNoPreviewTipsView.target = self;
    self.userConfigNoPreviewTipsView.clickAction = @selector(_handleUserConfigNoPreviewTipView);
    self.userConfigNoPreviewTipsView.hidden = YES;
    [self.view addSubview:self.userConfigNoPreviewTipsView];
    
    self.progressView = [LKProgressIndicatorView new];
    [self.view addSubview:self.progressView];
    
    @weakify(self);
    [RACObserve(dataSource, selectedItem) subscribeNext:^(LookinDisplayItem *item) {
        @strongify(self);
        BOOL showTips = (![item appropriateScreenshot] && item.doNotFetchScreenshotReason == LookinDoNotFetchScreenshotForTooLarge);
        BOOL shouldHide = !showTips;
        if (self.tooLargeToSyncScreenshotTipsView.hidden == shouldHide) {
            return;
        }
        self.tooLargeToSyncScreenshotTipsView.hidden = shouldHide;
        if (shouldHide) {
            [self.tooLargeToSyncScreenshotTipsView endAnimation];
        } else {
            [self.tooLargeToSyncScreenshotTipsView startAnimation];
        }
        [self.view setNeedsLayout:YES];
    }];
    
    [RACObserve(dataSource, selectedItem) subscribeNext:^(LookinDisplayItem *item) {
        @strongify(self);
        BOOL showTips = (![item appropriateScreenshot] && item.doNotFetchScreenshotReason == LookinDoNotFetchScreenshotForUserConfig);
        self.userConfigNoPreviewTipsView.hidden = !showTips;
        [self.view setNeedsLayout:YES];
    }];
    
    [[[RACSignal merge:@[RACObserve(dataSource, selectedItem), dataSource.itemDidChangeNoPreview]] skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        LookinDisplayItem *item = dataSource.selectedItem;
        BOOL shouldShowNoPreviewTip = item.inNoPreviewHierarchy && item.doNotFetchScreenshotReason != LookinDoNotFetchScreenshotForUserConfig;
        if (shouldShowNoPreviewTip || !self.noPreviewTipView.hidden) {
            self.noPreviewTipView.title = [NSString stringWithFormat:NSLocalizedString(@"The screen