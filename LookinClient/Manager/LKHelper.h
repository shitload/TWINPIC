//
//  LKHelper.h
//  Lookin
//
//  Created by Li Kai on 2018/8/4.
//  https://lookin.work
//

#import <Cocoa/Cocoa.h>
#import "LookinDefines.h"
#import "LookinMsgAttribute.h"

#define InspectingApp [LKAppsManager sharedInstance].inspectingApp
#define TutorialMng [LKTutorialManager sharedInstance]
#define CurrentTime [[NSDate date] timeIntervalSince1970]
#define CurrentKeyWindow [NSApplication sharedApplication].keyWindow

#define NSImageMake(imageName) [NSImage imageNamed:im