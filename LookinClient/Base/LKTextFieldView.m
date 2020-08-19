
//
//  LKTextFieldView.m
//  Lookin
//
//  Created by Li Kai on 2019/2/27.
//  https://lookin.work
//

#import "LKTextFieldView.h"

@interface LKTextFieldView ()

@property(nonatomic, strong) NSImageView *imageView;


@end

@implementation LKTextFieldView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {        
        _textField = [NSTextField new];
        [self addSubview:self.textField];
    }
    return self;
}

+ (instancetype)labelView {
    LKTextFieldView *view = [LKTextFieldView new];
    view.textField.wantsLayer = YES;
    view.textField.backgroundColor = [NSColor clearColor];
    [view.textField setBezeled:NO];
    [view.textField setDrawsBackground:YES];
    [view.textField setEditable:NO];
    [view.textField setSelectable:NO];
    return view;
}

- (void)layout {
    [super layout];
    if (self.imageView) {
        if (self.textField.editable) {
            // 比如 hierarchy 底部的搜索框
            $(self.imageView).sizeToFit.x(self.insets.left).verAlign.offsetY(1);
            if (self.closeButton) {
                $(self.closeButton).y(1).toBottom(0).width(100).right(self.insets.right);
                $(self.textField).x(self.imageView.$maxX + 5).toMaxX(self.closeButton.$x - 5).heightToFit.verAlign;
            } else {
                $(self.textField).x(self.imageView.$maxX + 5).toRight(self.insets.right).heightToFit.verAlign;
            }
            
        } else {
            // 纯 label，比如 autoLayout popover 的标题
            $(self.imageView, self.textField).sizeToFit.verAlign;
            $(self.textField).x(self.imageView.$maxX);
            $(self.imageView, self.textField).groupHorAlign;
        }
    } else {
        $(self.textField).x(self.insets.left).toRight(self.insets.right).heightToFit.verAlign.offsetY(self.insets.top - self.insets.bottom);
    }
}

- (NSSize)sizeThatFits:(NSSize)limitedSize {
    CGFloat textFieldMaxWidth = limitedSize.width - self.insets.left - self.insets.right;
    if (self.imageView) {
        textFieldMaxWidth -= self.image.size.width;
    }
    NSSize textFieldSize = [self.textField sizeThatFits:NSMakeSize(textFieldMaxWidth, CGFLOAT_MAX)];
    
    CGFloat resultHeight = textFieldSize.height + self.insets.top + self.insets.bottom;
    CGFloat resultWidth = textFieldSize.width + self.insets.left + self.insets.right;
    if (self.imageView) {
        resultWidth += self.image.size.width;
    }
    return NSMakeSize(resultWidth, resultHeight);
}

- (void)setInsets:(NSEdgeInsets)insets {
    _insets = insets;
    [self setNeedsLayout:YES];
}

- (void)updateColors {
    [super updateColors];
    if (self.textColors) {
        self.textField.textColor = self.textColors.color;
    }
}

- (void)setTextColors:(LKTwoColors *)textColors {