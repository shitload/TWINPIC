//
//  LKDashboardSearchInputView.m
//  Lookin
//
//  Created by Li Kai on 2019/9/5.
//  https://lookin.work
//

#import "LKDashboardSearchInputView.h"
#import "LKPreferenceManager.h"

@interface LKDashboardSearchInputView () <NSTextFieldDelegate>

@property(nonatomic, strong) NSImageView *iconImageView;
@property(nonatomic, strong) NSTextField *textField;

@end

@implementation LKDashboardSearchInputView {
    CGFloat _iconXWhenActive;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        _iconXWhenActive = 11;
        
        self.layer.cornerRadius = Das