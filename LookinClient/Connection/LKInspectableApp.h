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

- (RACSignal *)submitModification:(LookinAttributeModification *)modification;

- (RACSignal *)fetchHierarchyDetailWithTaskPackages:(NSArray<LookinStaticAsyncUpdateTasksPackage *> *)packages;
- (void)cancelHierarchyDetailFetching;

- (void)pushHierarchyDetailBringForwardTaskPackages:(NSArray<LookinStaticAsyncUpdateTasksPackage *> *)packages;

- (RACSignal *)fetchModificationPatchWithTasks:(NSArray<LookinStaticAsyncUpdateTask *> *)tasks;

- (RACSignal *)fetchObjectWithOid:(unsigned long)oid;

- (RACSignal *)fetchClassesAndMethodTraceList;

- (RACSignal *)fetchSelectorNamesWithClass:(NSString *)className hasArg:(BOOL)hasArg;

- (RACSignal *)addMethodTraceWithClassName:(NSString *)className selName:(NSString *)selName;

- (RACSignal *)deleteMethodTraceWithClassName:(NSString *)className selName:(NSString *)selName;

- (RACSignal *)invokeMethodWithOid:(unsigned long)oid text:(NSString *)text;

/// 获取某个 imageView 的 image 对象，oid 是 imageView 的 oid
- (RACSignal *)fetchImageWithImageViewOid:(unsigned long)oid;

/// 修改一个 gestureRecognizer 的 enable 属性。如果 shouldBeEnabled 为 YES 则表示想要把它的 enable 属性修改为 YES
- (RACSignal *)modifyGestureRecognizer:(unsigned long)oid toBeEnabled:(BOOL)shouldBeEnabled;

#pragma mark - Push From iOS

- (void)handleMethodTraceRecord:(LookinMethodTraceRecord *)record;

@end
