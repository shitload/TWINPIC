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
    return [self initWithTitle:title messages:messages options:options];
}

- (instancetype)initWithTitle:(NSString *)title messages:(NSArray<NSString *> *)messages options:(NSArray<NSString *> *)options {
    if (self = [self initWithFrame:NSZeroRect]) {
        
        _isEnabled = YES;
        self.messages = messages;
        
        self.titleLabel = [LKLabel new];
        self.titleLabel.stringValue = title;
        self.titleLabel.font = NSFontMake(IsEnglish ? 13 : 15);
        [self addSubview:self.titleLabel];
