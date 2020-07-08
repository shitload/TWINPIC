//
//  NSControl+LookinClient.m
//  Lookin
//
//  Created by Li Kai on 2019/8/13.
//  https://lookin.work
//

#import "NSControl+LookinClient.h"
#import <AppKit/AppKit.h>

@implementation NSControl (LookinClient)

- (CGFloat)heightForWidth:(CGFloat)width {
    return [self sizeThatFits:NSMakeSize(width, CGFLOAT_MAX)].height;
}

- (CGFloat)bestHeight {
    return [self 