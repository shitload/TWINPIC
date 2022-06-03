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
    [LKNavigati