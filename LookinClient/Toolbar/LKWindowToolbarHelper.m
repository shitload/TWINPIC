//
//  LKWindowToolbarHelper.m
//  Lookin
//
//  Created by Li Kai on 2019/5/8.
//  https://lookin.work
//

#import "LKWindowToolbarHelper.h"
#import "LKPreferenceManager.h"
#import "LKMenuPopoverSettingController.h"
#import "LKAppsManager.h"
#import "LKNavigationManager.h"
#import "LookinPreviewView.h"
#import "LKWindowToolbarScaleView.h"
#import "LKWindowToolbarAppButton.h"

NSToolbarItemIdentifier const LKToolBarIdentifier_Dimension = @"0";
NSToolbarItemIdentifier const LKToolBarIdentifier_Scale = @"1";
NSToolbarItemIdentifier const LKToolBarIdentifier_Setting = @"2";
NSToolbarItemIdentifier const LKToolBarIdentifier_Reload = @"3";
NSToolbarItemIdentifier const LKToolBarIdentifier_App = @"5";
NSToolbarItemIdentifier const LKToolBarIdentifier_AppInReadMode = @"12";
NSToolbarItemIdentifier const LKToolBarIdentifier_Add = @"13";
NSToolbarItemIdentifier const LKToolBarIdentifier_Remove = @"14";
NSToolbarItemIdentifier const LKToolBarIdentifier_Console = @"15";
NSToolbarItemIdentifier const LKToolBarIdentifier_Rotation = @"16";
NSToolbarItemIdentifier const LKToolBarIdentifier_Measure = @"17";

static NSString * const Key_BindingPreferenceManager = @"PreferenceManager";
static NSString * const Key_BindingAppInfo = @"AppInfo";

@interface LKWindowToolbarHelper ()

@end

@implementation LKWindowToolbarHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKWindowToolbarHelper *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (NSToolbarItem *)makeToolBarItemWithIdentifier:(NSToolbarItemIdentifier)identifier preferenceManager:(LKPreferenceManager *)manager {
    NSAssert(![identifier isEqualToString:LKToolBarIdentifier_AppInReadMode], @"请使用 makeAppInReadModeItemWithAppInfo: 方法");
    
    if ([identifier isEqualToString:LKToolBarIdentifier_Measure]) {
        NSImage *image = NSImageMake(@"icon_measure");
        image.template = YES;
        
        NSButton *button = [NSButton new];
        [button setImage:image];
        button.bezelStyle = NSBezelStyleTexturedRounded;
        [button setButtonType:NSButtonTypePushOnPushOff];
        button.target = self;
        button.action = @selector(_handleToggleMeasureButton:);
        [button lookin_bindObject:manager forKey:@"manager"];
        
        NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:LKToolBarIdentifier_Measure];
        item.label = NSLocalizedString(@"Measure", nil);
        item.view = button;
        item.minSize = NSMakeSize(48, 34);

        [manager.isMeasuring subscribe:self action:@selector(_handleMeasureDidChange:) relatedObject:button sendAtOnce:YES];
        
        return item;
    }
    
    if ([identifier isEqualToString:LKToolBarIdentifier_Rotation]) {
        NSImage *image = NSImageMake(@"icon_rotation");
        image.template = YES;
        
        NSButton *button = [NSButton new];
        [button setImage:image]