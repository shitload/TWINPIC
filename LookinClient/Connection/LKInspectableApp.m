//
//  LKDeviceItem.m
//  Lookin
//
//  Created by Li Kai on 2018/11/3.
//  https://lookin.work
//

#import "LKInspectableApp.h"
#import "LKConnectionManager.h"
#import "LookinConnectionResponseAttachment.h"
#import "LKNavigationManager.h"
#import "LKMethodTraceDataSource.h"

@implementation LKInspectableApp

- (RACSignal *)fetchHierarchyData {
    return [self _requestWithType:LookinRequestTypeHierarchy data:nil];
}

- (RACSignal *)submitModification:(LookinAttributeModification *)modification {
    return [self _requestWithType:LookinRequestTypeModification data:modification];
}

- (RACSignal *)fetchHierarchyDetailWithTaskPackages:(NSArray<LookinStaticAsyncUpdateTasksPackage *> *)packages {
    return [self _requestWithType:LookinRequestTypeHierarchyDetails data:packages];
}

- (void)cancelHierarchyDetailFetching {
    [self _cancelRequestWithType:LookinRequestTypeHierarchyDetails];
    [self _pushWithType:LookinPush_CanceHierarchyDetails data:nil];
}

- (void)pushHierarchyDetailBringForwardTaskPackages:(NSArray<LookinStaticAsyncUpdateTasksPackage *> *)packages {
    [self _pushWithType:LookinPush_BringForwardScreenshotTask data:packages];
}

- (RACSignal *)fetchModificationPatchWithTasks:(NSArray<LookinStaticAsyncUpdateTask *> *)tasks {
    return [self _requestWithType:LookinRequestTypeAttrModificationPatch data:tasks];
}

- (RACSignal *)fetchObjectWithOid:(unsigned long)oid {
    if (!oid) {
        return [RACSignal error:LookinErr_Inner];
    }
    return [self _requestWithType:LookinRequestTypeFetchObject data:@(oid)];
}

- (RACSignal *)fetchClassesAndMethodTraceList {
    return [self _requestWithType:LookinRequestTypeClassesAndMethodTraceLit data:nil];
}

- (RACSignal *)fetchSelectorNamesWithClass:(NSString *)className hasArg:(BOOL)hasArg {
    return [self _requestWithType:LookinRequestTypeAllSelectorNames data:@{@"className":className, @"hasArg":@(hasArg)}];
}

- (RACSignal *)addMethodTraceWithClassName:(NSString *)className selName:(NSString *)selName {
    if (!className || !selName) {
        return [RACSignal error:LookinErr_Inner];
    }
    return [self _requestWithType:LookinRequestTypeAddMethodTrace data:@{@"className": className, @"selName":selName}];
}

- (RACSignal *)deleteMethodTraceWithClassName:(NSString *)className selName:(NSString *)selName {
    if (!className) {
        return [RACSignal error:LookinErr_Inner];
    }
    NSDictionary *param = selName ? @{@"className": className, @"selName":selName} : @{@"className": className};
    return [self _requestWithType:LookinRequestTypeDeleteMethodTrace data:param];
}

- (RACSignal *)invokeMethodWithOid:(unsigned long)oid text:(NSString *)text {
    if (oid == 0 || !text.length) {
        return [RACSignal error:LookinErr_Inner];
    }
    NSDictionary *param = @{@"oid":@(oid), @"text":text};
    return [[self _requestWithType:LookinRequestTypeInvokeMethod data:param] map:^id _Nullable(NSDictionary * _Nullable value) {
        if ([value[@"description"] isEqualToString:LookinStringFlag_VoidReturn]) {
            // 方法没有返回值时，替换成本地说明
            NSMutableDictionary *newValue = [value mutableCopy];
            newValue[@"description"] = NSLocalizedString(@"The method was invoked su