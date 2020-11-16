//
//  LKDeviceManager.m
//  Lookin
//
//  Created by Li Kai on 2018/11/3.
//  https://lookin.work
//

#import "LKAppsManager.h"
#import "Lookin_PTChannel.h"
#import "LKConnectionManager.h"
#import "LookinDefines.h"
#import "LookinAppInfo.h"
#import "LookinHierarchyInfo.h"
#import "LookinConnectionResponseAttachment.h"
#import "LookinMethodTraceRecord.h"

NSString *const LKInspectingAppDidEndNotificationName = @"LKInspectingAppDidEndNotificationName";

@interface LKAppsManager ()

@property(nonatomic, strong) RACSubject *willConnectToApp;

@end

@implementation LKAppsManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKAppsManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (instancetype)init {
    if (self = [super init]) {
        _willConnectToApp = [RACSubject subject];
        _didAutoReconnectSucc = [RACSubject subject];
        
        @weakify(self);
        [[[[LKConnectionManager sharedInstance].channelWillEnd filter:^BOOL(Lookin_PTChannel *channel) {
            @strongify(self);
            return channel == self.inspectingApp.channel;
            
        }] flattenMap:^__kindof RACSignal * _Nullable(Lookin_PTChannel *channel) {
            @strongify(self);
            
            NSLog(@"current connection end");
            
            LookinAppInfo *targetAppInfo = self.inspectingApp.appInfo;
            self.inspectingApp = nil;
            
            RACSignal *signal = [[[RACSignal interval:3 onScheduler:[RACScheduler scheduler]] takeUntil:self.willConnectToApp] flattenMap:^__kindof RACSignal * _Nullable(NSDate * _Nullable value) {
                return [self _fetchInspectableAppWithSimilarInfo:targetAppInfo];
            }];
            re