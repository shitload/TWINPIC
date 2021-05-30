//
//  LKDashboardAttributeRowsCountView.m
//  Lookin
//
//  Created by Li Kai on 2019/6/12.
//  https://lookin.work
//

#import "LKDashboardAttributeRowsCountView.h"
#import "LKNumberInputView.h"
#import "LKTextFieldView.h"
#import "LKDashboardViewController.h"

@interface LKDashboardAttributeRowsCountView ()

@property(nonatomic, copy) NSArray<LKNumberInputView *> *inputsView;

@end

@implementation LKDashboardAttributeRowsCountView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        //        self.layer.borderWidth = 1;
        //        self.layer.borderColor = [NSColor redColor].CGColor;
        
        self.inputsView = [NSArray array];
    }
    return self;
}

- (void)layout {
    [super layout];
    [self.inputsVie