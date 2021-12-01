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
NSString *const LKWin