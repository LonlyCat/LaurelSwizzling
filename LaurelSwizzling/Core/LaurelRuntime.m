//
//  LaurelRuntime.m
//  LaurelSwizzling
//
//  Created by Sen on 2023/7/10.
//

#import "LaurelRuntime.h"
#import <objc/runtime.h>


@implementation LaurelSwizzling

#pragma mark - Exchange Method

- (BOOL)exchangeInstanceMethod:(SEL)originalSelector
                    withMethod:(SEL)swizzledSelector
                      forClass:(Class)cls {
    return [LaurelSwizzling exchangeInstanceMethod: originalSelector
                                        withMethod: swizzledSelector
                                          forClass: cls
                                       targetClass: cls];
}

- (BOOL)exchangeInstanceMethod:(SEL)originalSelector
                    withMethod:(SEL)swizzledSelector
                      forClass:(Class)cls
                   targetClass:(Class)targetCls {
    return [LaurelSwizzling exchangeInstanceMethod: originalSelector
                                        withMethod: swizzledSelector
                                          forClass: cls
                                       targetClass: targetCls];
}

+ (BOOL)exchangeInstanceMethod:(SEL)originalSelector
                    withMethod:(SEL)swizzledSelector
                      forClass:(Class)cls {
    return [LaurelSwizzling exchangeInstanceMethod: originalSelector
                                        withMethod: swizzledSelector
                                          forClass: cls
                                       targetClass: cls];
}

+ (BOOL)exchangeInstanceMethod:(SEL)originalSelector
                    withMethod:(SEL)swizzledSelector
                      forClass:(Class)cls
                   targetClass:(Class)targetCls {
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(targetCls, swizzledSelector);
    if (!swizzledMethod) {
        return NO;
    }
    
    // If class_addMethod succeeds, it means that there is no Original Selector in the forClass, so replace it with an empty method to avoid using the original Selector after class_replaceMethod. A subsequent invocation of this targetClass method may crash.
    BOOL isAdded = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (isAdded) {
        class_replaceMethod(targetCls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    return YES;
}

#pragma mark - Override Method

+ (BOOL)hasOverrideSuperMethod:(SEL)targetMethod
                   targetClass:(Class)targetClass {
    Method method = class_getInstanceMethod(targetClass, targetMethod);
    if (!method) return NO;
    
    Method methodOfSuper = class_getInstanceMethod(class_getSuperclass(targetClass), targetMethod);
    if (!methodOfSuper) return YES;
    
    return method != methodOfSuper;
}

+ (BOOL)overrideImplementation:(ImplementationBloc)impBlock
                    withMethod:(SEL)targetSelector
                      forClass:(Class)cls {
    Method originalMethod = class_getInstanceMethod(cls, targetSelector);
    IMP imp = method_getImplementation(originalMethod);
    
    BOOL hasOverride = [LaurelSwizzling hasOverrideSuperMethod: targetSelector targetClass: cls];
    
    IMPProvider originalImpProvider = ^IMP(void) {
        IMP result = hasOverride ? imp : class_getMethodImplementation(class_getSuperclass(cls), targetSelector);
        
        if (!result) {
            result = imp_implementationWithBlock(^(id selfObject) {
                NSLog(([NSString stringWithFormat:@"%@", cls]), @"%@ 没有初始实现，%@\n%@", NSStringFromSelector(targetSelector), selfObject, [NSThread callStackSymbols]);
            });
        }
        return result;
    };
    
    if (hasOverride) {
        id block = impBlock(cls, targetSelector, originalImpProvider);
        method_setImplementation(originalMethod, imp_implementationWithBlock(block));
    }
    else {
        class_addMethod(cls, targetSelector, imp_implementationWithBlock(impBlock(cls, targetSelector, originalImpProvider)), method_getTypeEncoding(originalMethod));
    }
    
    return YES;
}

- (BOOL)overrideImplementation:(ImplementationBloc)impBlock
                    withMethod:(SEL)targetSelector
                      forClass:(Class)cls {
    return [LaurelSwizzling overrideImplementation: impBlock
                                        withMethod: targetSelector
                                          forClass: cls];
}

#pragma mark - Extend Method

+ (BOOL)extendVoidImplementation:(void(^)(__kindof NSObject *))impBlock
                      withMethod:(SEL)targetSelector
                        forClass:(Class)targetClass {
    return [LaurelSwizzling overrideImplementation:^id _Nonnull(__unsafe_unretained Class  _Nonnull cls, SEL  _Nonnull originCMD, IMPProvider  _Nonnull originalIMPProvider) {
        void (^block)(__unsafe_unretained __kindof NSObject *selfObject) = ^(__unsafe_unretained __kindof NSObject *selfObject) {
            
            void (*originSelectorIMP)(id, SEL);
            originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
            originSelectorIMP(selfObject, originCMD);
            
            impBlock(selfObject);
        };
#if __has_feature(objc_arc)
        return block;
#else
        return [block copy];
#endif
    } withMethod: targetSelector forClass: targetClass];
}

@end
