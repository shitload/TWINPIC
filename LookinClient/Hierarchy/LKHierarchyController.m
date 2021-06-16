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
