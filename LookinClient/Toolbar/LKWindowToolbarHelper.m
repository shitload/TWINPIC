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
NSToolbarItemIdentif