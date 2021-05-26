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
