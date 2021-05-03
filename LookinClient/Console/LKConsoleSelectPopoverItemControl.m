//
//  LKConsoleSelectPopoverItemControl.m
//  Lookin
//
//  Created by Li Kai on 2019/6/19.
//  https://lookin.work
//

#import "LKConsoleSelectPopoverItemControl.h"

@interface LKConsoleSelectPopoverItemControl ()

@property(nonatomic, strong) NSImageView *imageView;
@property(nonatomic, strong) LKLabel *titleLabel;
@property(nonatomic, strong) LKLabel *subtitleLabel;

@end

@implementation LKConsoleSelectPopoverItemControl {
    CGFloat _subtitleMarginTop;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        _subtitleMarginTop = 0;
        
        self.imageView = [NSImageView new];
        self.imageView.image = NSImageMake(@"Console_Checked");
        [self addSubview:self.imageView];
        
        self.titleLabel = [LKLabel new];
        self.titleLabel.font = NSFontMake(12);
        self.titleLabel.maximumNumberOfLines = 1;
        self.titleLabel.textColor = [NSColor labelColor];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:self.titleLabel];
    
        self.subtitleLabel = [LKLabel new];
        self.subtitleLabel.maximumNumberOfLines = 1;
        self.subtitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.subtitleLabel.font = NSFontMake(11);
        self.subtitleLabel.textColor = [NSColor secondaryLabelColor];
        self.subtitleLabel.hidden = YES;
        [self addSubview:self.subtitleLabel];
    }
    return self;
}

- (void)layout {
    [super layout];
    $(self.imageView).sizeToFit.x(3).verAlign;
    $(self.titleLabel).x(self.imageView.$maxX + 4).toRight(0).heightToFit;
    if (self.subtitleLabel.isVisible) {
  