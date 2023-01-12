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
    CGFloat _labelMarginLeft;
}

- (instancetype)initWithText:(NSString *)text popover:(NSPopover *)popover {
    if (self = [self initWithContainerView:nil]) {
        _insets = NSEdgeInsetsMake(12, 8, 10, 8);
        _labelMarginLeft = 5;
        
        self.label.stringValue = text;
        
        self.popover = popover;
    }
    return self;
}

- (NSView *)makeContainerView {
    NSView *containerView = [super makeContainerView];
    
    self.imageView = [NSImageView new];
    self.imageView.image = NSImageMake(@"Icon_Inspiration");
    [containerV