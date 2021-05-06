//
//  LKConstraintPopoverController.m
//  Lookin
//
//  Created by Li Kai on 2019/9/28.
//  https://lookin.work
//

#import "LKConstraintPopoverController.h"
#import "LookinAutoLayoutConstraint.h"
#import "LKTextsMenuView.h"
#import "LKTextFieldView.h"
#import "LookinObject.h"

@interface LKConstraintPopoverController ()

@property(nonatomic, strong) LKTextFieldView *titleView;
@property(nonatomic, strong) LKTextsMenuView *textsView;
@property(nonatomic, strong) LookinAutoLayoutConstraint *constraint;

@end

@implementation LKConstraintPopoverController {
    CGFloat _horInset;
    CGFloat _insetBottom;
    CGFloat _titleHeight;
    CGFloat _textsViewMarginTop;
}

- (instancetype)initWithConstraint:(LookinAutoLayoutConstraint *)constraint {
    if (self = [self initWithContainerView:nil]) {
        _horInset = 5;
        _insetBottom = 10;
        _titleHeight = 26;
        _textsViewMarginTop = 10;
        self.constraint = constraint;
        
        if (!constraint.effective) {
            self.titleView = [LKTextFieldView labelView];
            self.titleView.textField.font = NSFontMake(IsEnglish ? 12 : 13);
            self.titleView.textColors = LKColorsCombine(NSColorGray1, NSColorGray9);
            self.titleView.textField.alignment = NSTextAlignmentCenter;
            self.titleView.textField.stringValue = NSLocalizedString(@"The layout of selected view is not affected by this constraint.", nil);
            self.titleView.backgroundColors = LKColorsCombine(LookinColorRGBAMake(0, 0, 0, 0.1), LookinColorRGBAMake(0, 0, 0, 0.2));
            self.ti