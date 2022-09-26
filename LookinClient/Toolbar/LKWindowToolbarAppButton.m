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
