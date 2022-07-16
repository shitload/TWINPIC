//
//  ShortCocoa+Private.h
//  ShortCocoa
//
//  Copyright © 2018年 hughkli. All rights reserved.
//

#import "ShortCocoaCore.h"
#import "ShortCocoaDefines.h"
#import "TargetConditionals.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Appkit/Appkit.h>
#endif

#define ShortCocoaEqualClass(object, CLASS) [object isKindOfClass:[CLASS class]]

NS_ASSUME_NONNULL_BEGIN

@interface ShortCocoa (Private)

/**
 遍历 self.get，并将其中类型为 classA 的对象传入 handlerA 中
 */
- (void)unpack:(Class)classA do:(void (^)(id obj, BOOL *stop))handlerA;

/**
 遍历 self.get，并将其中类型为 classA 的对象传入 handlerA 中，将类型为 classB 的对象传入 handlerB 中
 */
- (void)unpackClassA:(Class)classA doA:(void (^)(id obj, BOOL *stop))handlerA classB:(nullable Class)classB doB:(nullable void (^)(id obj, BOOL *stop))handlerB;

/// 辅助进行字符串相关的处理
@property(nonatomic, strong) NSMutableAttributedString *cachedAttrString;

@end

@interface ShortCocoaHelper : NSObject

