//
//  LKUserActionManager.m
//  Lookin
//
//  Created by Li Kai on 2019/8/30.
//  https://lookin.work
//

#import "LKUserActionManager.h"

@interface LKUserActionManager ()

@property(nonatomic, strong) NSPointerArray *delegators;

@end

@implementation LKUserActionManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKUserActionManager *instance = nil;
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
        self.delegators = [NSPointerArray weakObjectsPointerArray];
    }
    return self;
}

- (void)addDelegate:(id<LKUserActionManagerDelegate>)delegate {
    if (!delegate) {
        NSAssert(NO, @"");
        return;
    }
    if 