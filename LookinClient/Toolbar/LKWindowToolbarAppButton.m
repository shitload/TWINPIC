//
//  LKWindowToolbarAppView.m
//  LookinClient
//
//  Created by 李凯 on 2020/6/14.
//  Copyright © 2020 hughkli. All rights reserved.
//

#import "LKWindowToolbarAppButton.h"
#import "LookinAppInfo.h"

@interface LKWindowToolbarAppButton ()

@property(nonatomic, strong) NSImageView *appImageView;
@property(nonatomic, strong) LKLabel *appNameLabel;
@property(nonatomic, strong) NSImageView *sepImageView;
@property(nonatomic, strong) NSImageView *deviceImageView;
@property(nonatomic, strong) LKLabel *deviceLabel;

@property(nonatomic, assign) CGFloat appImageWidth;
@property(nonatomic, copy) NSArray<NSNumber *> *spaces;

@end

@implementation LKWindowToolbarAppButton

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        self.title = @"";
        self.appImageWidth = 14;
        self.spaces = @[@7, @3, @3, @4, @1];
        
        self.appImageView = [NSImageView new];
        self.appImageView.wantsLayer = YES;
        self.appImageView.layer.cornerRadius = 2;
        self.appImageView.layer.masksToBounds = YES;
        [self addSubview:self.appImageView];
        
        self.appNameLabel = [LKLabel new];
        self.appNameLabel.textColors = LKColorsCombine(LookinColorMake(65, 65, 65), [NSColor labelColor]);
        [self addSubview:self.appNameLabel];
        
        self.sepImageView = [NSImageView new];
        self.sepImageView.image = NSImageMake(@"icon_go_forward");
        self.sepImageView.image.template = YES;
        [self addSubview:self.sepImageView];
        
        self.deviceImageView = [NSImageView new];
        [self addSubview:self.deviceImageView];
        
        self.deviceLabel = [LKLabel new];
        self.deviceLabel.textColors = LKColorsCombine(LookinColorMak