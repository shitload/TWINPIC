//
//  LKLabel.m
//  Lookin
//
//  Created by Li Kai on 2018/8/4.
//  https://lookin.work
//

#import "LKLabel.h"

@interface LKLabel ()

@end

@implementation LKLabel

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        self.wantsLayer = YES;
        self.backgroundColor = [NSColor clearColor];
        [self setBezeled:NO];
        [self setDrawsBackground:YES];
        [self setEditable:NO];
        [self setSelectable:NO];
        
        [self _updateColors];
    }
    return self;
}

- (void)setStringValue:(NSString *)stringValue {
    //