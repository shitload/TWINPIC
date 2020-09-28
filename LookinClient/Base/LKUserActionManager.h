//
//  LKUserActionManager.h
//  Lookin
//
//  Created by Li Kai on 2019/8/30.
//  https://lookin.work
//

#import <Foundation/Foundation.h>

@class LKUserActionManager;

typedef NS_ENUM(NSInteger, LKUserActionType) {
    LKUserActionType_None,
    LKUserActionType_PreviewOperation,  // 在 preview 里执行了 click、double click、pan 之类的操作
    LKUserActionType_DashboardClick,    // 点击了 dashboard
    LKUserActionType_SelectedItemChange,    // selectedItem 改变了
};

@protocol LKUserActionManagerDelegate <NSObject>

/// 当 sendAction 被业务调用时，该 delegate 方法也会被调用
- (void)LKUserActionManager:(LKUserActionManager *)manager didAct:(LKUserActionType)type;

@end

@interface LKUserActionManager :