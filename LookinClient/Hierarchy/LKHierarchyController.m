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
        
        RAC(self.hierarchy