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
    static dispatch_o