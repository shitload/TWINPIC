//
//  LKTextsMenuView.m
//  Lookin
//
//  Created by Li Kai on 2019/8/14.
//  https://lookin.work
//

#import "LKTextsMenuView.h"

@interface LKTextsMenuView ()

@property(nonatomic, strong) NSMutableArray<LKLabel *> *leftLabels;
@property(nonatomic, strong) NSMutableArray<LKLabel *> *rightLabels;

@property(nonatomic, strong) NSMutableDictionary<NSNumber *, NSButton *> *buttons;

@end

@implementation LKTextsMenuView {
    CGFloat _buttonMarg