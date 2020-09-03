//
//  LKTipsView.h
//  Lookin
//
//  Created by Li Kai on 2019/5/8.
//  https://lookin.work
//

#import "LKBaseView.h"
#import "LookinAppInfo.h"

@interface LKTipsView : LKBaseView

@property(nonatomic, weak) id bindingObject;

@property(nonatomic, copy) NSString *title;

/// 请外部不要直接修改 button 的 text 等属性，而是要通过