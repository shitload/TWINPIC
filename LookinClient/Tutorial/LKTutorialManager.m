//
//  LKTutorialManager.m
//  Lookin
//
//  Created by Li Kai on 2019/6/27.
//  https://lookin.work
//

#import "LKTutorialManager.h"
#import "LKTutorialPopoverController.h"
#import "LKHelper.h"

static NSString * const Key_MethodTrace = @"Tut_0";
static NSString * const Key_USBLowSpeed = @"Tut_1";
static NSString * const Key_TogglePreview = @"Tut_2";
static NSString * const Key_QuickSelection = @"Tut_5";
static NSString * const Key_MoveWithSpace = @"Tut_6";
static NSString * const Key_DoubleClick = @"Tut_7";
static NSString * const Key_CopyTitle = @"Tut_8";
static NSString * const Key_EventsHandler = @"Tut_EventsHandler";

@interface LKTutorialManager () <NSPopoverDelegate>

@end

@implementation LKTutorialManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKTutorialManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone