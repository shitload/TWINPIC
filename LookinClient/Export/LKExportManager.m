
//
//  LKExportManager.m
//  Lookin
//
//  Created by Li Kai on 2019/5/12.
//  https://lookin.work
//

#import "LKExportManager.h"
#import "LookinHierarchyInfo.h"
#import "LookinHierarchyFile.h"
#import "LookinAppInfo.h"
#import "LookinDisplayItem.h"
#import "LookinDocument.h"
#import "LKHelper.h"
#import "LKNavigationManager.h"
#import "LookinDisplayItem.h"

@implementation LKExportManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKExportManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{