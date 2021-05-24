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
        self.borderColors = LKColorsCombine(LookinColorMake(181, 181, 181), LookinColorMake(83, 83, 83));
        
        self.control = [LKTextControl new];
        self.control.adjustAlphaWhenClick = YES;
        self.control.label.stringValue = NSLocalizedString(@"Open Image with Preview…", nil);
        self.control.label.font = NSFontMake(11);
        [self.control addTarget:self clickAction:@selector(_handleClick)];
        [self addSubview:self.control];
    }
    return self;
}

- (void)layout {
    [super layout];
    $(self.control).fullFrame;
}

- (void)renderWithAttribute {
}

- (NSSize)sizeThatFits:(NSSize)limitedSize {
    limitedSize.height = LKNumberInputHorizontalHeight;
    return limitedSize;
}

- (void)_handleClick {
    NSNumber *imageViewOid_num = self.attribute.value;
    if (imageViewOid_num == nil) {
        AlertError(LookinErr_Inner, self.window);
        NSAssert(NO, @"");
        return;
    }
    
    unsigned long imageViewOid = [imageViewOid_num unsignedLongValue];

    LKDashboardViewController *dashController = self.dashboardViewController;
    if 