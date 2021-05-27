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
            x = 0;
        } else {
            x = itemWidth + DashboardAttrItemHorInterspace;
        }
        if (idx == 0 || idx == 1) {
            y = 0;
        } else {
            y = LKNumberInputHorizontalHeight + DashboardAttrItemVerInterspace;
        }
        $(view).width(itemWidth).height(LKNumberInputHorizontalHeight).x(x).y(y);
    }];
}

- (NSSize)sizeThatFits:(NSSize)limitedSize {
    CGFloat height = LKNumberInputHorizontalHeight * 2 + DashboardAttrItemVerInterspace;
    limitedSize.height = height;
    return limitedSize;
}

- (void)renderWithAttribute {
    if (!self.attribute) {
        NSAssert(NO, @"");
        return;
    }
    if (![self.attribute.value isKindOfClass:[NSValue class]]) {
        NSAssert(NO, @"");
        return;
    }
    NSRect rect = ((NSValue *)self.attribute.value).rectValue;
    NSArray<NSString *> *mainStrs = @[[NSString lookin_stringFromDouble:rect.origin.x decimal:3],
                                  [NSString lookin_stringFromDouble:rect.origin.y decimal:3],
                                  [NSString lookin_stringFromDouble:rect.size.width decimal:3],
                                  [NSString lookin_