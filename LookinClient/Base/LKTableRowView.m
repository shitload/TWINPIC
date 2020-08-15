//
//  LKTableRowView.m
//  Lookin
//
//  Created by Li Kai on 2019/4/20.
//  https://lookin.work
//

#import "LKTableRowView.h"
#import "LookinDefines.h"

@interface LKTableRowView ()

@property(nonatomic, strong) CALayer *backgroundColorLayer;

@property(nonatomic, assign, readwrite) BOOL isDarkMode;

@end

@implementation LKTableRowView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        self.wantsLayer = YES;
        
        self.backgroundColorLayer = [CALayer layer];
        [self.backgroundColorLayer lookin_removeImplicitAnimations];
        [self.layer addSublayer:self.backgroundColorLayer];
        
        _titleLabel = [LKLabel new];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMidd