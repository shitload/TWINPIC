//
//  LKDashboardAttributeOpenImageView.m
//  Lookin
//
//  Created by Li Kai on 2019/10/7.
//  https://lookin.work
//

#import "LKDashboardAttributeOpenImageView.h"
#import "LKNumberInputView.h"
#import "LKDashboardViewController.h"
#import "LKAppsManager.h"

@interface LKDashboardAttributeOpenImageView ()

@property(nonatomic, strong) LKTextControl *control;

@end

@implementation LKDashboardAttributeOpenImageView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = DashboardCardControlCornerRadius;
        self.borderColors