//
//  NSButton+LookinClient.m
//  Lookin
//
//  Created by Li Kai on 2019/5/25.
//  https://lookin.work
//

#import "NSButton+LookinClient.h"

@implementation NSButton (LookinClient)

+ (instancetype)lk_normalButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    NSButton *button = [NSButton new];
    button.bezelStyle = NSBezelStyleRounded;
    button.title = title;
    button.font = [NSFont systemFontOfSize:13];
    button.target = ta