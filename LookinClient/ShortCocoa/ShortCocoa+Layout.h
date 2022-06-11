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
 
 @warning 使用这一系列布局方法时会自动像素对齐来获得更好的渲染效果，比如在一个屏幕 scale 为 2 的设备上，你写下 $(view).x(0.3)，则实际上 view.frame.origin 会被设置为 0.5