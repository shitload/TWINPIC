//
//  LKHierarchyView.h
//  Lookin
//
//  Created by Li Kai on 2018/8/4.
//  https://lookin.work
//

#import "LKBaseView.h"
#import "LKHierarchyRowView.h"

@class LKHierarchyView, LKTableView;

@protocol LKHierarchyViewDelegate <NSObject>

- (void)hierarchyView:(LKHierarchyView *)view didSelectItem:(LookinDisplayItem *)item;

- (void)hierarchyView:(LKHierarchyView *)view didDoubleClickItem:(LookinDisplayItem *)item;

- (void)hierarchyView:(LKHierarchyView *)view didHoverAtItem:(LookinDisplayItem *)item;

- (void)hierarchyView:(LKHierarchyView *)view needToExpandItem:(LookinDisplayItem *)item recursively:(BOOL)recursively;

- (void)hierarchyView:(LKHie