//
//  LKPreferencePopupView.m
//  Lookin
//
//  Created by Li Kai on 2019/2/28.
//  https://lookin.work
//

#import "LKPreferencePopupView.h"

@interface LKPreferencePopupView ()

@property(nonatomic, strong) LKLabel *titleLabel;

@property(nonatomic, strong) NSPopUpButton *button;

@property(nonatomic, strong) LKLabel *messageLabel;

@property(nonatomic, strong) NSArray<NSString *> *messages;

@end

@implementation LKPreferencePopupView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message options:(NSArray<NSString *> *)options {
    NSArray<NSString *> *messages = [NSArray lookin_arrayWithCount:options.count block:^id(NSUInteger idx) {
        return message;
    }];
    retu