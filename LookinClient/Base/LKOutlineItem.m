//
//  LKOutlineItem.m
//  Lookin
//
//  Created by Li Kai on 2019/5/28.
//  https://lookin.work
//

#import "LKOutlineItem.h"

@interface LKOutlineItem ()

@property(nonatomic, assign, readwrite) NSUInteger indentation;

@end

@implementation LKOutlineItem

- (void)setSubItems:(NSArray<LKOutlineItem *> *)subItems {
    _subItems = subItems.copy;
    if (subItems) {
        self.status = LKOutlineItemStatusCollapsed;
    } else {
        self.status = LKOutlineItemStatusNotExpandable;
    }
}

- (NSArray<LKOutlineItem *> *)flatItems {
