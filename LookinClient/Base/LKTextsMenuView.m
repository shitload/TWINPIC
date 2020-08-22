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
    NSArray<LKLabel *> *visibleLeftLabels =