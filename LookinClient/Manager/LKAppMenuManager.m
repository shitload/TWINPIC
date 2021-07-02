//
//  LKAppMenuManager.m
//  Lookin
//
//  Created by Li Kai on 2019/3/20.
//  https://lookin.work
//

#import "LKAppMenuManager.h"
#import "LKNavigationManager.h"
#import "LKLaunchWindowController.h"
#import "LKLaunchViewController.h"
#import "LKPreviewController.h"
#import "LKStaticWindowController.h"
#import "LKStaticViewController.h"
#import "LKPreferenceManager.h"
#import "LKStaticHierarchyDataSource.h"
#import "LKWindowController.h"
#include <mach-o/dyld.h>
#import <Sparkle/Sparkle.h>
@import AppCenter;
@import AppCenterAnalytics;

static NSUInteger const kTag_About = 11;
static NSUInteger const kTag_Preferences = 12;
static NSUInteger const kTag_CheckUpdates = 13;

static NSUInteger const kTag_Reload = 21;
static N