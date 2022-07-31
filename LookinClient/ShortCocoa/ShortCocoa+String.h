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
- (nullabl