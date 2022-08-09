//
//  LKMainViewController.h
//  Lookin
//
//  Created by Li Kai on 2018/8/4.
//  https://lookin.work
//

#import <Cocoa/Cocoa.h>

@class LKPreviewController, LKProgressIndicatorView, LKHierarchyView;

@interface LKStaticViewController : LKBaseViewController

@property(nonatomic, strong, readonly) LKPreviewController *viewsPreviewController;

@property(nonatomic, strong) LKProgressIndicatorView *progressView;

@property(nonatomic, assign) BOOL showConsole;

- (void)showDelayReloadTipWithSeconds:(NSInteger)seconds;
- (void)removeDelayReloadTip;

/// 获取当前的 hierarchyView
- (LKHierarchyView *)currentHierarchyView;

#pragma mark - Tutorials

- (v