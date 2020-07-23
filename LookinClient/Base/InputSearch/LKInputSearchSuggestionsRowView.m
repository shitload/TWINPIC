//
//  LKInputSearchSuggestionsRowView.m
//  Lookin
//
//  Created by Li Kai on 2019/6/3.
//  https://lookin.work
//

#import "LKInputSearchSuggestionsRowView.h"

@implementation LKInputSearchSuggestionsRowView {
    CGFloat _horInset;
    CGFloat _titleLeft;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        _horInset = 10;
        _titleLeft = 5;
        
        _imageView = [NSImageView new];
        [self addSubview:self.imageView];
        
        _titleLabel = [LKLabel new];
        self.titleLabel.maximumNumberOfLines = 1;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.titleLabel.font = NSFontMake(14);
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layout {
    [super layout];
    $(self.imageView).sizeToFit.x(_horInset).verAlign;
   