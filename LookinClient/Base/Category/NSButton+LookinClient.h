//
//  NSButton+LookinClient.h
//  Lookin
//
//  Created by Li Kai on 2019/5/25.
//  https://lookin.work
//

@interface NSButton (LookinClient)

/// size 已经被设置好
+ (instancetype)lk_normalButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/// 只有图片的按钮，没有 bor