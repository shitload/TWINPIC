//
//  LKPanelContentView.m
//  Lookin
//
//  Created by Li Kai on 2019/5/24.
//  https://lookin.work
//

#import "LKPanelContentView.h"

@interface LKPanelContentView ()

@property(nonatomic, strong) NSImageView *titleImageView;
@property(nonatomic, strong) LKLabel *titleLabel;
@property(nonatomic, strong) LKBaseView *titleContainerView;

@property(nonatomic, strong) NSButton *cancelButton;

@end

@implementation LKPanelContentView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        self.backgroundColorName = @"DashboardBackgroundColor";
        
        self.titleContainerView = [LKBaseView new];
        self.titleContainerView.backgroundColorName = @"PanelTitleBackgroundColor";
        [self addSubview:self.titleContainerView];
        
        self.titleImageView = [NSImageView new];
        [self.titleContainerView addSubview:self.titleImageView];
        
        self.titleLabel = [LKLabel new];
        self.titleLabel.font = NSFontMake(13);
        [self.titleContainerView addSub