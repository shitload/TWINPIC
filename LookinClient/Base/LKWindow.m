//
//  LKWindow.m
//  Lookin
//
//  Created by Li Kai on 2019/5/14.
//  https://lookin.work
//

#import "LKWindow.h"
#import "LKNavigationManager.h"
#import "LKPanelContentView.h"

@implementation LKWindow

+ (instancetype)panelWindowWithWidth:(CGFloat)width height:(CGFloat)height contentView:(LKPanelContentView *)contentView {
    LKWindow *window = [[LKWindow alloc] initWithContentRect:NSMakeRect(0, 0, width, height) styleMask:NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:YES];
    window.contentView = contentView;
    return window;
}

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag {
    if (self = [super initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag]) {
         [self registerForDraggedTypes:@[NSPas