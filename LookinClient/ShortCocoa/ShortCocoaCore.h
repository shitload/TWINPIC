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
 @param object 被包装的对象
 */
- (instancetype)initWithObjectsCount:(uint)count objects:(nullable id)object,...;

/**
 获取被 ShortCocoa 包装的原始对象
 
 一种常见的使用场景：
 @code
 self.label = $(UILabel).text(@"Hello").addTo(self.view).get;
 @endcode
 
 各种情况的返回值：
 @code
 
 $(self.label).get; // => self.label
 
 $(label1, nil, label2).get; // => @[label1, label2]
 
 $(UIView).get;     // => [UIView new]，即返回一个 UIView 的实例
 
 @endcode
 
 */
@property(nonatomic, strong, readonly, nullable) id get;

@end

/**
 便利的 ShortCocoa 初始化方法，该参数的第一个传入值 something 可以为对象也可以为 Class，从而实现了 $(UIView) 这种写法
 @note 该方法因为有 ShortCocoa 的前缀命名空间因此更