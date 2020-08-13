//
//  LKPopPanel.m
//  Lookin
//
//  Created by Li Kai on 2019/9/28.
//  https://lookin.work
//

#import "LKPopPanel.h"

@implementation LKPopPanel

- (instancetype)initWithSize:(NSSize)size {
    // 如果不是 NSWindowStyleMaskNonactivatingPanel 的话，当显示该 window 时点击别的 app，整个 Lo