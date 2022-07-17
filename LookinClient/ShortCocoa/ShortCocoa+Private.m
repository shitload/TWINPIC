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
    NSMutableAttributedString *string = objc_getAssociatedObject(self, &kAssociatedObjectKey_ShortCocoaCac