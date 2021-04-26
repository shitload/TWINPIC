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

- (RACSignal *)submitModification:(LookinAttributeModific