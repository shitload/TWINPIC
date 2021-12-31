//
//  LKPreferenceManager.m
//  Lookin
//
//  Created by Li Kai on 2019/1/8.
//  https://lookin.work
//

#import "LKPreferenceManager.h"
#import "LookinDashboardBlueprint.h"
#import "LookinPreviewView.h"
@import AppCenter;

NSString *const NotificationName_DidChangeSectionShowing = @"NotificationName_DidChangeSectionShowing";

NSString *const LKWindowSizeName_Dynamic = @"LKWindowSizeName_Dynamic";
NSString *const LKWindowSizeName_Static = @"LKWindowSizeName_Static";
NSString *const LKWindowSizeName_Methods = @"LKWindowSizeName_Methods";

const CGFloat LKInitialPreviewScale = 0.27;

static NSString * const Key_PreviousClientVersion = @"preVer";
static NSString * const Key_ShowOutline = @"showOutline";
static NSString * const Key_ShowHiddenItems = @"showHiddenItems";
static NSString * const Key_EnableReport = @"enableReport";
static NSString * const Key_RgbaFormat = @"egbaFormat";
static NSString * const Key_ZInterspace = @"zInterspace_v095";
static NSString * const Key_AppearanceType = @"appearanceType";
static NSString * const Key_ExpansionIndex = @"expansionIndex";
static NSString * const Key_SectionsShow = @"ss";
static NSString * const Key_CollapsedGroups = @"collapsedGroups_918";
static NSString * const Key_PreferredExportCompression = @"preferredExportCompression";
static NSString * const Key_CallStackType = @"callStackType";
static NSString * const Key_SyncConsoleTarget = @"syncConsoleTarget";
static NSString * const Key_FreeRotation = @"FreeRotation";
static NSString * const Key_ReceivingConfigTime_Color = @"ConfigTime_Color";
static NSString * const Key_ReceivingConfigTime_Class = @"ConfigTime_Class";

@interface LKPreferenceManager ()

@property(nonatomic, strong) NSMutableDictionary<LookinAttrSectionIdentifier, NSNumber *> *storedSectionShowConfig;

@end

@implementation LKPreferenceManager

+ (instancetype)mainManager {
    static dispatch_once_t onceToken;
    static LKPreferenceManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        instance.shouldStoreToLocal = YES;
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _previewScale = [LookinDoubleMsgAttribute attributeWithDouble:LKInitialPreviewScale];
        _previewDimension = [LookinIntegerMsgAttribute attributeWithInteger:LookinPreviewDimension3D];
        _isMeasuring = [LookinBOOLMsgAttribute attributeWithBOOL:NO];
        _isQuickSelecting = [LookinBOOLMsgAttribute attributeWithBOOL:NO];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        // 如果本次 Lookin 客户端的 version 和上次不同，则该变量会被置为 YES
//        BOOL clientVersionHasChanged = NO;
        NSInteger prevClientVersion = [userDefaults integerForKey:Key_PreviousClientVersion];
        if (prevClientVersion != LOOKIN_CLIENT_VERSION) {
//            clientVersionHasChanged = YES;
            [[NSUserDefaults standardUserDefaults] setInteger:LOOKIN_CLIENT_VERSION forKey:Key_PreviousClientVersion];
        }
        
        NSNumber *obj_showOutline = [userDefaults objectForKey:Key_ShowOutline];
        if (obj_showOutline != nil) {
            _showOutline = [LookinBOOLMsgAttribute attributeWithBOOL:[obj_showOutline boolValue]];
        } else {
            _showOutline = [LookinBOOLMsgAttribute attributeWithBOOL:YES];
            [userDefaults setObject:@(YES) forKey:Key_ShowOutline];
        }
        [self.showHiddenItems subscribe:self action:@selector(_handleShowOutlineDidChange:) relatedObject:nil];
        
        NSNumber *obj_showHiddenItems = [userDefaults objectForKey:Key_ShowHiddenItems];
        if (obj_showHiddenItems != nil) {
            _showHiddenItems = [LookinBOOLMsgAttribute attributeWithBOOL:[obj_showHiddenItems boolValue]];
        } else {
            _showHiddenItems = [LookinBOOLMsgAttribute attributeWithBOOL:NO];
            [userDefaults setObject:@(NO) forKey:Key_ShowHiddenItems];
        }
        [self.showHiddenItems subscribe:self action:@selector(_handleShowHiddenItemsChange:) relatedObject:nil];
        
        NSNumber *obj_enableReport = [userDefaults objectForKey:Key_EnableReport];
        if (obj_enableReport != nil) {
            _enableReport = [obj_enableReport boolValue];
        } else {
            _enableReport = YES;
            [userDefaults setObject:@(_enableReport) forKey:Key_EnableReport];
        }
        
        NSNumber *obj_rgbaFormat = [userDefaults objectForKey:Key_RgbaFormat];
        if (obj_rgbaFormat != nil) {
            _rgbaFormat = [obj_rgbaFormat boolValue];
        } else {
            _rgbaFormat = YES;
            [userDefaults setObject:@(_rgbaFormat) forKey:Key_RgbaFormat];
        }
        
        double zInterspaceValue;
        NSNumber *obj_zInterspace = [userDefaults objectForKey:Key_ZInterspace];
        if (ob