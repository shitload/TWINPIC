
//
//  LKReadWindowController.m
//  Lookin
//
//  Created by Li Kai on 2019/5/12.
//  https://lookin.work
//

#import "LKReadWindowController.h"
#import "LKReadViewController.h"
#import "LKWindowToolbarHelper.h"
#import "LookinHierarchyFile.h"
#import "LKPreferenceManager.h"
#import "LKReadHierarchyDataSource.h"
#import "LookinHierarchyInfo.h"
#import "LKWindow.h"
#import "LKMenuPopoverSettingController.h"
#import "LKTutorialManager.h"
#import "LookinPreviewView.h"
#import "LKHierarchyView.h"

@interface LKReadWindowController () <NSToolbarDelegate>

@property(nonatomic, strong) LKReadViewController *viewController;

@property(nonatomic, strong) NSMutableDictionary<NSString *, NSToolbarItem *> *toolbarItemsMap;

@property(nonatomic, strong) LKPreferenceManager *preferenceManager;

@end

@implementation LKReadWindowController

- (instancetype)initWithFile:(LookinHierarchyFile *)file {
    NSSize screenSize = [NSScreen mainScreen].frame.size;
    LKWindow *window = [[LKWindow alloc] initWithContentRect:NSMakeRect(0, 0, screenSize.width * .7, screenSize.height * .7) styleMask:NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable|NSWindowStyleMaskResizable|NSWindowStyleMaskFullSizeContentView backing:NSBackingStoreBuffered defer:YES];
    window.tabbingMode = NSWindowTabbingModeDisallowed;
    if (@available(macOS 11.0, *)) {
        window.toolbarStyle = NSWindowToolbarStyleUnified;
    }
    window.minSize = NSMakeSize(800, 500);
    [window center];
    