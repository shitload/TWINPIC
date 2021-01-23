//
//  LKConnectionManager.m
//  Lookin
//
//  Created by Li Kai on 2018/11/2.
//  https://lookin.work
//

#import "LKConnectionManager.h"
#import "Lookin_PTChannel.h"
#import "LookinDefines.h"
#import "LookinConnectionResponseAttachment.h"
#import "LKPreferenceManager.h"
#import "LookinAppInfo.h"
#import "LKConnectionRequest.h"

static NSIndexSet * PushFrameTypeList() {
    static NSIndexSet *list;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:LookinPush_MethodTraceRecord];
        list = set.copy;
    });
    return list;
}

@interface Lookin_PTChannel (LKConnection)

/// 已经发送但尚未收到全部回复的请求
@property(nonatomic, strong) NSMutableSet<LKConnectionRequest *> *activeRequests;

@end

@implementation Lookin_PTChannel (LKConnection)

- (void)setActiveRequests:(NSMutableSet<LKConnectionRequest *> *)activeRequests {
    [self lookin_bindObject:activeRequests forKey:@"activeRequest"];
}

- (NSMutableSet<LKConnectionRequest *> *)activeRequests {
    return [self lookin_getBindObjectForKey:@"activeRequest"];
}

@end

@interface LKSimulatorConnectionPort : NSObject

@property(nonatomic, assign) int portNumber;

@property(nonatomic, strong) Lookin_PTChannel *connectedChannel;

@end

@implementation LKSimulatorConnectionPort

- (NSString *)description {
    return [NSString stringWithFormat:@"number:%@", @(self.portNumber)];
}

@end

@interface LKUSBConnect