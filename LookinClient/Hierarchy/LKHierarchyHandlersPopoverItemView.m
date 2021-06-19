//
//  LKHierarchyHandlersPopoverItemView.m
//  Lookin
//
//  Created by Li Kai on 2019/8/11.
//  https://lookin.work
//

#import "LKHierarchyHandlersPopoverItemView.h"
#import "LookinEventHandler.h"
#import "LKTextsMenuView.h"
#import "LookinIvarTrace.h"
#import "LKAppsManager.h"
#import "LKNavigationManager.h"
#import "LKStaticWindowController.h"

@interface LKHierarchyHandlersPopoverItemView ()

@property(nonatomic, strong) LookinEventHandler *eventHandler;

@property(nonatomic, strong) NSImageView *iconImageView;

@property(nonatomic, strong) LKLabel *titleLabel;
@property(nonatomic, strong) LKLabel *subtitleLabel;
@property(nonatomic, strong) NSButton *recognizerEnableButton;


@property(nonatomic, strong) LKTextsMenuView *contentView;

@property(nonatomic, strong) CALayer *topSepLayer;


@end

@implementation LKHierarchyHandlersPopoverItemView {
    CGFloat _contentX;
    CGFloat _insetRight;
    CGFloat _verInset;
    CGFloat _contentMarginTop;
    CGFloat _subtitleMarginTop;
}

- (instancetype)initWithEventHandler:(LookinEventHandler *)eventHandler editable:(BOOL)editable {
    if (self = [self initWithFrame:NSZeroRect]) {
        _contentX = 28;
        _insetRight = 16;
        _verInset = 10;
        _contentMarginTop = 4;
        _subtitleMarginTop = 3;
        
        self.eventHandler = eventHandler;
        
        self.topSepLayer = [CALayer layer];
        [self.layer addSublayer:self.topSepLayer];
        
        self.iconImageView = [NSImageView new];
        [self addSubview:self.iconImageView];
        
        self.titleLabel = [LKLabel new];
        self.titleLabel.selectable = YES;
        self.titleLabel.maximumNumberOfLines = 1;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:self.titleLabel];
        
        self.contentView = [LKTextsMenuView new];
        self.contentView.font = NSFontMake(13);
        [self addSubview:self.contentView];
        
        self.topSepLayer.backgroundColor = self.isDarkMode ? LookinColorRGBAMake(255, 255, 255, .15).CGColor : LookinColorRGBAMake(0, 0, 0, .12).CGColor;
        
        NSMutableArray<LookinStringTwoTuple *> *texts = [NSMutableArray array];
        if (eventHandler.handlerType == LookinEventHandlerTypeGesture) {
            [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"Enabled" second:@""]];

            if (editable) {
                self.recognizerEnableButton = [NSButton new];
                [self.recognizerEnableButton setButtonType:NSButtonTypeSwitch];
                self.recognizerEnableButton.title = @"";
                self.recognizerEnableButton.target = self;
                self.recognizerEnableButton.action = @selector(_handleGestureButton:);
                [self _renderRecognizerEnabledButton];
                [self.contentView addButton:self.recognizerEnableButton atIndex:0];
            } else {
                [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"Enabled" second:(eventHandler.gestureRecognizerIsEnabled ? @"YES" : @"NO")]];
            }
            
            [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"Delegate" second:(eventHandler.gestureRecognizerDelegator ? : @"nil")]];
            // gesture 的名字都太长了，把字号弄小一点
            self.titleLabel.font = [NSFont boldSystemFontOfSize:12];
        } else {
            self.titleLabel.font = [NSFont boldSystemFontOfSize:13];
        }
        
        if (eventHandler.targetActions.count == 0) {
            [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"Target" second:@"nil"]];
            [texts addObject:[LookinStringTwoTuple tupleWithFirst:@"Action" second:@"NULL"]];
        } else if (eventHandler.targetActions.count == 1) {
            LookinStringTwoTuple *tuple = eventHandler.targetActions.firstObject;
            [texts addObject:[LookinStringTwoTuple