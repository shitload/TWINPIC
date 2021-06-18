//
//  LKHierarchyHandlersPopoverItemView.m
//  Lookin
//
//  Created by Li Kai on 2019/8/11.
//  https://lookin.work
//

#import "LKHierarchyHandlersPopoverItemView.h"
#import "LookinEventHandler.h"
#import "LKTextsMenuView.h"
#import "LookinIvarTrace.h"
#import "LKAppsManager.h"
#import "LKNavigationManager.h"
#import "LKStaticWindowController.h"

@interface LKHierarchyHandlersPopoverItemView ()

@property(nonatomic, strong) LookinEventHandler *eventHandler;

@property(nonatomic, strong) NSImageView *iconImageView;

@property(nonatomic, strong) LKLabel *titleLabel;
@property(nonatomic, strong) LKLabel *subtitleLabel;
@property(nonatomic, strong) NSButton *recognizerEnableButton;


@property(nonatomic, strong) LKTextsMenuView *contentView;

@property(nonatomic, strong) CALayer *topSepLayer;


@end

@implementation LKHierarchyHandlersPopoverItemView {
    CGFloat _contentX;
    CGFloat _insetRight;
    CGFloat _verInset;
    CGFloat _contentMarginTop;
    CGFloat _subtitleMarginTop;
}

- (instancetype)initWithEventHandler:(LookinEventHandler *)eventHandler e