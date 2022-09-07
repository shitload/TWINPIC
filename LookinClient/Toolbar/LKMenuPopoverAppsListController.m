//
//  LKMenuPopoverAppsListController.m
//  Lookin
//
//  Created by Li Kai on 2018/11/5.
//  https://lookin.work
//

#import "LKMenuPopoverAppsListController.h"
#import "LKAppsManager.h"
#import "LKLaunchAppView.h"
#import "LookinHierarchyInfo.h"
#import "LKStaticHierarchyDataSource.h"

@interface LKMenuPopoverAppsListController ()

@property(nonatomic, strong) NSArray<LKLaunchAppView *> *appViews;

@property(nonatomic, strong) LKLabel *titleLabel;
@property(nonatomic, strong) LKLabel *subtitleLabel;
@property(nonatomic, strong) LKTextControl *tutorialControl;

@end

@implementation LKMenuPopoverAppsListController {
    CGFloat _appViewInterSpace;
    NSEdgeInsets _insets;
    CGFloat _titleMarginBottom;
    CGFloat _subtitleMarginBottom;
}

- (instancetype)initWithApps:(NSArray<LKInspectableApp *> *)apps source:(MenuPopoverAppsListControllerEventSource)source {
    if (self = [self init]) {
        _insets = NSEdgeInsetsMake(9, 18, 35, 14);
        _titleMarginBottom = 3;
        _subtitleMarginBottom = 5;
        _appViewInterSpace = 1