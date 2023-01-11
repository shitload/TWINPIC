//
//  LKTutorialPopoverController.m
//  Lookin
//
//  Created by Li Kai on 2019/7/17.
//  https://lookin.work
//

#import "LKTutorialPopoverController.h"

@interface LKTutorialPopoverController ()

@property(nonatomic, strong) NSImageView *imageView;
@property(nonatomic, strong) LKLabel *label;
@property(nonatomic, strong) NSButton *closeButton;

@property(nonatomic, weak) NSPopover *popover;

@end

@implementation LKTutorialPopoverController {
    NSEdgeInsets _insets;
    CGFloat _labelMarginL