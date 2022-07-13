
//
//  ShortCocoa+Others.h
//  ShortCocoa
//
//  Copyright © 2018年 hughkli. All rights reserved.
//

#import "ShortCocoaCore.h"
#import "ShortCocoaDefines.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Appkit/Appkit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface ShortCocoa (Others)

/**
 设置 UILabel / UIButton 的文字颜色，或者给 NSAttributedString 添加 NSForegroundColorAttributeName
 
 @note 支持的被包装对象：UILabel, UIButton, 以及 ShortCocoaString
 @note 传入值支持 UIColor 或 RGB, RGBA, HEX 或 @"red" 等字符串，详见 ShortCocoaColor 定义
 
 @code
 
 // 等价于 [[UILabel new] setTextColor:redColor]
 $(UILabel).textColor(redColor);
 
 // 等价于 [[UIButton new] setTitleColor:redColor forState:UIControlStateNormal]
 $(UIButton).textColor(redColor);
 
 // 等价于 [NSAttributedString alloc] initWithString:@"abc" attributes:@{NSForegroundColorAttributeName:color}
 $(@"abc").textColor(color).attrString;
 