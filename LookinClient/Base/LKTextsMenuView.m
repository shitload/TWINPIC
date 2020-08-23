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
    CGFloat _buttonMarginLeft;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        _buttonMarginLeft = 4;
        _verSpace = 2;
        _horSpace = 10;
        _insets = NSEdgeInsetsMake(0, 3, 0, 5);
        
        self.leftLabels = [NSMutableArray array];
        self.rightLabels = [NSMutableArray array];
    }
    return self;
}

- (void)layout {
    [super layout];
    
    NSArray<LKLabel *> *visibleRightLabels = self.rightLabels.lk_visibleViews;
    NSArray<LKLabel *> *visibleLeftLabels = self.leftLabels.lk_visibleViews;
    
    if (self.type == LKTextsMenuViewTypeCenter) {
        __block CGFloat leftLabelMaxWidth = self.insets.left;
        [visibleLeftLabels enumerateObjectsUsingBlock:^(LKLabel * _Nonnull leftLabel, NSUInteger idx, BOOL * _Nonnull stop) {
            LKLabel *prevLeftLabel = (idx > 0 ? visibleLeftLabels[idx - 1] : nil);
            CGFloat y = prevLeftLabel ? (prevLeftLabel.$maxY + self.verSpace) : 0;
            $(leftLabel).sizeToFit.y(y);
            leftLabelMaxWidth = MAX(leftLabelMaxWidth, leftLabel.$w