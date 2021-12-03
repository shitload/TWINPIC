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
static NSString * const K