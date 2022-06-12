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
- (ShortCocoa * (^)(CGFloat)