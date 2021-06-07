
//
//  LKDashboardSectionView.m
//  Lookin
//
//  Created by Li Kai on 2019/6/7.
//  https://lookin.work
//

#import "LKDashboardSectionView.h"
#import "LKDashboardAttributeRectView.h"
#import "LKDashboardAttributeNumberInputView.h"
#import "LookinAttributesSection.h"
#import "LookinDashboardBlueprint.h"
#import "LKDashboardAttributeInsetsView.h"
#import "LKDashboardAttributeSwitchView.h"
#import "LKDashboardAttributeColorView.h"
#import "LKDashboardAttributeEnumsView.h"
#import "LKDashboardAttributePointView.h"
#import "LKDashboardAttributeSizeView.h"
#import "LKDashboardAttributeRowsCountView.h"
#import "LKDashboardAttributeClassView.h"
#import "LKDashboardAttributeRelationView.h"
#import "LKDashboardAttributeConstraintsView.h"
#import "LKDashboardAttributeTextView.h"
#import "LKPreferenceManager.h"
#import "LKDashboardAttributeOpenImageView.h"

@interface LKDashboardSectionView ()

@property(nonatomic, strong) NSMutableArray<LKDashboardAttributeView *> *attrViews;
@property(nonatomic, strong) LKLabel *titleLabel;
@property(nonatomic, strong) CALayer *topSepLayer;

@property(nonatomic, strong) NSButton *manageButton;

@end

@implementation LKDashboardSectionView {
    CGFloat _titleMarginTop;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        _titleMarginTop = 6;
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [NSColor blueColor].CGColor;
//        self.layer.backgroundColor = LookinColorRGBAMake(255, 0, 0, .2).CGColor;
        
        /// 使得 topSepLayer 可以从右边延伸出去
        self.layer.masksToBounds = NO;
        
        self.attrViews = [NSMutableArray array];
    
        self.topSepLayer = [CALayer new];
        [self.topSepLayer lookin_removeImplicitAnimations];
        [self.layer addSublayer:self.topSepLayer];
        
        [self updateColors];
    }
    return self;
}

- (void)layout {
    [super layout];
    
    CGFloat contentsX = 0;
    CGFloat selfWidth = self.$width;
    CGFloat contentsY = 0;
    
    if (self.manageButton.isVisible) {
        CGFloat y;
        if (self.topSepLayer.hidden) {
            y = 0;
        } else if (self.titleLabel.isVisible) {
            y = 6;
        } else {
            y = 9;
        }

        $(self.manageButton).sizeToFit.x(0).y(y);
        contentsX = self.manageButton.$maxX + 6;
    }
    
    if (!self.topSepLayer.hidden) {
        $(self.topSepLayer).x(contentsX).width(selfWidth).height(1).y(0);
        contentsY = DashboardAttrItemVerInterspace;
    }
    
    if (self.titleLabel.isVisible) {
        $(self.titleLabel).x(contentsX).width(selfWidth).heightToFit.y(self.topSepLayer.hidden ? 0 : _titleMarginTop);
        contentsY = self.titleLabel.$maxY + DashboardAttrItemVerInterspace;
    }
    
    NSArray<LKDashboardAttributeView *> *attrViews = [self.attrViews lookin_filter:^BOOL(LKDashboardAttributeView *view) {
        return view.isVisible;
    }];
    [attrViews enumerateObjectsUsingBlock:^(LKDashboardAttributeView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        LKDashboardAttributeView *prevView = (idx > 0 ? attrViews[idx - 1] : nil);
        CGFloat width;
        NSUInteger numberOfColumns = view.numberOfColumnsOccupied;
        if (numberOfColumns == 0) {
            width = [view sizeThatFits:NSSizeMax].width;
        } else {
            width = floor((selfWidth + DashboardAttrItemHorInterspace) / (CGFloat)numberOfColumns) - DashboardAttrItemHorInterspace;
        }
        
        CGFloat x, y;
        if (prevView && (prevView.$maxX + DashboardAttrItemHorInterspace + width <= (selfWidth + contentsX))) {
            x = prevView.$maxX + DashboardAttrItemHorInterspace;
            y = prevView.$y;
        } else {
            x = contentsX;
            y = prevView ? (prevView.$maxY + DashboardAttrItemVerInterspace) : contentsY;
        }
        $(view).width(width).heightToFit.x(x).y(y);
    }];
}

- (NSSize)sizeThatFits:(NSSize)limitedSize {
    NSArray<LKDashboardAttributeView *> *attrViews = [self.attrViews lookin_filter:^BOOL(LKDashboardAttributeView *view) {
        return view.isVisible;
    }];
    
    CGFloat height = 0;
    if (!self.topSepLayer.hidden) {
        height += DashboardAttrItemVerInterspace;
    }
    if (self.titleLabel.isVisible) {
        height += [self.titleLabel sizeThatFits:NSSizeMax].height + _titleMarginTop;
    }
    __block CGFloat prevMaxX = 0;
    height = [attrViews lookin_reduceCGFloat:^CGFloat(CGFloat accumulator, NSUInteger idx, LKDashboardAttributeView *view) {
        NSUInteger numberOfColumns = view.numberOfColumnsOccupied;
        CGFloat width;
        if (numberOfColumns == 0) {
            width = [view sizeThatFits:limitedSize].width;
        } else {
            width = floor((limitedSize.width + DashboardAttrItemHorInterspace) / numberOfColumns) - DashboardAttrItemHorInterspace;
        }
        
        if (idx > 0 && (prevMaxX + DashboardAttrItemHorInterspace + width <= limitedSize.width)) {
            prevMaxX = prevMaxX + DashboardAttrItemHorInterspace + width;
            return accumulator;
        } else {
            accumulator += [view sizeThatFits:limitedSize].height;
            if (idx > 0) {
                accumulator += DashboardAttrItemVerInterspace;
            }
            prevMaxX = width;
            return accumulator;
        }

    } initialAccumlator:height];
    
    limitedSize.height = height;
    return limitedSize;
}

- (void)setAttrSection:(LookinAttributesSection *)attrSection {
    _attrSection = attrSection;
    if (!attrSection) {
        NSAssert(NO, @"");
        return;
    }
    
    NSString *title = [LookinDashboardBlueprint sectionTitleWithSectionID:attrSection.identifier];
    if (title.length) {
        if (self.titleLabel) {
            self.titleLabel.hidden = NO;
        } else {
            self.titleLabel = [LKLabel new];
            self.titleLabel.font = [NSFont boldSystemFontOfSize:12];
//            self.titleLabel.backgroundColor = [NSColor greenColor];
            [self addSubview:self.titleLabel];
        }
        self.titleLabel.stringValue = title;
    } else {
        self.titleLabel.hidden = YES;
    }
    
    NSMutableArray<LKDashboardAttributeView *> *needlessViews = [self.attrViews mutableCopy];
    
    NSArray<LookinAttrIdentifier> *attrIDs = [LookinDashboardBlueprint attrIDsForSectionID:attrSection.identifier];
    [attrIDs enumerateObjectsUsingBlock:^(LookinAttrIdentifier _Nonnull attrID, NSUInteger idx, BOOL * _Nonnull stop) {
        LookinAttribute *attr = [attrSection.attributes lookin_firstFiltered:^BOOL(LookinAttribute *obj) {
            return [obj.identifier isEqualToString:attrID];
        }];
        if (!attr) {
            return;
        }
        Class attrViewClass = [self _targetAttrClassForType:attr.attrType identifier:attr.identifier];
        LKDashboardAttributeView *view = [needlessViews lookin_firstFiltered:^BOOL(LKDashboardAttributeView *obj) {
            return  [obj isMemberOfClass:attrViewClass];
        }];
        if (view) {
            [needlessViews removeObject:view];
            view.hidden = NO;
        } else {
            view = [attrViewClass new];
            view.dashboardViewController = self.dashboardViewController;
            [self.attrViews addObject:view];
            [self addSubview:view];
        }
        view.attribute = attr;
    }];
    
    [needlessViews enumerateObjectsUsingBlock:^(LKDashboardAttributeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    
    [self setNeedsLayout:YES];
}

- (void)setShowTopSeparator:(BOOL)showTopSeparator {
    _showTopSeparator = showTopSeparator;
    self.topSepLayer.hidden = !showTopSeparator;
}

- (void)updateColors {
    [super updateColors];
    self.topSepLayer.backgroundColor = self.isDarkMode ? SeparatorDarkModeColor.CGColor : SeparatorLightModeColor.CGColor;
}

- (Class)_targetAttrClassForType:(LookinAttrType)type identifier:(LookinAttrIdentifier)identifier {
    switch (type) {
        case LookinAttrTypeCGRect:
            return [LKDashboardAttributeRectView class];
        case LookinAttrTypeUIEdgeInsets:
            return [LKDashboardAttributeInsetsView class];
        case LookinAttrTypeBOOL:
            return [LKDashboardAttributeSwitchView class];
        case LookinAttrTypeFloat:
        case LookinAttrTypeDouble:
        case LookinAttrTypeLong:
            return [LKDashboardAttributeNumberInputView class];
        case  LookinAttrTypeUIColor:
            return [LKDashboardAttributeColorView class];
        case LookinAttrTypeEnumInt:
        case LookinAttrTypeEnumLong:
            return [LKDashboardAttributeEnumsView class];
        case LookinAttrTypeCGPoint:
            return [LKDashboardAttributePointView class];
        case LookinAttrTypeCGSize:
            return [LKDashboardAttributeSizeView class];
        case LookinAttrTypeNSString:
            return [LKDashboardAttributeTextView class];
        case LookinAttrTypeCustomObj:
            if ([identifier isEqualToString:LookinAttr_UITableView_RowsNumber_Number]) {
                return [LKDashboardAttributeRowsCountView class];
            } else if ([identifier isEqualToString:LookinAttr_Class_Class_Class]) {
                return [LKDashboardAttributeClassView class];
            } else if ([identifier isEqualToString:LookinAttr_Relation_Relation_Relation]) {
                return [LKDashboardAttributeRelationView class];
            } else if ([identifier isEqualToString:LookinAttr_AutoLayout_Constraints_Constraints]) {
                return [LKDashboardAttributeConstraintsView class];
            } else if ([identifier isEqualToString:LookinAttr_UIImageView_Open_Open]) {
                return [LKDashboardAttributeOpenImageView class];
            } else if ([identifier isEqualToString:LookinAttr_UIVisualEffectView_Style_Style]) {
                return [LKDashboardAttributeEnumsView class];
            } else {
                NSAssert(NO, @"");
                return nil;
            }
        default:
            NSAssert(NO, @"");
            return nil;
    }
}

#pragma mark - Manage

- (void)setManageState:(LKDashboardSectionManageState)manageState {
    _manageState = manageState;
    if (manageState == LKDashboardSectionManageState_None) {
        self.manageButton.hidden = YES;
        [self setNeedsLayout:YES];
        return;
    }
    
    NSImage *image = nil;
    if (manageState == LKDashboardSectionManageState_CanAdd) {
        image = NSImageMake(@"icon_manage_add");
    } else if (manageState == LKDashboardSectionManageState_CanRemove) {
        image = NSImageMake(@"icon_manage_remove");
    } else {
        NSAssert(NO, @"");
        return;
    }
    
    if (self.manageButton) {
        self.manageButton.image = image;
        self.manageButton.hidden = NO;
    } else {
        self.manageButton = [NSButton buttonWithImage:image target:self action:@selector(_handleManageButton)];
        self.manageButton.bezelStyle = NSBezelStyleRoundRect;
        self.manageButton.bordered = NO;
        [self addSubview:self.manageButton];
    }
    [self setNeedsLayout:YES];
}

- (void)_handleManageButton {
    LKPreferenceManager *manager = [LKPreferenceManager mainManager];
    if (self.manageState == LKDashboardSectionManageState_CanAdd) {
        [manager showSection:self.attrSection.identifier];
    } else if (self.manageState == LKDashboardSectionManageState_CanRemove) {
        [manager hideSection:self.attrSection.identifier];
    } else {
        NSAssert(NO, @"");
    }
}

@end