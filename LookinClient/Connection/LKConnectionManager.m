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

@interface LKUSBConnectionPort : NSObject

@property(nonatomic, assign) int portNumber;

@property(nonatomic, strong) NSNumber *deviceID;

@property(nonatomic, strong) Lookin_PTChannel *connectedChannel;

@end

@implementation LKUSBConnectionPort

- (NSString *)description {
    return [NSString stringWithFormat:@"number:%@, deviceID:%@, connectedChannel:%@", @(self.portNumber), self.deviceID, self.connectedChannel];
}

@end

@interface LKConnectionManager () <Lookin_PTChannelDelegate>

@property(nonatomic, copy) NSArray<LKSimulatorConnectionPort *> *allSimulatorPorts;
@property(nonatomic, strong) NSMutableArray<LKUSBConnectionPort *> *allUSBPorts;

@end

@implementation LKConnectionManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKConnectionManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (instancetype)init {
    if (self = [super init]) {
        _channelWillEnd = [RACSubject subject];
        _didReceivePush = [RACSubject subject];
        
        self.allSimulatorPorts = ({
            NSMutableArray<LKSimulatorConnectionPort *> *ports = [NSMutableArray array];
            for (int number = LookinSimulatorIPv4PortNumberStart; number <= LookinSimulatorIPv4PortNumberEnd; number++) {
                LKSimulatorConnectionPort *port = [LKSimulatorConnectionPort new];
                port.portNumber = number;
                [ports addObject:port];
            }
            ports;
        });
        self.allUSBPorts = [NSMutableArray array];
        
        [self _startListeningForUSBDevices];
    }
    return self;
}

#pragma mark - Ports Connect

- (RACSignal *)tryToConnectAllPorts {
    return [[RACSignal zip:@[[self _tryToConnectAllSimulatorPorts],
                            [self _tryToConnectAllUSBDevices]]] map:^id _Nullable(RACTuple * _Nullable value) {
        RACTupleUnpack(NSArray<Lookin_PTChannel *> *simulatorChannels, NSArray<Lookin_PTChannel *> *usbChannels) = value;
        NSArray *connectedChannels = [simulatorChannels arrayByAddingObjectsFromArray:usbChannels];
        return connectedChannels;
    }];
}

/// 返回的 x 为所有已成功链接的 Lookin_PTChannel 数组，该方法不会 sendError:
- (RACSignal *)_tryToConnectAllSimulatorPorts {
    NSArray<RACSignal *> *tries = [self.allSimulatorPorts lookin_map:^id(NSUInteger idx, LKSimulatorConnectionPort *port) {
        return [[self _connectToSimulatorPort:port] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
            return [RACSignal return:nil];
        }];
    }];
    return [[RACSignal zip:tries] map:^id _Nullable(RACTuple * _Nullable value) {
        NSArray<Lookin_PTChannel *> *connectedChannels = [value.allObjects lookin_filter:^BOOL(id obj) {
            return (obj != [NSNull null]);
        }];
        return connectedChannels;
    }];
}

/// 返回的 x 为成功链接的 Lookin_PTChannel
/// 注意，如果某个 app 被退到了后台但是没有被 kill，则在这个方法里它的 channel 仍然会被成功连接
- (RACSignal *)_connectToSimulatorPort:(LKSimulatorConnectionPort *)port {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if (port.connectedChannel) {
            // 该 port 本来就已经成功连接
            [subscriber sendNext:port.connectedChannel];
            [subscriber sendCompleted];
            return nil;
        }
        
        Lookin_PTChannel *localChannel = [Lookin_PTChannel channelWithDelegate:self];
        [localChannel connectToPort:port.portNumber IPv4Address:INADDR_LOOPBACK callback:^(NSError *error, Lookin_PTAddress *address) {
            if (error) {
                if (error.domain == NSPOSIXErrorDomain && (error.code == ECONNREFUSED || error.code == ETIMEDOUT)) {
                    // 没有 iOS 客户端
                } else {
                    // 意外
                }
                [localChannel close];
                [subscriber sendError:error];
            } else {
                port.connectedChannel = localChannel;
                [subscriber sendNext:localChannel];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

/// 返回的 x 为所有已成功链接的 Lookin_PTChannel 数组，该方法不会 sendError:
- (RACSignal *)_tryToConnectAllUSBDevices {
    if (!self.allUSBPorts.count) {
        return [RACSignal return:[NSArray array]];
    }
    NSArray<RACSignal *> *tries = [self.allUSBPorts lookin_map:^id(NSUInteger idx, LKUSBConnectionPort *port) {
        return [[self _connectToUSBPort:port] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
            return [RACSignal return:nil];
        }];
    }];
    return [[RACSignal zip:tries] map:^id _Nullable(RACTuple * _Nullable value) {
        NSArray<Lookin_PTChannel *> *connectedChannels = [value.allObjects lookin_filter:^BOOL(id obj) {
            return (obj != [NSNull null]);
        }];
        return connectedChannels;
    }];
}

/// 返回的 x 为成功链接的 Lookin_PTChannel
- (RACSignal *)_connectToUSBPort:(LKUSBConnectionPort *)port {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if (port.connectedChannel) {
            // 该 port 本来就已经成功连接
            [subscriber sendNext:port.connectedChannel];
            [subscriber sendCompleted];
            return nil;
        }
        
        Lookin_PTChannel *channel = [Lookin_PTChannel channelWithDelegate:self];
        [channel connectToPort:port.portNumber overUSBHub:Lookin_PTUSBHub.sharedHub deviceID:port.deviceID callback:^(NSError *error) {
            if (error) {
                if (error.domain == Lookin_PTUSBHubErrorDomain && error.code == PTUSBHubErrorConnectionRefused) {
                    // error
                } else {
                    // error
                }
                [channel close];
                [subscriber sendError:error];
            } else {
                // succ
                port.connectedChannel = channel;
                [subscriber sendNext:channel];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

#pragma mark - Request

- (void)pushWithType:(unsigned int)pushType data:(NSObject *)data channel:(Lookin_PTChannel *)channel {
    if (!channel || !channel.isConnected) {
        return;
    }
    NSError *archiveError = nil;
    dispatch_data_t payload = [[NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:YES error:&archiveError] createReferencingDispatchData];
    if (archiveError) {
        NSAssert(NO, @"");
    }
    NSLog(@"LookinClient - pushData, type:%@", @(pushType));
    [channel sendFrameOfType:pushType tag:0 withPayload:payload callback:nil];
}

- (RACSignal *)requestWithType:(unsigned int)requestType data:(NSObject *)requestData channel:(Lookin_PTChannel *)channel {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //        NSLog(@"LookinClient, level1 - will ping for request:%@, port:%@", @(type), @(channel.portNumber));
        NSTimeInterval timeoutInterval;
        if (requestType == LookinRequestTypeApp) {
            // 如果某个 iOS app 连接上了 channel 却又处于后台的话，而这个 timeout 时间又过长的话，就会导致初次进入 launch 时非常慢（因为必须等到 timeoutInterval 结束），因此这里为了体验缩小这个时间
            timeoutInterval = .5;
        } else {
            timeoutInterval = 2;
        }
        
        [self _requestWithType:LookinRequestTypePing channel:channel data:nil timeoutInterval:timeoutInterval succ:^(LookinConnectionResponseAttachment *pingResponse) {
            // ping 成功了
            // NSLog(@"LookinClient, level1 - ping succ, will send request:%@, port:%@", @(type), @(channel.portNumber));
            NSError *versionErr = [self _checkServerVersionWithResponse:pingResponse];
            if (versionErr) {
                // LookinServer 版本有问题
                [subscriber sendError:versionErr];
            } else {
                // 没问题，开始发真正请求
                [self _requestWithType:requestType channel:channel data:requestData timeoutInterval:5 succ:^(id responseData) {
                    RACTuple *tupleResult = [RACTuple tupleWithObjects:responseData, channel, nil];
                    [subscriber sendNext:tupleResult];
                } fail:^(NSError *error) {
                    [subscriber sendError:error];
                } completion:^{
                    [subscriber sendCompleted];
                }];
            }
            
        } fail:^(NSError *error) {
            // ping 失败了
            [subscriber sendError:error];
            
        } completion:nil];
        return nil;
    }];
}

- (NSError *)_checkServerVersionWithResponse:(LookinConnectionResponseAttachment *)pingResponse {
    int serverVersion = pingResponse.lookinServerVersion;
    BOOL serverIsExprimental = [pingResponse respondsToSelector:@selector(lookinServerIsExprimental)] && pingResponse.lookinServerIsExprimental;
    if (serverVersion == -1 || serverVersion == 100) {
        // 说明用的还是旧版本的内部版本 LookinServer，这里兼容一下
        NSError *versionErr = [NSError errorWithDomain:LookinErrorDomain code:LookinErrCode_ServerVersionTooLow userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Fail to inspect this iOS app due to a version problem.", nil), NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Please update LookinServer.framework linked with target iOS App to a newer version. Visit the website below to get detailed instructions:\nhttps://lookin.work/faq/server-version-too-low/", nil)}];
        return versionErr;
    }
    
    if (LOOKIN_CLIENT_IS_EXPERIMENTAL && !serverIsExprimental) {
        // client 是私有版本，framework 是官网版本
        NSError *versionErr = [NSError errorWithDomain:LookinErrorDomain code:LookinErrCode_ClientIsPrivate userInfo:nil];
        return versionErr;
    
    }
    
    if (!LOOKIN_CLIENT_IS_EXPERIMENTAL && serverIsExprimental) {
        // client 是现网版本，framework 是私有版本
        NSError *versionErr = [NSError errorWithDomain:LookinErrorDomain code:LookinErrCode_ServerIsPrivate userInfo:nil];
        return versionErr;
        
    }
    
    if (serverVersion > LOOKIN_SUPPORTED_SERVER_MAX) {
        // server 版本过高，需要升级 client
        NSError *versionErr = [NSError errorWithDomain:LookinErrorDomain code:LookinErrCode_ServerVersionTooHigh userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Lookin app version is too low.", nil), NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Target iOS app is linked with a higher version LookinServer.framework. Please click \"Lookin\"-\"Check for Updates\" near the top-left corner or visit https://lookin.work to update your Lookin app.", nil)}];
        return versionErr;
        
    }
    
    if (serverVersion < LOOKIN_SUPPORTED_SERVER_MIN) {
        // server 版本过低，需