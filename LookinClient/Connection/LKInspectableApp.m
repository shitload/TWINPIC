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

- (void)pushHierarchyDetail