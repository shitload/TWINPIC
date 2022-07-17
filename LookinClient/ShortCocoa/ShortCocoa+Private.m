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
        re