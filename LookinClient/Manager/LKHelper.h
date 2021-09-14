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
#define NSColorWhite LookinColorMake(250, 251, 252)
#define NSColorGray0 LookinColorMake(33, 40, 50)
#define NSColorGray1 LookinColorMake(53, 60, 70)
#define NSColorGray9 LookinColorMake(216, 220, 228)

extern const CGFloat HierarchyMinWidth;

extern const CGFloat MeasureViewWidth;

extern const CGFloat DashboardViewWidth;
extern const CGFloat DashboardAttrItemHorInterspace;
extern const CGFloat DashboardAttrItemVerInterspace;
extern const CGFloat DashboardHorInset;
extern const CGFloat DashboardCardControlCornerRadius;
extern const CGFloat DashboardSectionMarginTop;
extern const CGFloat DashboardCardCornerRadius;
extern const CGFloat DashboardSearchCardInset;

extern const CGFloat ConsoleInsetLeft;
extern const CGFloat ConsoleInsetRight;

extern const CGFloat ZoomSliderMaxValue;

typedef struct {
    CGFloat left, right;
} HorizontalMargins;

CG_INLINE HorizontalMargins HorizontalMarginsMake(CGFloat left, CGFloat right) {
    HorizontalMargins margins = {left, right};
    return margins;
}

#define AlertError(targetError, targetWindow) if (targetError.code != LookinErrCode_Discard) {[[NSAlert alertWithError:targetErro