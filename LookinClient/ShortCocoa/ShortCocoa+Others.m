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
            [self.cachedAttrString addAttribute:NSForegroundColorAttributeName value:UI_or_NS_Color range:NSMakeRange(0, self.cachedAttrString.length)];
            
        } else {
#if TARGET_OS_IPHONE
            UIColor *textColor = [ShortCocoaHelper colorFromShortCocoaColor:color];
            [self unpackClassA:[UIButton class] doA:^(UIButton * _Nonnull obj, BOOL *stop) {
                [obj setTitleColor:textColor forState:UIControlStateNormal];
            } classB:[UILabel class] doB:^(UILabel * _Nonnull obj, BOOL *stop) {
                [obj setTextColor:textColor];
            }];
#endif
        }
        return self;
    };
}

- (ShortCocoa * (^)(ShortCocoaFont))font {
    return ^(ShortCocoaFont value) {
        id UI_or_NS_Font = [ShortCocoaHelper fontFromShortCocoaFont:value];
        if (self.cachedAttrString.length) {
            [self.cachedAttrString addAttribute:NSFontAttributeName value:UI_or_NS_Font range:NSMakeRange(0, self.cachedAttrString.length)];
            
        } else {
#if TARGET_OS_IPHONE
            if (UI_or_NS_Font) {
                [self unpackClassA:[UIButton class] doA:^(UIButton * _Nonnull obj, BOOL *stop) {
                    obj.titleLabel.font 