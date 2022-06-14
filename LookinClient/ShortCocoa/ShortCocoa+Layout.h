//
//  ShortCocoa+Layout.h
//  ShortCocoa
//
//  Copyright © 2018年 hughkli. All rights reserved.
//

#import "ShortCocoaCore.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Appkit/Appkit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 如果注释中不做特殊说明，则此文件里这些方法均同时支持 UIView/NSView 和 CALayer
 
 @warning 使用这一系列布局方法时会自动像素对齐来获得更好的渲染效果，比如在一个屏幕 scale 为 2 的设备上，你写下 $(view).x(0.3)，则实际上 view.frame.origin 会被设置为 0.5，详情参看 ShortCocoa+Layout.m 里的 CGFloatSnapToPixel 的注释
 */
@interface ShortCocoa (Layout)

#pragma mark - 基础方法

/// 等价于调用系统控件的 sizeToFit 方法，支持的被包装对象：UIView(iOS)、NSControl(macOS)，
- (ShortCocoa *)sizeToFit;

/// 修改 frame.size.width
- (ShortCocoa * (^)(CGFloat))width;
/// 修改 frame.size.height
- (ShortCocoa * (^)(CGFloat))height;
/// 修改 frame.size
- (ShortCocoa * (^)(CGSize))size;
/// 修改 frame
- (ShortCocoa * (^)(CGRect))frame;
/// 修改 frame.origin.x，size 不会被改变
- (ShortCocoa * (^)(CGFloat))x;
/// 修改 frame 的 midX 位置，size 不会被改变
- (ShortCocoa * (^)(CGFloat))midX;
/// 修改 frame 的 maxX 位置，size 不会被改变
- (ShortCocoa * (^)(CGFloat))maxX;
/// 修改 frame.origin.y，size 不会被改变
- (ShortCocoa * (^)(CGFloat))y;
/// 修改 frame 的 midY 位置，size 不会被改变
- (ShortCocoa * (^)(CGFloat))midY;
/// 修改 frame 的 maxY 位置，size 不会被改变
- (ShortCocoa * (^)(CGFloat))maxY;
/// 修改 frame.origin，size 不会被改变
- (ShortCocoa * (^)(CGPoint))origin;
/// 修改 frame 的 origin，使得右侧和 superview 的右侧的距离为传入值，size 不会被改变
- (ShortCocoa * (^)(CGFloat))right;
///修改 frame 的 origin，使得底部和 superview 的底部的距离为传入值，size 不会被改变
- (ShortCocoa * (^)(CGFloat))bottom;
/// 修改 frame 的 origin，使得在 superview 里水平居中，size 不会被改变
- (ShortCocoa *)horAlign;
/// 修改 frame 的 origin，使得在 superview 里垂直居中，size 不会被改变
- (ShortCocoa *)verAlign;
/// 修改 frame 的 origin，使得在 superview 里同时保持垂直、水平居中，size 不会被改变
- (ShortCocoa *)centerAlign;
/// 修改 frame 使得在水平方向上撑满父元素，即把 x 设置为 0，把 width 设置为 superview/superlayer 的 width
- (ShortCocoa *)fullWidth;
/// 修改 frame 使得在竖直方向上撑满父元素，即把 y 设置为 0，把 height 设置为 superview/superlayer 的 height
- (ShortCocoa *)fullHeight;
/// 修改 frame 为 superview.bounds 或 superlayer.bounds
- (ShortCocoa *)fullFrame;

/// 偏移 frame 的 origin，size 不会被改变
- (ShortCocoa * (^)(CGFloat x, CGFloat y))offset;
/// 偏移 frame 的 origin.x，size 不