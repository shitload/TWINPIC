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
static NSString * const Key_ReceivingConfigTime_Color = @"ConfigTime_Colo