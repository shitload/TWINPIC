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
        _appViewInterSpace = 1;
        
        NSString *title = nil;
        NSString *subtitle = nil;
        if (source == MenuPopoverAppsListControllerEventSourceReloadButton || source == MenuPopoverAppsListControllerEventSourceNoConnectionTips) {
            title = NSLocalizedString(@"Connection lost", nil);
            if (apps.count == 0) {
                subtitle = NSLocalizedString(@"And no inspectable app was found", nil);
            } else if (apps.count == 1) {
                subtitle = NSLocalizedString(@"Click the screenshot below to Change App", nil);
            } else {
                subtitle = [NSString stringWithFormat:NSLocalizedString(@"Other %@ apps were found", nil), @(apps.count)];
            }
            
        } else if (source == MenuPopoverAppsListControllerEventSourceAppButton) {
            if (apps.count) {
                if (apps.count == 1) {
                    title = NSLocalizedString(@"1 active app was found", nil);
                } else {
                    title = [NSString stringWithFormat:NSLocalizedString(@"%@ active apps were found", nil), @(apps.count)];
                }
                subtitle = NSLocalizedString(@"Click the screenshot below to inspect", nil);
            } else {
                title = NSLocalizedString(@"No inspectable app was found", nil);
            }
        } else {
            NSAssert(NO, @"");
        }
        
        if (apps.count) {
            self.appViews = [apps.rac_sequence map:^id _Nullable(LKInspectableApp *app) {
                LKLaunchAppView *view = [LKLaunchAppView new];
                view.compactLayout = YES;
                view.app = app;
                [view addTarget:self clickAction:@selector(handleClickAppView:)];
                [self.view addSubview:view];
                return view;
            }].array;
        }
        
        if (title.length) {
            self.titleLabel = [LKLabel new];
            self.titleLabel.alignment = NSTextAlignmentCenter;
            self.titleLabel.font = NSFontMake(14);
            self.titleLabel.textColor = [NSColor labelColor];
            self.titleLabel.stringValue = title;
            [self.view addSubview:self.titleLabel];
        }
    
        if (subtitle.length) {
            self.subtitleLabel = [LKLabel new];
            self.subtitleLabel.alignment = NSTextAlignmentCenter;
            self.subtitleLabel.font = NSFontMake(12);
            self.subtitleLabel.textColor = [NSColor labelColor];
            self.subtitleLabel.stringValue = subtitle;
            [self.view addSubview:self.subtitleLabel];
        }
        
        self.tutorialControl = [LKTextControl new];
        self.tutorialControl.layer.cornerRadius = 4;
        self.tutorialControl.label.stringValue = NSLocalizedString(@"Can't see your app ?", nil);
        self.tutorialControl.label.textColor = [NSColor linkColor];
        self.tutorialCont