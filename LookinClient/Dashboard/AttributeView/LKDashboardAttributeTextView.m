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
        self.textView.backgroundColor = [NSColor color