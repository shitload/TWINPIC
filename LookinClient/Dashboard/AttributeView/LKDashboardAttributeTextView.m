//
//  LKDashboardAttributeTextView.m
//  Lookin
//
//  Created by Li Kai on 2019/9/16.
//  https://lookin.work
//

#import "LKDashboardAttributeTextView.h"
#import "LKDashboardViewController.h"

@interface LKDashboardAttributeTextView () <NSTextViewDelegate>

@property(nonatomic, strong) NSScrollView *scrollView;
@property(nonatomic, strong) NSTextView *textView;

@end

@implementation LKDashboardAttributeTextView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        self.scrollView = [LKHelper scrollableTextView];
        self.scrollView.wantsLayer = YES;
        self.scrollView.layer.cornerRadius = DashboardCardControlCornerRadius;
        self.textView = self.scrollView.documentView;
        self.textView.font = NSFontMake(12);
        self.textView.backgroundColor = [NSColor colorNamed:@"DashboardCardValueBGColor"];
        self.textView.textContainerInset = NSMakeSize(2, 4);
        self.textView.delegate = self;
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)layout {
    [super layout];
    $(self.scrollView).fullFrame;
}

- (void)renderWithAttribute {
    [super renderWithAttribute];
    /// nil 居然会 crash
    self.textView.string = self.attribute.value ? : @"";
    self.textView.editable = self.canEdit;
}

- (NSSize)sizeThatFits:(NSSize)limitedSize {
    limi