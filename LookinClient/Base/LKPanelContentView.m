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
        [self.titleContainerView addSubview:self.titleLabel];
        
        self.cancelButton = [NSButton lk_normalButtonWithTitle:NSLocalizedString(@"Cancel", nil) target:self action:@selector(_handleCancelButton)];
        // esc
        self.cancelButton.keyEquivalent = [NSString stringWithFormat:@"%C", 0x1b];
        [self addSubview:self.cancelButton];
        
        _submitButton = [NSButton lk_normalButtonWithTitle:NSLocalizedString(@"Done", nil) target:self action:@selector(_handleSubmitButton)];
        self.submitButton.keyEquivalent = @"\r";
        [self addSubview:self.submitButton];
        
        _con