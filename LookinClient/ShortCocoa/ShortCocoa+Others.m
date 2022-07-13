//
//  ShortCocoa+Others.m
//  ShortCocoa
//
//  Copyright © 2018年 hughkli. All rights reserved.
//

#import "ShortCocoa+Others.h"
#import "ShortCocoa+Private.h"

@implementation ShortCocoa (Others)

- (ShortCocoa * (^)(ShortCocoaColor))textColor {
    return ^(ShortCocoaColor color) {
        id UI_or_NS_Color = [ShortCocoaHelper colorFromShortCocoaColor:color];
        if (self.cachedAttrString.length) {
            [self.cachedAttrString addAttribute:NSForegroundColorAttributeName value: