//
//  LKDeviceItem.h
//  Lookin
//
//  Created by Li Kai on 2018/11/3.
//  https://lookin.work
//

#import <Foundation/Foundation.h>
#import "LookinAppInfo.h"
#import "LookinAttributeModification.h"
#import "LookinAttributesGroup.h"

@class Lookin_PTChannel, LookinDisplayItemTrace, LookinInvocationRequest, LookinHierarchyInfo, LookinMethodTraceRecord, LookinStaticAsyncUpdateTasksPackage, LookinStaticAsyncUpdateTask;

@interface LKInspectableApp : NSObject

@property(nonatomic, strong) NSError *serverVersionError;

@property(nonatomic, strong) LookinAppInfo *appInfo;

@property(nonatomic, weak) Lookin_PTChannel *channel;

- (RACSignal *)fetchHierarchyData;

- (RACSignal *)submitModification:(LookinAttributeModifi