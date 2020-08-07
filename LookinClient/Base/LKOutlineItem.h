
//
//  LKOutlineItem.h
//  Lookin
//
//  Created by Li Kai on 2019/5/28.
//  https://lookin.work
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LKOutlineItemStatus) {
    LKOutlineItemStatusNotExpandable,
    LKOutlineItemStatusExpanded,
    LKOutlineItemStatusCollapsed
};

@interface LKOutlineItem : NSObject