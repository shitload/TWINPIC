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
            return signal;
            
        }] subscribeNext:^(LKInspectableApp *newApp) {
            @strongify(self);
            if (newApp) {
                NSLog(@"Reconnected successfully.");
                self.inspectingApp = newApp;
                [self.didAutoReconnectSucc sendNext:newApp];
            } else {
//                NSLog(@"Failed to reconnect.");
            }
        }];
        
        [[LKConnectionManager sharedInstance].didReceivePush subscribeNext:^(RACTuple *x) {
            @strongify(self);
            RACTupleUnpack(Lookin_PTChannel *channel, NSNumber *type, NSObject *data) = x;
            if (channel != self.inspectingApp.channel) {
                return;
            }
            
            if (type.intValue == LookinPush_MethodTraceRecord) {
                if ([data isKindOfClass:[LookinMethodTraceRecord class]]) {
                    [self.inspectingApp handleMethodTraceRecord:(LookinMethodTraceRecord *)data];
                } else {
                    NSAssert(NO, @"");
                }
            }
        }];
        
    }
    return self;
}

- (void)setInspectingApp:(LKInspectableApp *)inspectingApp {
    BOOL shouldPostNotification = (_inspectingApp && !inspectingApp);
    
    _inspectingApp = inspectingApp;
    if (inspectingApp) {
        [self.willConnectToApp sendNext:inspectingApp];
    }
    
    if (shouldPostNotification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LKInspectingAppDidEndNotificationName object:self];
    }
}

- (RACSignal *)_fetchInspectableAppWithSimilarInfo:(LookinAppInfo *)appInfo {
    return [[[self fetchAppInfosWithImage:NO localInfos:nil] map:^id _Nullable(NSArray<LKInspectableApp *> *allApps) {
//        NSLog(@"Reconnecting… ...");
        LKInspectableApp *targetApp = [allApps lookin_firstFiltered:^BOOL(LKInspectableApp *obj) {
            return [appInfo isEqualToAppInfo:obj.appInfo];
        }];
        targetApp.appInfo.appIcon = appInfo.appIcon;
        return targetApp;
    }] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        return [RACSignal return:nil];
    }];
}

- (RACSignal *)fetchAppInfosWithImage:(BOOL)needImages localInfos:(NSArray<LookinAppInfo *> *)localInfos {
    NSArray<LookinAppInfo *> *validAppInfos = [localInfos lookin_filter:^BOOL(LookinAppInfo *info) {
        /// 超过 8 秒则认为过期
        return [[NSDate date] timeIntervalSince1970] - info.cachedTimestamp <= 8;
    }];
    
    NSArray<NSNumber *> *localInfoIdentifiers = [validAppInfos lookin_map:^id(NSUInteger idx, LookinAppInfo *value) {
        return @(value.appInfoIdentifier);
    }] ? : @[];
    NSDictionary *params = @{@"needImages":@(needImages), @"local":localInfoIdentifiers};
    
    return [[[[LKConnectionManager sharedInstance] tryToConnectAllPorts] flattenMap:^__kindof RACSignal * _Nullable(NSArray<Lookin_PTChannel *> *connectedChannels) {
        if (!connectedChannels.count) {
            // 没有任何 channel
            return [RACSignal return:nil];
        }
        
        NSArray<RACSignal *> *signals = [connectedChannels lookin_map:^id(NSUInteger idx, Lookin_PTChannel *channel) {
            return [[[LKConnectionManager sharedInstance] requestWithType:LookinRequestTypeApp data:params channel:channel] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) 