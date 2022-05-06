//
//  LKMeasureResultView.m
//  Lookin
//
//  Created by Li Kai on 2019/10/21.
//  https://lookin.work
//

#import "LKMeasureResultView.h"
#import "LKNavigationManager.h"
#import "LKTextFieldView.h"
#import "LKMeasureResultLineData.h"

#define compare(A, B) [self _compare:A with:B]
#define addHor(arg_array, arg_startX, arg_endX, arg_y, arg_value) [arg_array addObject:[LKMeasureResultHorLineData dataWithStartX:arg_startX endX:arg_endX y:arg_y value:arg_value]]
#define addVer(arg_array, arg_startY, arg_endY, arg_x, arg_value) [arg_array addObject:[LKMeasureResultVerLineData dataWithStartY:arg_startY endY:arg_endY x:arg_x value:arg_value]]

typedef NS_ENUM(NSInteger, CompareResult) {
    Bigger,
    Same,
    Smaller
};

@interface LKMeasureResultView ()

/// mainLayer 指 selectedLayer，referLayer 指 hovered layer
@property(nonatomic, strong) LKBaseView *contentView;

@property(nonatomic, strong) NSImageView *mainImageView;
@property(nonatomic, strong) NSImageView *referImageView;

/// 如果直接把 solidLinesLayer 作为 contentView.layer 的 sublayer 则经常出现 linesLayer 被 imageView.layer 盖住的情况，貌似 imageView.layer 是懒加载的且时机不好掌握，因此这里多包一层 view 吧确保顺序
@property(nonatomic, strong) LKBaseView *linesContainerView;
@property(nonatomic, strong) CAShapeLayer *solidLinesLayer;
/// imageView 重叠时会被半透明处理，我们又不想半透明 border，所以单独把 border 作为 layer
@property(nonatomic, strong) CALayer *mainImageViewBorderLayer;
@property(nonatomic, strong) CALayer *referImageViewBorderLayer;

@property(nonatomic, strong) NSMutableArray<LKTextFieldView *> *textFieldViews;

@property(nonatomic, assign) CGRect originalMainFrame;
@property(nonatomic, assign) CGRect originalReferFrame;

@property(nonatomic, assign) CGRect scaledMainFrame;
@property(nonatomic, assign) CGRect scaledReferFrame;

@end

@implementation LKMeasureResultView {
    CGFloat _horInset;
    CGFloat _verInset;
    CGFloat _labelHeight;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        _horInset = 20;
        _verInset = 20;
        _labelHeight = 16;
        
        self.hasEffectedBackground = YES;
        self.layer.cornerRadius = DashboardCardCornerRadius;

        self.contentView = [LKBaseView new];
        // label 经常会超出范围
        self.contentView.layer.masksToBounds = NO;
        [self addSubview:self.contentView];
        
        self.mainImageView = [NSImageView new];
        self.mainImageView.imageScaling = NSImageScaleProportionallyUpOrDown;
        [self.contentView addSubview:self.mainImageView];
        
        self.referImageView = [NSImageView new];
        self.referImageView.imageScaling = NSImageScaleProportionallyUpOrDown;
        [self.contentView addSubview:self.referImageView];
        
        self.linesContainerView = [LKBaseView new];
        self.linesContainerView.layer.masksToBounds = NO;
        [self.contentView addSubview:self.linesContainerView];
    
        self.mainImageViewBorderLayer = [CALayer layer];
        self.mainImageViewBorderLayer.borderWidth = 1;
        [self.mainImageViewBorderLayer lookin_removeImplicitAnimations];
        [self.linesContainerView.layer addSublayer:self.mainImageViewBorderLayer];
        
        self.referImageViewBorderLayer = [CALayer layer];
        self.referImageViewBorderLayer.borderWidth = 1;
        [self.referImageViewBorderLayer lookin_removeImplicitAnimations];
        [self.linesContainerView.layer addSublayer:self.referImageViewBorderLayer];
        
        self.solidLinesLayer = [CAShapeLayer layer];
        self.solidLinesLayer.lineWidth = 1;
        [self.solidLinesLayer lookin_removeImplicitAnimations];
        self.solidLinesLayer.strokeColor = LookinColorMake(10, 127, 251).CGColor;
        [self.linesContainerView.layer addSublayer:self.solidLinesLayer];
    
        [self updateColors];
    }
    return self;
}

- (void)updateColors {
    [super updateColors];
    NSColor *borderColor = self.isDarkMode ? LookinColorMake(123, 123, 123) : LookinColorMake(190, 190, 190);
    self.referImageViewBorderLayer.borderColor = borderColor.CGColor;
    self.mainImageViewBorderLayer.borderColor = borderColor.CGColor;
}

- (void)layout {
    [super layout];
    self.mainImageView.frame = self.scaledMainFrame;
    self.referImageView.frame = self.scaledReferFrame;
    
    CGFloat contentWidth, contentHeight;
    [self _getWidth:&contentWidth height:&contentHeight fromRectA:self.scaledMainFrame rectB:self.scaledReferFrame];
    $(self.contentView).width(contentWidth).height(contentHeight).centerAlign;
    
    self.linesContainerView.frame = self.contentView.bounds;
    self.solidLinesLayer.frame = self.linesContainerView.bounds;
    self.mainImageViewBorderLayer.frame = self.mainImageView.frame;
    self.referImageViewBorderLayer.frame = self.referImageView.frame;
    [self _renderLinesAndLabels];
}

- (void)renderWithMainRect:(CGRect)originalMainRect mainImage:(LookinImage *)mainImage referRect:(CGRect)originalReferRect referImage:(LookinImage *)referImage {
    self.originalMainFrame = originalMainRect;
    self.originalReferFrame = originalReferRect;
    
    self.mainImageView.image = mainImage;
    self.referImageView.image = referImage;
    
    CGFloat scaleFactor = [self _calculateScaleFactorWithMainRect:originalMainRect referRect:originalReferRect];
    
    // 这里的两个 frame 是稍后真正被 layout 使用的值
    CGRect mainFrame = [self _adjustRect:originalMainRect withScaleFactor:scaleFactor];
    CGRect referFrame = [self _adjustRect:originalReferRect withScaleFactor:scaleFactor];
    
    CGFloat minX, minY;
    [self _getMinX:&minX minY:&minY maxX:nil maxY:nil fromRectA:mainFrame rectB:referFrame];
    
    // 下面两句使得两个 rect 作为整体被移动 origin 至 {0, 0}
    self.scaledMainFrame = [self _adjustRect:mainFrame withOffsetX:minX offsetY:minY];
    self.scaledReferFrame = [self _adjustRect:referFrame withOffsetX:minX offsetY:minY];
    
    [self setNeedsLayout:YES];
}

/// 画那些辅助线。调用该方法前，self.scaledMainFrame 和 self.scaledReferFrame 必须已经被正确设置完毕
- (void)_renderLinesAndLabels {
    [self _hideAllLabels];
    self.solidLinesLayer.hidden = YES;
    
    // 为了方便，mainFrame 记为 A，referRect 记为 B
    CGRect rectA = self.scaledMainFrame;
    CGRect rectB = self.scaledReferFrame;
    
    // 包裹对方的那个 view 应该被半透明处理，因为此时辅助线基本都落在了被包裹的 view 之外、包裹对方的 view 之内
    if (CGRectContainsRect(rectA, rectB)) {
        // A 包裹 B
        self.mainImageView.alphaValue = .2;
        self.referImageView.alphaValue = 1;

    } else if (CGRectContainsRect(rectB, rectA)) {
        // B 包裹 A
        self.mainImageView.alphaValue = 1;
        self.referImageView.alphaValue = .2;
        
    } else if (CGRectIntersectsRect(rectA, rectB)) {
        // 两个 view 只有部分是重叠的
        self.mainImageView.alphaValue = .2;
        self.referImageView.alphaValue = .2;
    } else {
        // 两个 view 没有重叠
        self.mainImageView.alphaValue = 1;
        self.referImageView.alphaValue = 1;
    }
    
    CGFloat minX_A = CGRectGetMinX(rectA);
    CGFloat midX_A = CGRectGetMidX(rectA);
    CGFloat maxX_A = CGRectGetMaxX(rectA);
    CGFloat minX_B = CGRectGetMinX(rectB);
    CGFloat midX_B = CGRectGetMidX(rectB);
    CGFloat maxX_B = CGRectGetMaxX(rectB);
    
    CGFloat minY_A = CGRectGetMinY(rectA);
    CGFloat midY_A = CGRectGetMidY(rectA);
    CGFloat maxY_A =