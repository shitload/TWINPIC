//
//  LKHierarchyController.m
//  Lookin
//
//  Created by Li Kai on 2019/5/12.
//  https://lookin.work
//

#import "LKHierarchyController.h"
#import "LKHierarchyDataSource.h"
#import "LookinDisplayItem.h"
#import "LKTableView.h"
#import "LKTutorialManager.h"

@interface LKHierarchyController ()

@end

@implementation LKHierarchyController


- (instancetype)initWithDataSource:(LKHierarchyDataSource *)dataSource {
    if (self = [self initWithContainerView:nil]) {
        _dataSource = dataSource;
        
        @weakify(self);
        [RACObserve(dataSource, selectedItem) subscribeNext:^(LookinDisplayItem * _Nullable item) {
            @strongify(self);
            [self.hierarchyView scrollToMakeItemVisible:item];
        }];
        
        RAC(self.hierarchyView, displayItems) = [RACObserve(self.dataSource, displayingFlatItems) doNext:^(id  _Nullable x) {
            @strongify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.hierarchyView updateGuidesWithHoveredItem:self.dataSource.hoveredItem];
            });
        }];
        
        [[RACObserve(self.dataSource, hoveredItem) distinctUntilChanged] subscribeNext:^(LookinDisplayItem * _Nullable x) {
            [self.hierarchyView updateGuidesWithHoveredItem:x];
        }];
    }
    return self;
}

- (void)viewDidAppear {
    [super viewDidAppear];
    if (!TutorialMng.hasAlreadyShowedTipsThisLaunch && !TutorialMng.copyTitle) {
        NSView *selectedView = [self currentSelectedRowView];
        if (selectedView) {
            TutorialMng.hasAlreadyShowedTipsThisLaunch = YES;
            [TutorialMng showPopoverOfView:selectedView text:NSLocalizedString(@"You can copy ivar or class name in right-cick menu.", nil) learned:^{
                TutorialMng.copyTitle = YES;
            }];
        }
    }
    if (!TutorialMng.hasAlreadyShowedTipsThisLaunch && !TutorialMng.eventsHandler) {
        // 第一个 row 一般是 UIWindow，上面肯定是有手势的
        LKHierarchyRowView *rowView = [self.hierarchyView.tableView.tableView rowViewAtRow:0 makeIfNecessary:NO];
        if (![rowView isKindOfClass:[LKHierarchyRowView class]]) {
            return;
        }
        if (rowView.displayItem.eventHandlers.count && rowView.eventHandlerButton) {
            TutorialMng.hasAlreadyShowedTipsThisLaunch = YES;
            TutorialMng.eventsHandler = YES;
            [TutorialMng showPopoverOfView:rowView.eventHandlerButton text:@"这个蓝色图标表示存在 GestureRecognizer 等事件处理器，可点击这个蓝色图标查看详情" learned:^{
                TutorialMng.eventsHandler = YES;
            }];
        }
    }
}

- (NSView *)makeContainerView {
    LKHierarchyView *hierarchyView = [[LKHierarchyView alloc] init];
    hierarchyView.delegate = self;
    _hierarchyView = hierarchyView;
    return hierarchyView;
}

- (NSView *)currentSelectedRowView {
    NSInteger row = [self.dataSource.displayingFlatItems indexOfObject:self.dataSource.selectedItem];
    if (row == NSNotFound) {
//        NSAssert(NO, @"LKHierarchyController, currentSelectedRowView, NSNotFound");
        return nil;
    }
    return [self.hierarchyView.tableView.tableView rowViewAtRow:row makeIfNecessary:NO];
}

#pragma mark - <LKHierarchyViewDelegate>

- (void)hierarchyView:(LKHierarchyView *)view didSelectItem:(LookinDisplayItem *)item {
    self.dataSource.selectedItem = item;
}

- (void)hierarchyView:(LKHierarchyView *)view didDoubleClickItem:(LookinDisplayItem *)item {
    if (!item.isExpandable) {
        return;
    }
    if (item.is