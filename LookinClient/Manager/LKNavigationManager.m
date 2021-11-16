//
//  LKNavigationManager.m
//  Lookin
//
//  Created by Li Kai on 2018/11/3.
//  https://lookin.work
//

#import "LKNavigationManager.h"
#import "LKLaunchWindowController.h"
#import "LKStaticWindowController.h"
#import "LKPreferenceWindowController.h"
#import "LKStaticViewController.h"
#import "LKPreviewController.h"
#import "LKPreviewController.h"
#import "LKAppsManager.h"
#import "LookinHierarchyFile.h"
#import "LKReadWindowController.h"
#import "LKMethodTraceWindowController.h"
#import "LKConsoleViewController.h"
#import "LKPreferenceManager.h"
#import "LKAboutWindowController.h"
@import AppCenter;
@import AppCenterAnalytics;

@interface LKNavigationManager ()

@property(nonatomic, strong) LKPreferenceWindowController *preferenceWindowController;
@property(nonatomic, strong) LKAboutWindowController *aboutWindowController;

@end

@implementation LKNavigationManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKNavigationManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)showLaunch {
    _launchWindowController = [[LKLaunchWindowController alloc] init];
    [self.launchWindowController showWindow:self];
}

- (void)showStaticWorkspace {
    if (!self.staticWindowController) {
        _staticWindowController = [[LKStaticWindowController alloc] init];
        self.staticWindowController.window.delegate = self;
    }
    [self.staticWindowController showWindow:self];
}

- (void)closeLaunch {
    [self.launchWindowController close];
    _launchWindowController = nil;
}

- (void)showPreference {
    if (!self.preferenceWindowController) {
        self.preferenceWindowController = [LKPreferenceWindowController new];
        self.preferenceWindowController.window.delegate = self;
    }
    [self.preferenceWindowController showWindow:self];
}

- (void)showAbout {
    if (!self.aboutWindowController) {
        _aboutWindowController = [[LKAboutWindowController alloc] init];
        self.aboutWindowController.window.delegate = self;
    }
    [self.aboutWindowController showWindow:self];
}

- (void)showMethodTrace {
    if (!self.methodTraceWindowController) {
        if (![LKAppsManager sharedInstance].inspectingApp) {
            NSWindow *window = self.staticWindowController.window;
            AlertErrorText(NSLocalizedString(@"Can not use Method Trace at this time.", nil), NSLocalizedString(@"Lost connection with the iOS app.", nil), window);
            return;
        }
        
        _methodTraceWindowController = [LKMethodTraceWindowController new];
        self.methodTraceWindowController.window.delegate = self;
    }
    [self.methodTraceWindowController showWindow:self];
    
    [MSACAnalytics trackEvent:@"Launch MethodTrace"];
}

- (LKWindowController *)currentKeyWindowController {
    NSWindow *keyWindow = [NSApplication sharedApplication].keyWindow;
    if ([keyWindow.windowController isKindOfClass:[LKWindowController class]]) {
        return keyWindow.windowController;
    }
    return nil;
}

- (BOOL)showReaderWithFilePath:(NSString *)filePath error:(NSError **)error {
    NSData *data = [NSData dataWithContentsOfFile:filePath options:0 error:error];
    if (!data) {
        return NO;
    }
    
    id dataObj = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error