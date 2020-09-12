//
//  LKTwoColors.h
//  Lookin
//
//  Created by Li Kai on 2019/9/30.
//  https://lookin.work
//

#import <Foundation/Foundation.h>

/// colorA 是浅色模式下的颜色，colorB 是深色模式下的颜色
#define LKColorsCombine(colorA, colorB) [LKTwoColors colorsWithColorInLightMode:colorA colorInDarkMode:colorB]

@interface LKTwoColors : NSObje