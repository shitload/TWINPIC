//
//  ShortCocoa+Layout.m
//  ShortCocoa
//
//  Copyright © 2018年 hughkli. All rights reserved.
//

#import "ShortCocoa+Layout.h"
#import "ShortCocoa+Private.h"

#if TARGET_OS_IPHONE
    #define NS_UI_View UIView
#elif TARGET_OS_MAC
    #define NS_UI_View NSView
#endif

@implementation ShortCocoa (Layout)

#pragma mark - 基础方法

- (ShortCocoa *)sizeToFit {
#if TARGET_OS_IPHONE
    [self unpack:[UIView class] do:^(UIView *view, BOOL *stop) {
        [view sizeToFit];
    }];
#