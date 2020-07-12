//
//  ShortCocoa+LookinClient.m
//  Lookin
//
//  Created by Li Kai on 2018/12/8.
//  https://lookin.work
//

#import "ShortCocoa+LookinClient.h"
#import <objc/runtime.h>
#import "ShortCocoa+Private.h"
#import "LKBaseView.h"

@implementation ShortCocoa (Lookin)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oriMethod = class_getInstanceMethod([self class], @selector(sizeToFit));
        Method newMethod = class_getInstanceMethod([self class], @selector(lookin_sizeToFit));
        method_exchangeImplementations(oriMethod, newMethod);
        
        Method oriMethod1 = class_getInstanceMethod([self class], @selector(heightToFit));
        Method newMethod1 = class_getInstanceMethod([self class], @selector(lookin_heightToFit));
        method_exchangeImplementations(oriMethod1, newMethod1);
    });
}

- (ShortCocoa *)lookin_sizeToFit {
    [self unpackClassA:[LKBaseView class] doA:^(LKBaseView * _Nonnull view, BOOL * _Nonnull stop) {
        NSSize size = [view si