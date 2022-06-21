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
#elif TARGET_OS_MAC
    [self unpack:[NSControl class] do:^(NSControl *control, BOOL *stop) {
        [control sizeToFit];
    }];
#endif
    return self;
}

- (ShortCocoa * (^)(CGFloat))width {
    return ^(CGFloat value) {
        if (isnan(value)) {
            NSAssert(NO, @"传入了 NaN");
            value = 0;
        }
        
        [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
            CGRect rect = view.frame;
            rect.size.width = CGFloatSnapToPixel(value);
            view.frame = rect;
        } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
            CGRect rect = layer.frame;
            rect.size.width = CGFloatSnapToPixel(value);
            layer.frame = rect;
        }];
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))height {
    return ^(CGFloat value) {
        if (isnan(value)) {
            NSAssert(NO, @"传入了 NaN");
            value = 0;
        }
        
        [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
            CGRect rect = view.frame;
            rect.size.height = CGFloatSnapToPixel(value);
            view.frame = rect;
        } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
            CGRect rect = layer.frame;
            rect.size.height = CGFloatSnapToPixel(value);
            layer.frame = rect;
        }];
        return self;
    };
}

- (ShortCocoa * (^)(CGSize))size {
    return ^(CGSize value) {
        return self.width(value.width).height(value.height);
    };
}

- (ShortCocoa * (^)(CGRect))frame {
    return ^(CGRect value) {
        return self.origin(value.origin).size(value.size);
    };
}

- (ShortCocoa * (^)(CGFloat))x {
    return ^(CGFloat value) {
        if (isnan(value)) {
            NSAssert(NO, @"传入了 NaN");
            value = 0;
        }
        [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
            CGRect rect = view.frame;
            rect.origin.x = CGFloatSnapToPixel(value);
            view.frame = rect;
            
        } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
            CGRect rect = layer.frame;
            rect.origin.x = CGFloatSnapToPixel(value);
            layer.frame = rect;
        }];
        
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))y {
    return ^(CGFloat value) {
        if (isnan(value)) {
            NSAssert(NO, @"传入了 NaN");
            value = 0;
        }
        [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
            CGRect rect = view.frame;
            rect.origin.y = CGFloatSnapToPixel(value);
            view.frame = rect;
            
        } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
            CGRect rect = layer.frame;
            rect.origin.y = CGFloatSnapToPixel(value);
            layer.frame = rect;
        }];
        return self;
    };
}

- (ShortCocoa * (^)(CGPoint))origin {
    return ^(CGPoint value) {
        return self.x(value.x).y(value.y);
    };
}

- (ShortCocoa * (^)(CGFloat, CGFloat))offset {
    return ^(CGFloat x, CGFloat y) {
        if (isnan(x)) {
            NSAssert(NO, @"传入了 NaN");
            x = 0;
        }
        if (isnan(y)) {
            NSAssert(NO, @"传入了 NaN");
            y = 0;
        }
        [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
            CGRect rect = view.frame;
            rect.origin.x = CGFloatSnapToPixel(CGRectGetMinX(view.frame) + x);
            rect.origin.y = CGFloatSnapToPixel(CGRectGetMinY(view.frame) + y);
            view.frame = rect;
        } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
            CGRect rect = layer.frame;
            rect.origin.x = CGFloatSnapToPixel(CGRectGetMinX(layer.frame) + x);
            rect.origin.y = CGFloatSnapToPixel(CGRectGetMinY(layer.frame) + y);
       