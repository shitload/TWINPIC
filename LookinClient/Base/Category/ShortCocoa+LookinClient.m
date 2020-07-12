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
        Me