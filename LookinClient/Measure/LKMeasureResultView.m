//
//  LKMeasureResultView.m
//  Lookin
//
//  Created by Li Kai on 2019/10/21.
//  https://lookin.work
//

#import "LKMeasureResultView.h"
#import "LKNavigationManager.h"
#import "LKTextFieldView.h"
#import "LKMeasureResultLineData.h"

#define compare(A, B) [self _compare:A with:B]
#define addHor(arg_array, arg_startX, arg_endX, arg_y, arg_value) [arg_array addObject:[LKMeasureResultHorLineData dataWithStartX:arg_startX endX:arg_endX y:arg_y value:arg_value]]
#define addVer(arg_array, arg_startY, arg_endY, arg_x, arg_value) [arg_array addObject:[LKMeasureResultVerLineData dataWithStartY:arg_startY endY:arg_endY x:arg_x value:arg_value]]

typedef NS_ENUM(NSInteger, CompareResult) {
    Bigger,
    Same,
    Smaller
};

@interface LKMeasureResultView ()

/// mainLayer 指 selectedLayer，referLayer 指 hovered layer
@property(nonatomic, strong) LKBaseView *contentView;

@property(nonatomic, strong) NSImageView *mainImageView;
@property(nonatomic, strong) NSImageView *referImageView;

/// 如果直接把 solidLinesLayer 作为 contentView.layer 的 sublayer 则经常出现 linesLayer 被 imageView.layer 盖住的情况，貌似 imageView.layer 是懒加载的且时机不