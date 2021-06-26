
//
//  LKHierarchyView.m
//  Lookin
//
//  Created by Li Kai on 2018/8/4.
//  https://lookin.work
//

#import "LKHierarchyView.h"
#import "LKStaticHierarchyDataSource.h"
#import "LookinDisplayItem.h"
#import "LKPreferenceManager.h"
#import "LKWindowController.h"
#import "LKTableView.h"
#import "LookinIvarTrace.h"
#import "LKNavigationManager.h"
#import "LKTutorialManager.h"
#import "LKTextFieldView.h"

static NSString * const kMenuBindKey_RowView = @"view";
static CGFloat const kRowHeight = 28;

@interface LKHierarchyView () <LKTableViewDelegate, LKTableViewDataSource, NSMenuDelegate, NSTextFieldDelegate>

@property(nonatomic, strong) LKVisualEffectView *backgroundEffectView;

@property(nonatomic, strong) CAShapeLayer *guidesShapeLayer;

@property(nonatomic, strong) LKTextFieldView *searchTextFieldView;

@property(nonatomic, strong) LKLabel *emptyDataLabel;

@end

@implementation LKHierarchyView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {        
        self.backgroundEffectView = [LKVisualEffectView new];
        self.backgroundEffectView.material = NSVisualEffectMaterialSidebar;
        self.backgroundEffectView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
        self.backgroundEffectView.state = NSVisualEffectStateActive;
        [self addSubview:self.backgroundEffectView];
        
        _tableView = [LKTableView new];
        self.tableView.adjustsSelectionAutomatically = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        [self.tableView reloadData];
        
        self.guidesShapeLayer = [CAShapeLayer layer];
        self.guidesShapeLayer.lineWidth = 1;
        self.guidesShapeLayer.hidden = YES;
        [self.guidesShapeLayer lookin_removeImplicitAnimations];
        [self.guidesShapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:2], nil]];
        [self.tableView.contentView.documentView.layer addSublayer:self.guidesShapeLayer];
        
        self.searchTextFieldView = [LKTextFieldView new];
        self.searchTextFieldView.textField.placeholderString = NSLocalizedString(@"Filter", nil);
        [self.searchTextFieldView initCloseButton];
        self.searchTextFieldView.insets = NSEdgeInsetsMake(0, 7, 0, 1);
        self.searchTextFieldView.textField.font = NSFontMake(13);
        self.searchTextFieldView.textField.usesSingleLineMode = YES;
        self.searchTextFieldView.textField.lineBreakMode = NSLineBreakByTruncatingTail;
        self.searchTextFieldView.textField.drawsBackground = NO;
        self.searchTextFieldView.textField.bordered = NO;
        self.searchTextFieldView.textField.focusRingType = NSFocusRingTypeNone;
        self.searchTextFieldView.borderPosition = LKViewBorderPositionTop;
        self.searchTextFieldView.borderColors = LKColorsCombine(LookinColorMake(200, 201, 202), LookinColorMake(67, 68, 69));
        self.searchTextFieldView.image = NSImageMake(@"icon_hierarchy_search");
        self.searchTextFieldView.textField.delegate = self;
        [self addSubview:self.searchTextFieldView];
        @weakify(self);
        [[[self.searchTextFieldView.textField.rac_textSignal throttle:0.5] skip:1] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            x = [x stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, x.length)];    // 去掉所有空白字符
            if ([self.delegate respondsToSelector:@selector(hierarchyView:didInputSearchString:)]) {
                [self.delegate hierarchyView:self didInputSearchString:x];
            }
        }];
        self.searchTextFieldView.closeButton.target = self;
        self.searchTextFieldView.closeButton.action = @selector(_handleSearchCloseButton);
        
        [[RACObserve(self.tableView, contentInsets) distinctUntilChanged] subscribeNext:^(NSValue *x) {
            CGFloat insetTop = [x edgeInsetsValue].top;
            [LKNavigationManager sharedInstance].windowTitleBarHeight = insetTop;
        }];
    
        [[RACObserve(self, displayItems) throttle:.75] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self _bringGuidesLayerToFront];
        }];