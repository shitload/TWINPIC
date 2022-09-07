//
//  LKMenuPopoverAppsListController.m
//  Lookin
//
//  Created by Li Kai on 2018/11/5.
//  https://lookin.work
//

#import "LKMenuPopoverAppsListController.h"
#import "LKAppsManager.h"
#import "LKLaunchAppView.h"
#import "LookinHierarchyInfo.h"
#import "LKStaticHierarchyDataSource.h"

@interface LKMenuPopoverAppsListController ()

@property(nonatomic, strong) NSArray<LKLaunchAppView *> *appViews;

@property(nonatomic, strong) LKLabel *titleLabel;
@property(nonatomic, strong) LKLabel *subtitleLabel;
@prop