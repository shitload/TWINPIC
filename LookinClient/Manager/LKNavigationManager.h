//
//  LKNavigationManager.h
//  Lookin
//
//  Created by Li Kai on 2018/11/3.
//  https://lookin.work
//

#import <Foundation/Foundation.h>

@class LKLaunchWindowController, LKStaticWindowController, LKDynamicWindowController, LKWindowController, LKReadWindowController, LKMethodTraceWindowController, LKMethodTraceDataSource, LookinHierarchyInfo, LookinHierarchyFile;

@interface LKNavigationManager : NSObject <NSWindowDelegate>

+ (instancetype)sharedInstance;

- (void)showLaunch;

- (void)closeLaunch;

- (void)showStaticWorkspace;

- (void)showPreference;

- (void)showAbout;

- (void)showMethodTrace;

- (BOOL)showReaderWithFilePath:(NSString *)filePath error:(NSError **)error;
- (void)showReaderWithHierarchyFile:(LookinHierarchyFile *)file title:(NSString *)title;

@property(nonatomic, strong, readonly) LKLaunchWindowController *la