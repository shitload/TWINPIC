//
//  LKMethodTraceMenuItemView.m
//  Lookin
//
//  Created by Li Kai on 2019/5/24.
//  https://lookin.work
//

#import "LKMethodTraceMenuItemView.h"

@interface LKMethodTraceMenuItemView ()

@property(nonatomic, strong) NSImageView *imageView;
@property(nonatomic, strong) LKLabel *label;
@property(nonatomic, strong) NSButton *deleteButton;

@end

@implementation LKMethodTraceMenuItemView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        self.imageView = [NSImageView new];
        [self addSubview:self.imageView];
        
        self.label = [LKLabel new];
        self.label.font = [NSFont systemFontOfSize:12];
        self.label.maximumN