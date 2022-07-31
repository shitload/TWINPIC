//
//  ShortCocoa+String.h
//  ShortCocoa
//
//  Copyright © 2018年 hughkli. All rights reserved.
//

#import "ShortCocoaCore.h"
#import "ShortCocoaDefines.h"
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShortCocoa (String)

/**
 将被包装对象转换为 NSString 并返回
 
 @code
 $(@"abc").string;  // => @"abc"
 @endcode
 */
- (nullable NSString *)string;

/**
 将被包装对象转换为 NSAttributedString 并返回
 
 @code
 // => [[NSAttributedString alloc] initWithString:@"abc"]
 $(@"abc").attrString;
 @endcode
 */
- (nullable NSAttributedString *)attrString;

/**
 将被包装对象转换为 NSMutableAttributedString 并返回
 
 @code
 // => [[NSMutableAttributedString alloc] initWithString:@"abc"]
 $(@"abc").mAttrString;
 @endcode
 */
- (nullable NSMutableAttributedString *)mAttrString;

/**
 在开头添加字符串
 
 @note 传入参数支持 ShortCocoa, NSString, NSAttributedString, NSNumber，详见 ShortCocoaString
 @code
 $(@"bc").prepend(@"a").string; // => @"abc"
 @endcode
 */
- (ShortCocoa * (^)(_Nullable ShortCocoaString))prepend;

/**
 在指定位置添加字符串
 
 @note 传入参数支持 ShortCocoa, NSString, NSAttributedString