//
//  LKStaticAsyncUpdateManager.h
//  Lookin
//
//  Created by Li Kai on 2019/2/19.
//  https://lookin.work
//

#import <Foundation/Foundation.h>

@class LookinDisplayItem, LookinStaticDisplayItem;

@interface LKStaticAsyncUpdateManager : NSObject

+ (instancetype)sharedInstance;

/// 开始拉取
- (void)updateAll;
/// 终止拉取
- (void)endUpdatingAll;
/// 调用 updateAll 后，该 signal 会不断发出信号。data 是 RA