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
        
        self.layer.cornerRadius = DashboardCardCornerRadius;
        self.layer.borderWidth = 1;
        
        self.iconImageView = [NSImageView new];
        self.iconImageView.image = NSImageMake(@"icon_search");
        [self addSubview:self.iconImageView];
    
        self.textField = [NSTextField new];
        self.textField.placeholderString = @"搜索属性或方法";
        self.textField.delegate = self;
        self.textField.focusRingType = NSFocusRingTypeNone;
        self.textField.editable = YES;
        self.textField.bordered = NO;
        self.textField.bezeled = NO;
        self.textField.usesSingleLineMode = YES;
        self.textField.backgroundColor = [NSColor clearColor];
        self.textField.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textField.font = NSFontMake(13);
        self.textField.hidden = YES;
        [self addSubview:self.textField];
        
        @weakify(self);
        [[self.textField.rac_textSignal throttle:0.3] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(dashboardSearchInputView:didInputString:)]) {
                [self.delegate dashboardSearchInputView:self didInputString:x];
            }
        }];
        
        [self updateColors];
    }
    return self;
}

- (void)layout {
    [super layout];
    if (self.isActive) {
        $(self.iconImageView).sizeToFit.x(_iconXWhenActive);
    } else {
        $(self.iconImageView).sizeToFit.centerAlign;
    }
    $(self.textField).x(30).toRight(2).heightToFit.verAlign;
}

- (void)updateColors {
    [super updateColors];
    if (self.isActive) {
        self.layer.borderColor = self.isDarkMode ? LookinColorM