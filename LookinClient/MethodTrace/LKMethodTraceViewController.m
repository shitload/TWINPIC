//
//  LKMethodTraceViewController.m
//  Lookin
//
//  Created by Li Kai on 2019/5/23.
//  https://lookin.work
//

#import "LKMethodTraceViewController.h"
#import "LKSplitView.h"
#import "LKMethodTraceMenuView.h"
#import "LKMethodTraceDetailView.h"
#import "LKMethodTraceDataSource.h"
#import "LKNavigationManager.h"
#import "LKMethodTraceSelectMethodContentView.h"
#import "LKWindow.h"
#import "LKAppsManager.h"
#import "LKMethodTraceLaunchView.h"
#import "LKTutorialManager.h"

@interface LKMethodTraceViewController () <NSSplitViewDelegate>

@property(nonatomic, strong) LKSplitView *splitView;

@property(nonatomic, strong) LKMethodTraceMenuView *menuView;
@property(nonatomic, strong) LKMethodTraceDetailView *detailView;

@property(nonatomic, strong) LKMethodTraceLaunchView *launchView;

@property(nonatomic, strong) LKMethodTraceDataSource *dataSource;

@end

@implementation LKMethodTraceViewController

- (NSView *)makeContainerView {
    self.dataSource = [LKMethodTraceDataSource new];
    [LKNavigationManager sharedInstance].activeMethodTraceDataSource = self.dataSource;
    
    self.splitView = [[LKSplitView alloc] init];
    self.splitView.didFinishFirstLayout = ^(LKSplitView *view) {
        CGFloat totalWidth = view.bounds.size.width;
        [view setPosition:totalWidth * .3 ofDividerAtIndex:0];
    };
    self.splitView.arrangesAllSubviews = NO;
    self.splitView.vertical = YES;
    self.splitView.dividerStyle = NSSplitViewDividerStyleThin;
    self.splitView.delegate = self;
    
    self.menuView = [[LKMethodTraceMenuView alloc