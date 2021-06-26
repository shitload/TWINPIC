
//
//  LKLaunchAppView.m
//  Lookin
//
//  Created by Li Kai on 2018/11/3.
//  https://lookin.work
//

#import "LKLaunchAppView.h"
#import "LKInspectableApp.h"

@interface LKLaunchAppView ()

@property(nonatomic, strong) CALayer *hoverBgLayer;
@property(nonatomic, strong) NSImageView *previewImageView;
@property(nonatomic, strong) NSImageView *iconImageView;
@property(nonatomic, strong) LKLabel *titleLabel;
@property(nonatomic, strong) LKLabel *subtitleLabel;

@property(nonatomic, strong) NSImageView *errorImageView;
@property(nonatomic, strong) LKLabel *errorTitleLabel;
@property(nonatomic, strong) LKLabel *errorSubtitleLabel;

@end

@implementation LKLaunchAppView {
    NSSize _previewSize;
    NSEdgeInsets _insets;
    CGFloat _iconTop;
    CGFloat _iconMarginRight;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        self.layer.cornerRadius = 4;
        
        self.hoverBgLayer = [CALayer layer];
        self.hoverBgLayer.opacity = 0;
        self.hoverBgLayer.cornerRadius = 4;
        [self.layer addSublayer:self.hoverBgLayer];
        
        self.previewImageView = [NSImageView new];
        [self addSubview:self.previewImageView];
        
        self.iconImageView = [NSImageView new];
        [self addSubview:self.iconImageView];
        
        self.titleLabel = [LKLabel new];
        self.titleLabel.textColor = [NSColor labelColor];
        [self addSubview:self.titleLabel];
        
        self.subtitleLabel = [LKLabel new];
        self.subtitleLabel.textColor = [NSColor labelColor];
        [self addSubview:self.subtitleLabel];
        
        self.compactLayout = NO;
    }
    return self;
}

- (void)setCompactLayout:(BOOL)compactLayout {
    if (compactLayout) {
        _previewSize = NSMakeSize(120, 220);
        _insets = NSEdgeInsetsMake(12, 13, 8, 13);
        _iconTop = 10;
        _iconMarginRight = 6;
        self.titleLabel.font = NSFontMake(12);
        self.subtitleLabel.font = NSFontMake(11);
    } else {
        _previewSize = NSMakeSize(142, 260);
        _insets = NSEdgeInsetsMake(12, 25, 12, 25);
        _iconTop = 10;
        _iconMarginRight = 8;
        self.titleLabel.font = NSFontMake(13);
        self.subtitleLabel.font = NSFontMake(12);
    }
    
    [self setNeedsLayout:YES];
}

- (void)layout {
    [super layout];
    
    self.hoverBgLayer.frame = self.layer.bounds;
    
    if (self.app.serverVersionError) {
        $(self.errorImageView).sizeToFit.horAlign;
        $(self.errorTitleLabel).x(10).toRight(10).heightToFit.y(self.errorImageView.$maxY + 15);
        $(self.errorSubtitleLabel).sizeToFit.horAlign.y(self.errorTitleLabel.$maxY + 10);
        $(self.errorImageView, self.errorTitleLabel, self.errorSubtitleLabel).groupVerAlign.offsetY(-10);
        
    } else {
        $(self.previewImageView).size(_previewSize).horAlign.y(_insets.top);
        
        $(self.iconImageView).sizeToFit.y(_insets.top + _previewSize.height + _iconTop);
        
        $(self.titleLabel).sizeToFit;
        $(self.subtitleLabel).sizeToFit.y(self.titleLabel.$maxY + 2);
        $(self.titleLabel, self.subtitleLabel).x(self.iconImageView.$maxX + _iconMarginRight).groupMidY(self.iconImageView.$midY);
        
        $(self.iconImageView, self.titleLabel, self.subtitleLabel).groupHorAlign.offsetX(-2);
    }
}

- (NSSize)sizeThatFits:(NSSize)limitedSize {
    if (self.app.serverVersionError) {
        return NSMakeSize(_previewSize.width + _insets.left + _insets.right, _insets.top + _previewSize.height + _iconTop + _insets.bottom);
        
    } else {
        CGFloat previewWidth = _previewSize.width + _insets.left + _insets.right;
        CGFloat labelsWidth = self.iconImageView.image.size.width + _iconMarginRight + MAX([self.titleLabel sizeThatFits:NSSizeMax].width, [self.subtitleLabel sizeThatFits:NSSizeMax].width) + _insets.left + _insets.right;
        
        CGFloat width = MAX(previewWidth, labelsWidth);
        CGFloat height = _insets.top + _previewSize.height + _iconTop + self.iconImageView.image.size.height + _insets.bottom;
        return NSMakeSize(width, height);
    }
}

- (void)sizeToFit {
    NSSize size = [self sizeThatFits:NSSizeMax];
    [self setFrameSize:size];
}

- (void)setApp:(LKInspectableApp *)app {
    _app = app;
    
    if (app.serverVersionError) {
        [self _initErrorViewsIfNeeded];
        
        self.errorImageView.hidden = NO;
        self.errorTitleLabel.hidden = NO;
        self.errorSubtitleLabel.hidden = NO;
        
        self.previewImageView.hidden = YES;
        self.iconImageView.hidden = YES;
        self.titleLabel.hidden = YES;
        self.subtitleLabel.hidden = YES;
        
        if (app.serverVersionError.code == LookinErrCode_ServerVersionTooLow) {
            if (LOOKIN_CLIENT_IS_EXPERIMENTAL) {
                // 内部版本的 LookinClient
                self.errorTitleLabel.stringValue = @"LookinServer 版本过低：请在 Xcode 中按住 \"Option\" 并选择 \"Product\" - \"Clean Build Folder\" 然后重新编译，或者找 hughkli";
                self.errorSubtitleLabel.hidden = YES;
            } else {