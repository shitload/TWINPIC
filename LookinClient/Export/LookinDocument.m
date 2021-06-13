//
//  LookinDocument.m
//  Lookin
//
//  Created by Li Kai on 2019/6/26.
//  https://lookin.work
//

#import "LookinDocument.h"
#import "LookinHierarchyFile.h"
#import "LKReadWindowController.h"
#import "LKNavigationManager.h"

// 点击 menu 里的 “打开文件” 会走到这里的一系列方法
@implementation LookinDocument

- (void)makeWindowControllers {
    LKReadWindowController *wc = [[LKReadWindowController alloc] initWithFile:self.hierarchyFile];
    [self addWindowController:wc];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    if (!self.hierarchyFile) {
        NSAssert(NO, @"");
        if (outError) {
            *outError = LookinErr_Inner;
        }
        return nil;
    }
    
    if ([typeName isEqualToString:@"com.lookin.lookin"]) {
 