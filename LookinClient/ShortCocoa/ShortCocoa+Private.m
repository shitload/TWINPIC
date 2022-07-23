//
//  ShortCocoa+Private.m
//  ShortCocoa
//
//  Copyright © 2018年 hughkli. All rights reserved.
//

#import "ShortCocoa+Private.h"
#import <objc/runtime.h>

@implementation ShortCocoa (Private)

- (void)unpack:(Class)classA do:(void (^)(id, BOOL *))handlerA {
    [self unpackClassA:classA doA:handlerA classB:nil doB:nil];
}

- (void)unpackClassA:(Class)classA doA:(void (^)(id, BOOL *))handlerA classB:(Class)classB doB:(void (^)(id, BOOL *))handlerB {
    if (!self.get) {
        return;
    }
    if (ShortCocoaEqualClass(self.get, NSArray)) {
        [self.get enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (ShortCocoaEqualClass(obj, classA)) {
                if (handlerA) {
                    handlerA(obj, stop);
                }
            } else if (ShortCocoaEqualClass(obj, classB)) {
                if (handlerB) {
                    handlerB(obj, stop);
                }
            }
        }];
    } else {
        BOOL shouldStop;
        if (ShortCocoaEqualClass(self.get, classA)) {
            if (handlerA) {
                handlerA(self.get, &shouldStop);
            }
        } else if (ShortCocoaEqualClass(self.get, classB)) {
            if (handlerB) {
                handlerB(self.get, &shouldStop);
            }
        }
    }
}

static char kAssociatedObjectKey_ShortCocoaCachedAttrStringKey;
- (NSMutableAttributedString *)cachedAttrString {
    NSMutableAttributedString *string = objc_getAssociatedObject(self, &kAssociatedObjectKey_ShortCocoaCachedAttrStringKey);
    if (!string) {
        string = [ShortCocoaHelper attrStringFromShortCocoaString:self.get];
        [self setCachedAttrString:string];
    }
    return string;
}
- (void)setCachedAttrString:(NSMutableAttributedString *)cachedAttrString {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_ShortCocoaCachedAttrStringKey, cachedAttrString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation ShortCocoaHelper

+ (NSMutableParagraphStyle *)paragraphStyleForAttributedString:(NSAttributedString *)string {
    NSRange effectiveRange;
    NSParagraphStyle *existingParaStyle = [string attribute:NSParagraphStyleAttributeName atIndex:0 longestEffectiveRange:&effectiveRange inRange:NSMakeRange(0, string.length)];
    NSMutableParagraphStyle *newParaStyle = nil;
    if (existingParaStyle && effectiveRange.length == string.length) {
        newParaStyle = [existingParaStyle mutableCopy];
    } else {
        newParaStyle = [[NSMutableParagraphStyle alloc] init];
    }
    return newParaStyle;
}

+ (NSArray<NSNumber *> *)fourNumbersFromShortCocoaQuad:(ShortCocoaQuad)obj {
    if (ShortCocoaEqualClass(obj, NSNumber)) {
        // @20
        return @[obj, obj, obj, obj];
    } else if (ShortCocoaEqualClass(obj, NSString)) {
        // @"12, 14, 15, 17"、@"13" 这种
        NSArray<NSNumber *> *numbers = [self numberArrayFromString:obj];
        return [self fourNumbersFromShortCocoaQuad:numbers];
        
    } else if (ShortCocoaEqualClass(obj, NSArray)) {
        __block BOOL isValid = YES;
        [(NSArray *)obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!ShortCocoaEqualClass(obj, NSNumber)) {
                isValid = NO;
                *stop = YES;
            }
        }];
        if (isValid) {
            NSArray<NSNumber *> *numbers = obj;
            if (numbers.count == 1) {
                // @[@20]
                return @[numbers[0], numbers[0], numbers[0], numbers[0]];
                
            } else if (numbers.count == 2) {
                // @[@20, @30]
                return @[numbers[0], numbers[1], numbers[0], numbers[1]];
                
            } else if (numbers.count == 3) {
                // @[@20, @30, @40]
                return @[numbers[0], numbers[1], numbers[2], numbers[1]];
                
            } else if (numbers.count == 4) {
                // @[@20, @30, @40, @50]
                return numbers;
            }
        }
    }
    NSAssert(NO, @"传入的参数无法识别，支持的参数列表请参看 ShortCocoaQuad 的注释");
    return nil;
}

+ (NSMutableAttributedString *)attrStringFromShortCocoaString:(ShortCocoaString)obj {
    __block NSMutableAttributedString *string = nil;
    if (ShortCocoaEqualClass(obj, NSString)) {
        string = [[NSMutableAttributedString alloc] initWithString:obj];
        
    } else if (ShortCocoaEqualClass(obj, NSAttributedString)) {
        string = [obj mutableCopy];
        
    } else if (ShortCocoaEqualClass(obj, NSNumber)) {
        string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", obj]];
        
    } else if (ShortCocoaEqualClass(obj, NSArray)) {
        [obj enumerateObjectsUsingBlock:^(id  _Nonnull comp, NSUInteger idx, BOOL * _Nonnull stop) {
            if (ShortCocoaEqualClass(comp, NSString)) {
                if (!string) {
                    string = [[NSMutableAttributedString alloc] init];
                }
                NSAttributedString *append = [[NSAttributedString alloc] initWithString:comp];
                [string appendAttributedString:append];
                
            } else if (ShortCocoaEqualClass(comp, NSAttributedString)) {
                if (!string) {
                    string = [[NSMutableAttributedString alloc] init];
                }
                [string appendAttributedString:comp];
                
            } else if (ShortCocoaEqualClass(comp, NSNumber)) {
                if (!string) {
                    string = [[NSMutableAttributedString alloc] init];
                }
                NSAttributedString *append = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", comp]];
                [string appendAttributedString:append];
            }
        }];
    } else if (ShortCocoaEqualClass(obj, ShortCocoa)) {
        string = ((ShortCocoa *)obj).cachedAttrString;
    }
    
    return string;
}

#if TARGET_OS_IPHONE

+ (nullable UIColor *)colorFromShortCocoaColor:(ShortCocoaColor)obj {
    if (!obj) {
        return nil;
    }
    if (ShortCocoaEqualClass(obj, UIColor)) {
        // UIColor
        return obj;
    }
    if (ShortCocoaEqualClass(obj, NSString)) {
        // @"red" 这种表意字符串
        NSDictionary *dict = [self colorStringDictionary];
        if (dict[obj]) {
            return dict[obj];
        }
        // @"122, 33, 344" 这种字符串
        NSArray *array = [self numberArrayFromString:obj];
        if (array.count == 3 || array.count == 4) {
            // 如果没有 alpha 值，则默认为 1（即不透明）
            CGFloat alpha = (array.count == 4) ? [array[3] floatValue] : 1;
            CGFloat r = [array[0] floatValue];
            CGFloat g = [array[1] floatValue];
            CGFloat b = [array[2] floatValue];
            return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
        }
        // Hex 字符串
        UIColor *finalColor = [self colorFromHexString:obj];
        if (finalColor) {
            return finalColor;
        }
    }
    NSAssert(NO, @"传入的颜色参数无法识别，支持的参数列表请参看 ShortCocoaColor 的注释");
    return nil;
}

+ (nullable UIImage *)imageFromShortCocoaImage:(nullable ShortCocoaImage)obj {
    if (!obj || ShortCocoaEqualClass(obj, UIImage)) {
        return obj;
    }
    if (ShortCocoaEqualClass(obj, NSString)) {
        return [UIImage imageNamed:obj];
    }
    NSAssert(NO, @"传入的图片参数无法识别，支持的参数类型为：1）UIImage 对象。   2）NSString，比如 @\"icon\" 等价于 [UIImage imageNamed:@\"icon\"]");
    return nil;
}

+ (UIFont *)fontFromShortCocoaFont:(ShortCocoaFont)obj {
    if (ShortCocoaEqualClass(obj, UIFont)) {
        // UIFont
        return obj;
    }
    if (ShortCocoaEqualClass(obj, NSNumber)) {
        // @12
        CGFloat fontSize = [obj doubleValue];
        UIFont *fontObj = [UIFont systemFontOfSize:fontSize];
        return fontObj;
    }
    if (ShortCocoaEqualClass(obj, NSString)) {
        // @"12"
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *number = [numberFormatter numberFromString:obj];
        CGFloat fontSize = [number doubleValue];
        UIFont *fontObj = [UIFont systemFontOfSize:fontSize];
        return fontObj;
    }
    NSAssert(NO, @"传入的字体参数无法识别，支持的参数类型为：1）UIFont 对象。    2）字符串或 NSNumber，比如 @\"15\"、@15 等价于 [UIFont systemFontOfSize:15]");
    return nil;
}

#elif TARGET_OS_MAC

+ (nullable NSColor *)colorFromShortCocoaColor:(ShortCocoaColor)obj {
    if (!obj) {
        return nil;
    }
    if (ShortCocoaEqualClass(obj, NSColor)) {
        // NSColor
        return obj;
    }
    if (ShortCocoaEqualClass(obj, NSString)) {
        // @"red" 这种表意字符串
        NSDictionary *dict = [self colorStringDictionary];
        if (dict[obj]) {
            return dict[obj];
        }
        // @"122, 33, 344" 这种字符串
        NSArray *array = [self numberArrayFromString:obj];
        if (array.count == 3 || array.count == 4) {
            // 如果没有 alpha 值，则默认为 1（即不透明）
            CGFloat alpha = (array.count == 4) ? [array[3] floatValue] : 1;
            CGFloat r = [array[0] floatValue];
            CGFloat g = [array[1] floatValue];
            CGFloat b = [array[2] floatValue];
            return [NSColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
        }
        // Hex 字符串
        NSColor *finalColor = [self colorFromHexString:obj];
        if (finalColor) {
            return finalColor;
        }
    }
    NSAssert(NO, @"传入的颜色参数无法识别，支持的参数列表请参看 ShortCocoaColor 的注释");
    return nil;
}

+ (nullable NSImage *)imageFromShortCocoaImage:(nullable ShortCocoaImage)obj {
    if (!obj || ShortCocoaEqualClass(obj, NSImage)) {
        return obj;
    }
    if (ShortCocoaEqualClass(obj, NSString)) {
        return [NSImage imageNamed:obj];
    }
    NSAssert(NO, @"传入的图片参数无法识别，支持的参数类型为：1）NSImage 对象。   2）NSString，比如 @\"icon\" 等价于 [NSImage imageNamed:@\"icon\"]");
    return nil;
}

+ (NSFont *)fontFromShortCocoaFont:(ShortCocoaFont)obj {
    if (ShortCocoaEqualClass(obj, NSFont)) {
        // UIFont
        return obj;
    }
    if (ShortCocoa