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
            self.titleView.image = NSImageMake(@"Constraint_Popover_Info");
            self.titleView.insets = NSEdgeInsetsMake(0, _horInset, 0, _horInset);
            [self.view addSubview:self.titleView];
        }
        
        self.textsView = [LKTextsMenuView new];
        self.textsView.verSpace = 8;
        self.textsView.horSpace = 4;
        self.textsView.font = NSFontMake(13);
        self.textsView.type = LKTextsMenuViewTypeCenter;
        [self.view addSubview:self.textsView];
    
        NSMutableArray<LookinStringTwoTuple *> *texts = [NSMutableArray array];
        [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"FirstItem" second:[LookinAutoLayoutConstraint descriptionWithItemObject:constraint.firstItem type:constraint.firstItemType detailed:YES]]];
        [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"FirstAttribute" second:[LookinAutoLayoutConstraint descriptionWithAttribute:constraint.firstAttribute].lk_capitalizedString]];
        [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"Relation" second:[LookinAutoLayoutConstraint descriptionWithRelation:constraint.relation]]];
        [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"SecondItem" second:[LookinAutoLayoutConstraint descriptionWithItemObject:constraint.secondItem type:constraint.secondItemType detailed:YES]]];
        [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"SecondAttribute" second:[LookinAutoLayoutConstraint descriptionWithAttribute:constraint.secondAttribute].lk_capitalizedString]];
        [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"Multiplier" second:[NSString stringWithFormat:@"%@", @(constraint.multiplier)]]];
        [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"Constant" second:[NSString stringWithFormat:@"%@", @(constraint.constant)]]];
        [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"Priority" second:[NSString stringWithFormat:@"%@", @(constraint.priority)]]];
        [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"Active" second:constraint.active ? @"YES" : @"NO"]];
        [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"ShouldBeArchived" second:constraint.shouldBeArchived ? @"YES" : @"NO"]];
        [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"Identifier" second:constraint.identifier ? : @""]];
   