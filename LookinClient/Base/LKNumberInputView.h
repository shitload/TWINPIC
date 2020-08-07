//
//  LKNumberInputView.h
//  Lookin
//
//  Created by Li Kai on 2019/2/22.
//  https://lookin.work
//

#import "LKBaseView.h"
#import "LookinAttrType.h"

typedef NS_ENUM(NSUInteger, LKNumberInputViewStyle) {
    LKNumberInputViewStyleHorizontal,    // titleLabel 在输入框内部的右侧
    LKNumberInputViewStyleVertical     // titleLabel 在输入框的下面
};

@class LKTextFieldView;

extern const CGFloat LKNumberInputHorizontalHeight;
extern const CGFloat LKN