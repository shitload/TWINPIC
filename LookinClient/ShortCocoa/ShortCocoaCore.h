//
//  ShortCocoaCore.h
//  ShortCocoa
//
//  Copyright © 2018年 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 通过 $(...) 将任何对象包装为 ShortCocoa 对象，进而使用链式语法
 */
@interface ShortCocoa : NSObject {
    @protected
    id _get;
}

/**
 将一个或多个对象包装为一个 ShortCocoa 对象
 
 @warning 传入的 count 值必须和传入的 object 的参数数量保持一致，否则会导致 Crash
 @note 不推荐使用这个繁琐的语法，请使用 $(...) 这个宏
 
 @param count 在 object 里传入的参数数量
 @param obj