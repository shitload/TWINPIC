
//
//  LKBaseControl.m
//  Lookin
//
//  Created by Li Kai on 2018/8/28.
//  https://lookin.work
//

#import "LKBaseControl.h"

@interface LKBaseControl ()

@end

@implementation LKBaseControl

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        self.wantsLayer = YES;
    }
    return self;
}

- (BOOL)isFlipped {
    return YES;
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    if (self.adjustAlphaWhenClick) {
        self.alphaValue = .8;
    }
}