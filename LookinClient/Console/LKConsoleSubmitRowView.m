//
//  LKConsoleSubmitRowView.m
//  Lookin
//
//  Created by Li Kai on 2019/6/1.
//  https://lookin.work
//

#import "LKConsoleSubmitRowView.h"

@implementation LKConsoleSubmitRowView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        self.titleLabel.selectable = YES;
        self.titleLabel.font = NSFontMake(13);

        self.subtitleLabel.selectable = YES;        
        self.subtitleLabel.textColor = [NSColor labelColor];
        self.subtitleLabel.font = NSFontMake(13);
        
//        self.layer.borderColor = [NSColor blueColor].CGColor;
//        self.layer.borderWidth = 1;
    }
    return self;
}

- (void)layout {
    [super layout];
    NSSize 