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
        
    } else if (ShortCocoaEqualClass(obj, NSAttributedStri