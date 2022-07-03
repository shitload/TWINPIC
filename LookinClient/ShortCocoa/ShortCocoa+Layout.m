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
            layer.frame = rect;
        }];
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))midX {
    return ^(CGFloat value) {
        if (isnan(value)) {
            NSAssert(NO, @"传入了 NaN");
            value = 0;
        }
        [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
            CGFloat width = CGRectGetWidth(view.bounds);
            ShortCocoaMake(view).x(value - width / 2);
            
        } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
            CGFloat width = CGRectGetWidth(layer.bounds);
            ShortCocoaMake(layer).x(value - width / 2);
        }];
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))maxX {
    return ^(CGFloat value) {
        if (isnan(value)) {
            NSAssert(NO, @"传入了 NaN");
            value = 0;
        }
        [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
            CGFloat width = CGRectGetWidth(view.bounds);
            ShortCocoaMake(view).x(value - width);
            
        } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
            CGFloat width = CGRectGetWidth(layer.bounds);
            ShortCocoaMake(layer).x(value - width);
        }];
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))midY {
    return ^(CGFloat value) {
        if (isnan(value)) {
            NSAssert(NO, @"传入了 NaN");
            value = 0;
        }
        [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
            CGFloat height = CGRectGetHeight(view.bounds);
            ShortCocoaMake(view).y(value - height / 2);
            
        } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
            CGFloat height = CGRectGetHeight(layer.bounds);
            ShortCocoaMake(layer).y(value - height / 2);
        }];
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))maxY {
    return ^(CGFloat value) {
        if (isnan(value)) {
            NSAssert(NO, @"传入了 NaN");
            value = 0;
        }
        [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
            CGFloat height = CGRectGetHeight(view.bounds);
            ShortCocoaMake(view).y(value - height);
            
        } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
            CGFloat height = CGRectGetHeight(layer.bounds);
            ShortCocoaMake(layer).y(value - height);
        }];
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))right {
    return ^(CGFloat value) {
        if (isnan(value)) {
            NSAssert(NO, @"传入了 NaN");
            value = 0;
        }
        [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
            if (view.superview) {
                CGFloat superWidth = CGRectGetWidth(view.superview.bounds);
                ShortCocoaMake(view).maxX(superWidth - value);
            } else {
                NSAssert(NO, @"必须存在 superview 才可使用该方法");
            }
            
        } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
            if (layer.superlayer) {
                CGFloat superWidth = CGRectGetWidth(layer.superlayer.bounds);
                ShortCocoaMake(layer).maxX(superWidth - value);
            } else {
                NSAssert(NO, @"必须存在 superlayer 才可使用该方法");
            }
        }];
        
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))bottom {
    return ^(CGFloat value) {
        if (isnan(value)) {
            NSAssert(NO, @"传入了 NaN");
            value = 0;
        }
#if TARGET_OS_IPHONE
        [self unpackClassA:[UIView class] doA:^(UIView *view, BOOL *stop) {
            if (view.superview) {
                CGFloat superHeight = CGRectGetHeight(view.superview.bounds);
                ShortCocoaMake(view).maxY(superHeight - value);
            } else {
                NSAssert(NO, @"必须存在 superview 才可使用该方法");
            }
#elif TARGET_OS_MAC
        [self unpackClassA:[NSView class] doA:^(NSView *view, BOOL *stop) {
            if (view.superview) {
                CGFloat superHeight = view.superview.bounds.size.height;
                if (view.superview.isFlipped) {
                    ShortCocoaMake(view).maxY(superHeight - value);
                } else {
                    ShortCocoaMake(view).y(value);
                }
            } else {
                NSAssert(NO, @"必须存在 superview 才可使用该方法");
            }
#endif
        } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
            if (layer.superlayer) {
                if (layer.superlayer.contentsAreFlipped) {
                    CGFloat superHeight = CGRectGetHeight(layer.superlayer.bounds);
                    ShortCocoaMake(layer).maxY(superHeight - value);
                } else {
                    ShortCocoaMake(layer).y(value);
                }
            } else {
                NSAssert(NO, @"必须存在 superlayer 才可使用该方法");
            }
        }];
        return self;
    };
}

- (ShortCocoa *)horAlign {
    [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
        if (view.superview) {
            CGFloat superWidth = CGRectGetWidth(view.superview.bounds);
            ShortCocoaMake(view).midX(superWidth / 2);
        } else {
            NSAssert(NO, @"必须存在 superview 才可使用该方法");
        }
    } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
        if (layer.superlayer) {
            CGFloat superWidth = CGRectGetWidth(layer.superlayer.bounds);
            ShortCocoaMake(layer).midX(superWidth / 2);
        } else {
            NSAssert(NO, @"必须存在 superlayer 才可使用该方法");
        }
    }];
    return self;
}

- (ShortCocoa *)verAlign {
    [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
        if (view.superview) {
            CGFloat superHeight = CGRectGetHeight(view.superview.bounds);
            ShortCocoaMake(view).midY(superHeight / 2);
        } else {
            NSAssert(NO, @"必须存在 superview 才可使用该方法");
        }
        
    } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
        if (layer.superlayer) {
            CGFloat superHeight = CGRectGetHeight(layer.superlayer.bounds);
            ShortCocoaMake(layer).midY(superHeight / 2);
        } else {
            NSAssert(NO, @"必须存在 superlayer 才可使用该方法");
        }
    }];
    return self;
}

- (ShortCocoa *)centerAlign {
    return self.verAlign.horAlign;
}

- (ShortCocoa *)fullWidth {
    self.x(0).toRight(0);
    return self;
}

- (ShortCocoa *)fullHeight {
    [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
        if (view.superview) {
            CGFloat superHeight = CGRectGetHeight(view.superview.bounds);
            ShortCocoaMake(view).height(superHeight).y(0);
        } else {
            NSAssert(NO, @"必须存在 superview 才可使用该方法");
        }
    } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
        if (layer.superlayer) {
            CGFloat superHeight = CGRectGetHeight(layer.superlayer.bounds);
            ShortCocoaMake(layer).height(superHeight).y(0);
        } else {
            NSAssert(NO, @"必须存在 superlayer 才可使用该方法");
        }
    }];
    return self;
}

- (ShortCocoa *)fullFrame {
    return self.fullWidth.fullHeight;
}

- (ShortCocoa * (^)(CGFloat))offsetX {
    return ^(CGFloat x) {
        self.offset(x, 0);
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))offsetY {
    return ^(CGFloat y) {
        self.offset(0, y);
        return self;
    };
}

#pragma mark - Group Set 系列

- (ShortCocoa * (^)(CGFloat))groupX {
    return ^(CGFloat value) {
        self.offsetX(value - self.$groupX);
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))groupMidX {
    return ^(CGFloat value) {
        self.offsetX(value - self.$groupMidX);
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))groupMaxX {
    return ^(CGFloat value) {
        self.offsetX(value - self.$groupMaxX);
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))groupY {
    return ^(CGFloat value) {
        self.offsetY(value - self.$groupY);
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))groupMidY {
    return ^(CGFloat value) {
        self.offsetY(value - self.$groupMidY);
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))groupMaxY {
    return ^(CGFloat value) {
        self.offsetY(value - self.$groupMaxY);
        return self;
    };
}

- (ShortCocoa * (^)(CGPoint))groupOrigin {
    return ^(CGPoint value) {
        self.offset(value.x - self.$groupX, value.y - self.$groupY);
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))groupRight {
    return ^(CGFloat value) {
        if (![self allPackedViewsAndLayersAreInTheSameCoordinate]) {
            return self;
        }
        
        __block CGFloat superWidth = 0;
        [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
            superWidth = CGRectGetWidth(view.superview.bounds);
            *stop = YES;
        } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
            superWidth = CGRectGetWidth(layer.superlayer.bounds);
            *stop = YES;
        }];
        self.groupMaxX(superWidth - value);
        return self;
    };
}

- (ShortCocoa * (^)(CGFloat))groupBottom {
    return ^(CGFloat value) {
#if TARGET_OS_IPHONE
        CALayer *superlayer;
        if (![self allPackedViewsAndLayersAreInTheSameCoordinateWithSuperlayer:&superlayer superview:nil]) {
            return self;
        }
        if (superlayer.contentsAreFlipped) {
            self.groupMaxY(CGRectGetHeight(superlayer.bounds) - value);
        } else {
            self.groupY(value);
        }
        return self;
#elif TARGET_OS_MAC
        CALayer *superlayer;
        NSView *superview;
        if (![self allPackedViewsAndLayersAreInTheSameCoordinateWithSuperlayer:&superlayer superview:&superview]) {
            return self;
        }
        if (superlayer) {
            if (superlayer.contentsAreFlipped) {
                self.groupMaxY(CGRectGetHeight(superlayer.bounds) - value);
            } else {
                self.groupY(value);
            }
        } else if (superview) {
            if (superview.isFlipped) {
                self.groupMaxY(CGRectGetHeight(superlayer.bounds) - value);
            } else {
                self.groupY(value);
            }
        }
        return self;
#endif
    };
}

- (ShortCocoa *)groupHorAlign {
    if (![self allPackedViewsAndLayersAreInTheSameCoordinate]) {
        return self;
    }
    
    __block CGFloat superWidth = 0;
    [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
        superWidth = CGRectGetWidth(view.superview.bounds);
        *stop = YES;
    } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
        superWidth = CGRectGetWidth(layer.superlayer.bounds);
        *stop = YES;
    }];
    self.groupMidX(superWidth / 2);
    return self;
}

- (ShortCocoa *)groupVerAlign {
    if (![self allPackedViewsAndLayersAreInTheSameCoordinate]) {
        return self;
    }
    
    __block CGFloat superHeight = 0;
    [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
        superHeight = CGRectGetHeight(view.superview.bounds);
        *stop = YES;
    } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
        superHeight = CGRectGetHeight(layer.superlayer.bounds);
        *stop = YES;
    }];
    self.groupMidY(superHeight / 2);
    return self;
}

- (ShortCocoa *)groupCenterAlign {
    return self.groupVerAlign.groupHorAlign;
}

#pragma mark - Group Get 系列

- (CGFloat)$groupX {
    if ([self filteredGet:[NS_UI_View class], [CALayer class], nil].count > 1) {
        if (![self allPackedViewsAndLayersAreInTheSameCoordinate]) {
            return 0;
        }
    }
    __block CGFloat minX = 0;
    __block BOOL hasDeterminedMinX = NO;
    [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
        minX = hasDeterminedMinX ? MIN(minX, CGRectGetMinX(view.frame)) : CGRectGetMinX(view.frame);
        hasDeterminedMinX = YES;
    } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
        minX = hasDeterminedMinX ? MIN(minX, CGRectGetMinX(layer.frame)) : CGRectGetMinX(layer.frame);
        hasDeterminedMinX = YES;
    }];
    return minX;
}

- (CGFloat)$groupMidX {
    if ([self filteredGet:[NS_UI_View class], [CALayer class], nil].count > 1) {
        if (![self allPackedViewsAndLayersAreInTheSameCoordinate]) {
            return 0;
        }
    }
    CGFloat minX = self.$groupX;
    CGFloat maxX = self.$groupMaxX;
    CGFloat midX = minX + (maxX - minX) / 2;
    return midX;
}

- (CGFloat)$groupMaxX {
    if ([self filteredGet:[NS_UI_View class], [CALayer class], nil].count > 1) {
        if (![self allPackedViewsAndLayersAreInTheSameCoordinate]) {
            return 0;
        }
    }
    __block CGFloat maxX = 0;
    __block BOOL hasDeterminedMaxX = NO;
    [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
        maxX = hasDeterminedMaxX ? MAX(maxX, CGRectGetMaxX(view.frame)) : CGRectGetMaxX(view.frame);
        hasDeterminedMaxX = YES;
    } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
        maxX = hasDeterminedMaxX ? MAX(maxX, CGRectGetMaxX(layer.frame)) : CGRectGetMaxX(layer.frame);
        hasDeterminedMaxX = YES;
    }];
    return maxX;
}

- (CGFloat)$groupY {
    if ([self filteredGet:[NS_UI_View class], [CALayer class], nil].count > 1) {
        if (![self allPackedViewsAndLayersAreInTheSameCoordinate]) {
            return 0;
        }
    }
    __block CGFloat minY = 0;
    __block BOOL hasDeterminedMinY = NO;
    [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
        minY = hasDeterminedMinY ? MIN(minY, CGRectGetMinY(view.frame)) : CGRectGetMinY(view.frame);
        hasDeterminedMinY = YES;
    } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
        minY = hasDeterminedMinY ? MIN(minY, CGRectGetMinY(layer.frame)) : CGRectGetMinY(layer.frame);
        hasDeterminedMinY = YES;
    }];
    return minY;
}

- (CGFloat)$groupMidY {
    if ([self filteredGet:[NS_UI_View class], [CALayer class], nil].count > 1) {
        if (![self allPackedViewsAndLayersAreInTheSameCoordinate]) {
            return 0;
        }
    }
    CGFloat minY = self.$groupY;
    CGFloat maxY = self.$groupMaxY;
    CGFloat midY = minY + (maxY - minY) / 2;
    return midY;
}

- (CGFloat)$groupMaxY {
    if ([self filteredGet:[NS_UI_View class], [CALayer class], nil].count > 1) {
        if (![self allPackedViewsAndLayersAreInTheSameCoordinate]) {
            return 0;
        }
    }
    __block CGFloat maxY = 0;
    __block BOOL hasDeterminedMaxY = NO;
    [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
        maxY = hasDeterminedMaxY ? MAX(maxY, CGRectGetMaxY(view.frame)) : CGRectGetMaxY(view.frame);
        hasDeterminedMaxY = YES;
    } classB:[CALayer class] doB:^(CALayer *layer, BOOL *stop) {
        maxY = hasDeterminedMaxY ? MAX(maxY, CGRectGetMaxY(layer.frame)) : CGRectGetMaxY(layer.frame);
        hasDeterminedMaxY = YES;
    }];
    return maxY;
}

- (CGPoint)$groupOrigin {
    CGPoint origin = CGPointMake(self.$groupX, self.$groupY);
    return origin;
}

- (CGFloat)$groupWidth {
    if ([self filteredGet:[NS_UI_View class], [CALayer class], nil].count > 1) {
        if (![self allPackedViewsAndLayersAreInTheSameCoordinate]) {
            return 0;
        }
    }
    CGFloat maxX = self.$groupMaxX;
    CGFloat minX = self.$groupX;
    CGFloat width = maxX - minX;
    return width;
}

- (CGFloat)$groupHeight {
    if ([self filteredGet:[NS_UI_View class], [CALayer class], nil].count > 1) {
        if (![self allPackedViewsAndLayersAreInTheSameCoordinate]) {
            return 0;
        }
    }
    CGFloat maxY = self.$groupMaxY;
    CGFloat minY = self.$groupY;
    CGFloat height = maxY - minY;
    return height;
}

- (CGSize)$groupSize {
    if ([self filteredGet:[NS_UI_View class], [CALayer class], nil].count > 1) {
        if (![self allPackedViewsAndLayersAreInTheSameCoordinate]) {
            return CGSizeZero;
        }
    }
    CGFloat width = self.$groupWidth;
    CGFloat height = self.$groupHeight;
    CGSize size = CGSizeMake(width, height);
    return size;
}

#pragma mark - to 系列

- (ShortCocoa * (^)(CGFloat))toX {
    return ^(CGFloat value) {
        if (isnan(value)) {
            NSAssert(NO, @"传入了 NaN");
            value = 0;
        }
        
        [self unpackClassA:[NS_UI_View class] doA:^(NS_UI_View *view, BOOL *stop) {
            CGFloat safeValue = value;
            if (safeValue > CGRectGetMaxX(view.frame)) {
                safeValue = CGRectGetMaxX(view.frame);
            }
            
            CGRect rect = view.frame;
            CGFloat width = CGRectGetMaxX(rect) - safeVal