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

#define NSImageMake(imageName) [NSImage imageNamed:imageName]
#define NSFontMake(fontSize) [NSFont systemFontOfSize:fontSize]

#define DashboardCardValueColor LookinColorMake(223, 223, 223)
#define DashboardCardControlBackgroundColor LookinColorMake(40, 40, 40)
#define DashboardCardControlBorderColor LookinColorMake(87, 87, 87)

#define SeparatorLightModeColor LookinColorMake(215, 215, 215)
#define SeparatorDarkModeColor LookinColorMake(67, 67, 69)

#define NSSizeMax NSMakeSize(CGFLOAT_MAX, CGFLOAT_MAX)

#define NSColorBlack LookinColorMake(13, 20, 30)
#define NSColorWhite LookinColorMake(2