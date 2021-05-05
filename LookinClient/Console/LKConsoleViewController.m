
//
//  LKConsoleViewController.m
//  Lookin
//
//  Created by Li Kai on 2019/4/19.
//  https://lookin.work
//

#import "LKConsoleViewController.h"
#import "LKConsoleDataSource.h"
#import "LKConsoleDataSourceRowItem.h"
#import "LKTableView.h"
#import "LKConsoleSubmitRowView.h"
#import "LKConsoleReturnRowView.h"
#import "LKConsoleInputRowView.h"
#import "LKTableRowView.h"
#import "LookinObject.h"

@interface LKConsoleViewController () <LKTableViewDelegate, LKTableViewDataSource>

@property(nonatomic, strong) LKConsoleDataSource *dataSource;
@property(nonatomic, strong) LKTableView *tableView;
@property(nonatomic, strong) NSButton *clearButton;

@property(nonatomic, strong) LKConsoleInputRowView *inputRowView;
@property(nonatomic, strong) CALayer *topBorderLayer;

@end

@implementation LKConsoleViewController

- (instancetype)initWithHierarchyDataSource:(LKHierarchyDataSource *)dataSource {
    self.dataSource = [[LKConsoleDataSource alloc] initWithHierarchyDataSource:dataSource];

    if (self = [self initWithContainerView:nil]) {
        @weakify(self);
        [RACObserve(self.dataSource, rowItems) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.tableView reloadData];
            [self.tableView layoutSubtreeIfNeeded];
            
            if (self.dataSource.rowItems.count) {
                [self.tableView scrollRowToVisible:(self.dataSource.rowItems.count - 1)];
            }
            [self.inputRowView makeTextFieldAsFirstResponder];
        }];
    }
    return self;
}

- (NSView *)makeContainerView {
    LKBaseView *containerView = [LKBaseView new];
    containerView.backgroundColorName = @"ConsoleBackgroundColor";
    
    self.inputRowView = [[LKConsoleInputRowView alloc] initWithDataSource:self.dataSource];
    
    self.tableView = [LKTableView new];
    self.tableView.drawsBackground = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.canScrollHorizontally = NO;
    self.tableView.adjustsSelectionAutomatically = NO;
    self.tableView.adjustsHoverAutomatically = NO;
    self.tableView.automaticallyAdjustsContentInsets = NO;
    self.tableView.contentInsets = NSEdgeInsetsMake(5, 0, 5, 0);
    [containerView addSubview:self.tableView];
    
    NSImage *clearButtonImage = NSImageMake(@"icon_delete");
    clearButtonImage.template = YES;
    self.clearButton = [NSButton new];
    self.clearButton.image = clearButtonImage;
    self.clearButton.bezelStyle = NSBezelStyleRoundRect;
    self.clearButton.bordered = NO;
    self.clearButton.target = self;
    self.clearButton.action = @selector(_handleClearButton);
    [containerView addSubview:self.clearButton];
    
    self.topBorderLayer = [CALayer layer];
    [self.topBorderLayer lookin_removeImplicitAnimations];
    [containerView.layer addSublayer:self.topBorderLayer];
    @weakify(self);
    containerView.didChangeAppearanceBlock = ^(LKBaseView *view, BOOL isDarkMode) {
        @strongify(self);
        if (isDarkMode) {
            self.topBorderLayer.backgroundColor = [NSColor colorWithWhite:1 alpha:.12].CGColor;
        } else {
            self.topBorderLayer.backgroundColor = [NSColor colorWithWhite:0 alpha:.15].CGColor;
        }
    };

    return containerView;
}

- (void)viewDidAppear {
    [super viewDidAppear];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView scrollRowToVisible:(self.dataSource.rowItems.count - 1)];
        [self.inputRowView makeTextFieldAsFirstResponder];
    });
}

- (void)viewDidLayout {
    [super viewDidLayout];
    $(self.topBorderLayer).fullWidth.height(1).y(0);
    
    $(self.tableView).fullFrame;
    $(self.clearButton).sizeToFit.right(20).bottom(8);
    
    CGFloat prevWidth = [self lookin_getBindDoubleForKey:@"prevWidth"];
    if (prevWidth != self.view.$width) {
        [self lookin_bindDouble:self.view.$width forKey:@"prevWidth"];
        [self.tableView reloadData];
    }
}

- (void)_handleClearButton {
    [self.dataSource clearHistoryContents];
}

- (void)setIsControllerShowing:(BOOL)isControllerShowing {
    self.dataSource.isShowingConsole = isControllerShowing;
}

- (BOOL)isControllerShowing {
    return self.dataSource.isShowingConsole;
}

#pragma mark - LKTableView

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSInteger count = self.dataSource.rowItems.count;
    return count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    LKConsoleDataSourceRowItem *item = [self.dataSource.rowItems lookin_safeObjectAtIndex:row];
    if (!item) {
        return 0;