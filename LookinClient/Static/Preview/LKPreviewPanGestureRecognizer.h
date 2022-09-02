//
//  LKPreviewPanGestureRecognizer.h
//  Lookin
//
//  Created by Li Kai on 2018/8/31.
//  https://lookin.work
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, PreviewPanGesturePurpose) {
    PreviewPanGesturePurposeRotate,
    PreviewPanGesturePurposeTranslate
};

@interface LKPreviewPanGestureRecognizer : NSPanGestureRecognizer

/**
 默认为 PreviewPanGes