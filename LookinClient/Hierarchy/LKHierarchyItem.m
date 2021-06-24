//
//  LKHierarchyObject.m
//  Lookin
//
//  Created by Li Kai on 2019/4/29.
//  https://lookin.work
//

#import "LKHierarchyItem.h"

@interface LKHierarchyItem ()

@property(nonatomic, assign, readwrite) NSUInteger indentation;
@property(nonatomic, weak, readwrite) LKHierarchyItem *superItem;

@end

@implementation LKHierarchyItem

- (NSArray<LKHierarchyItem *> *)flatItems {
    NSMutableArray<LKHierarchyItem *> *array = [NSMutableArray array];
    
    [array addObject:self];
    
    if (self.status == LKHierarchyItemStatusExpanded) {
        [self.subItems enumerateObjectsUsingBlock:^(LKHierarchyItem * _Nonnull obj, NSUInt