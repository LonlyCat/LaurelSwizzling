//
//  LaurelRuntime.h
//  LaurelSwizzling
//
//  Created by Sen on 2023/7/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef IMP _Nonnull (^IMPProvider)(void);
typedef id _Nonnull (^ImplementationBloc)(__unsafe_unretained Class cls, SEL originCMD, IMPProvider originalIMPProvider);


NS_SWIFT_NAME(Swizzling)
@interface LaurelSwizzling : NSObject

#pragma mark - Exchange Method

/// Exchange class method
/// - Parameters:
///   - originalSelector: `cls` original method
///   - swizzledSelector: the method to exchange `originalSelector`
///   - cls: witch class to exchange `originalSelector`
+ (BOOL)exchangeInstanceMethod:(SEL)originalSelector
                    withMethod:(SEL)swizzledSelector
                      forClass:(Class)cls NS_SWIFT_NAME(exchange(instanceMethod:withMethod:for:));

/// Exchange class method
/// - Parameters:
///   - originalSelector: `cls` original method
///   - swizzledSelector: the method to exchange `originalSelector`
///   - cls: witch class to exchange `originalSelector`
///   - targetCls: witch class to exchange `swizzledSelector`, when null will use `cls`
+ (BOOL)exchangeInstanceMethod:(SEL)originalSelector
                    withMethod:(SEL)swizzledSelector
                      forClass:(Class)cls
                   targetClass:(Class)targetCls NS_SWIFT_NAME(exchange(instanceMethod:withMethod:for:target:));

- (BOOL)exchangeInstanceMethod:(SEL)originalSelector
                    withMethod:(SEL)swizzledSelector
                      forClass:(Class)cls NS_SWIFT_NAME(exchange(instanceMethod:withMethod:for:));

- (BOOL)exchangeInstanceMethod:(SEL)originalSelector
                    withMethod:(SEL)swizzledSelector
                      forClass:(Class)cls
                   targetClass:(Class)targetCls NS_SWIFT_NAME(exchange(instanceMethod:withMethod:for:target:));

#pragma mark - Override Method

/// Determines whether the method of the superclass is overridden
/// - Parameters:
///   - targetMethod: judge method
///   - targetClass: witch class to judge `targetMethod`
+ (BOOL)hasOverrideSuperMethod:(SEL)targetMethod
                   targetClass:(Class)targetClass NS_SWIFT_NAME(hasOverrideSuper(method:for:));


+ (BOOL)overrideImplementation:(ImplementationBloc)impBlock
                    withMethod:(SEL)targetSelector
                      forClass:(Class)cls NS_SWIFT_NAME(overrideImplementation(impBlock:withMethod:for:));

- (BOOL)overrideImplementation:(ImplementationBloc)impBlock
                    withMethod:(SEL)targetSelector
                      forClass:(Class)cls NS_SWIFT_NAME(overrideImplementation(impBlock:withMethod:for:));

#pragma mark - Extend Method
+ (BOOL)extendVoidImplementation:(void(^)(__kindof NSObject *))impBlock
                      withMethod:(SEL)targetSelector
                        forClass:(Class)targetClass;

@end

NS_ASSUME_NONNULL_END
