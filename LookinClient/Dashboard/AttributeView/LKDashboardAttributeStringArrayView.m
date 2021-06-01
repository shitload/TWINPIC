
//
//  LKDashboardAttributeStringArrayView.m
//  Lookin
//
//  Created by Li Kai on 2019/6/15.
//  https://lookin.work
//

#import "LKDashboardAttributeStringArrayView.h"

@interface LKDashboardAttributeStringArrayView ()

@property(nonatomic, copy) NSArray<LKLabel *> *labels;
@property(nonatomic, copy) NSArray<CALayer *> *sepLayers;

@end

@implementation LKDashboardAttributeStringArrayView {
    CGFloat _labelsVerInterSpace;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        _labelsVerInterSpace = 10;
    
//        [self showDebugBorder];
        
        self.labels = [NSArray array];
        self.sepLayers = [NSArray array];
    }
    return self;
}

- (void)layout {
    [super layout];
    [self.labels enumerateObjectsUsingBlock:^(LKLabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LKLabel *prevLabel = (idx > 0 ? self.labels[idx - 1] : nil);
        $(obj).fullFrame.heightToFit.y(prevLabel ? (prevLabel.$maxY + self -> _labelsVerInterSpace) : 0);
        
        if (idx > 0) {
            if ([self.sepLayers lookin_hasIndex:(idx - 1)]) {
                $(self.sepLayers[idx - 1]).fullFrame.height(1).y(obj.$y - self -> _labelsVerInterSpace / 2.0 + 1);
            } else {
                NSAssert(NO, @"");
            }
        }
    }];
}

- (NSSize)sizeThatFits:(NSSize)limitedSize {
    limitedSize.height = [self.labels lookin_reduceCGFloat:^CGFloat(CGFloat accumulator, NSUInteger idx, LKLabel *obj) {
        CGFloat labelHeight = [obj sizeThatFits:limitedSize].height;
        accumulator += labelHeight;
        if (idx) {
            accumulator += self->_labelsVerInterSpace;
        }
        return accumulator;
    } initialAccumlator:0];
    return limitedSize;
}

- (NSArray<NSString *> *)stringListWithAttribute:(LookinAttribute *)attribute {
    NSAssert(NO, @"should implement by subclass");
    return nil;
}

- (void)renderWithAttribute {
    NSArray<NSString *> *lists = [self stringListWithAttribute:self.attribute];
    self.labels = [self.labels lookin_resizeWithCount:lists.count add:^LKLabel *(NSUInteger idx) {
        LKLabel *label = [LKLabel new];
        label.selectable = YES;
        label.allowsEditingTextAttributes = YES;
        [self addSubview:label];
        return label;
        
    } remove:^(NSUInteger idx, LKLabel *label) {
        [label removeFromSuperview];
        
    } doNext:^(NSUInteger idx, LKLabel *label) {
        NSString *string = lists[idx];
        label.attributedStringValue = $(string).textColor([NSColor labelColor]).font(NSFontMake(12)).lineHeight(18).attrString;
    }];
    
    if (lists.count > 1) {
        self.sepLayers = [self.sepLayers lookin_resizeWithCount:(lists.count - 1) add:^CALayer *(NSUInteger idx) {
            CALayer *layer = [CALayer new];
            [layer lookin_removeImplicitAnimations];
            [self.layer addSublayer:layer];
            return layer;
        } remove:^(NSUInteger idx, CALayer *layer) {
            [layer removeFromSuperlayer];
            
        } doNext:^(NSUInteger idx, CALayer *layer) {
            
        }];
        [self updateColors];
        
    } else {
        [self.sepLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperlayer];
        }];
        self.sepLayers = @[];
    }
    
    [self setNeedsLayout:YES];
}

- (void)updateColors {
    [super updateColors];
    [self.sepLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = self.isDarkMode ? SeparatorDarkModeColor.CGColor : SeparatorLightModeColor.CGColor;
    }];
}
@end