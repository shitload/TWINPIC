//
//  LKConsoleSelectPopoverItemControl.m
//  Lookin
//
//  Created by Li Kai on 2019/6/19.
//  https://lookin.work
//

#import "LKConsoleSelectPopoverItemControl.h"

@interface LKConsoleSelectPopoverItemControl ()

@property(nonatomic, strong) NSImageView *imageView;
@property(nonatomic, strong) LKLabel *titleLabel;
@property(nonatomic, strong) LKLabel *subtitleLabel;

@end

@implementation LKConsoleSelectPopoverItemControl {
    CGFloat _subtitleMarginTop;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        _s