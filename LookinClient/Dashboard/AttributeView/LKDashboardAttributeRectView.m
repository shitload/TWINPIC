//
//  LKDashboardAttributeRectView.m
//  Lookin
//
//  Created by Li Kai on 2019/6/10.
//  https://lookin.work
//

#import "LKDashboardAttributeRectView.h"
#import "LKNumberInputView.h"
#import "LKTextFieldView.h"
#import "LKDashboardViewController.h"

@interface LKDashboardAttributeRectView () <NSTextFieldDelegate>

@property(nonatomic, copy) NSArray<LKNumberInputView *> *mainInputsView;

@end

@implementation LKDashboardAttributeRectView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        //        self.layer.borderWidth = 1;
        //        self.layer.borderColor = [NSColor redColor].CGColor;
        
        NSArray<NSString *> *titles = @[@"X", @"Y", @"W", @"H"];
        self.mainInputsView = [NSArray lookin_arrayWithCount:4 block:^id(NSUInteger idx) {
            LKNumberInputView *view = [LKNumberInputView new];
            view.title = titles[idx];
            view.viewStyle = LKNumberInputViewStyleHorizontal;
            view.textFieldView.textField.delegate = self;
            view.textFieldView.backgroundColorName = @"DashboardCardValueBGColor";
            [self addSubview:view];
            return view;
        }];
    }
    return self;
}

- (void)layout {
    [super layout];
    CGFloat itemWidth = (self.$width - DashboardAttrItemHorInterspace) / 2.0;
    [self.mainInputsView enumerateObjectsUsingBlock:^(LKNumberInputView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x, y;
        if (idx == 0 || idx == 2) {
    