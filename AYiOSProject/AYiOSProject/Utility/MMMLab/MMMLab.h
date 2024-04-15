//
//  MMMLab.h
//  MMMKit
//
//  Created by MoLice on 2019/7/8.
//

#ifndef MMMLab_h
#define MMMLab_h

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "YYWeakProxy.h"

/**
 以下系列宏用于在 Category 里添加 property 时，可以在 @implementation 里一句代码完成 getter/setter 的声明。
 暂不支持在 getter/setter 里添加自定义的逻辑，需要自定义的情况请继续使用 Code Snippet 生成的代码。
 使用方式：
 @code
 @interface NSObject (CategoryName)
 @property(nonatomic, strong) type *strongObj;
 @property(nonatomic, weak) type *weakObj;
 @property(nonatomic, assign) CGRect rectValue;
 @end

 @implementation NSObject (CategoryName)

 // 注意 setter 不需要带冒号
 MMMSynthesizeIdStrongProperty(strongObj, setStrongObj)
 MMMSynthesizeIdWeakProperty(weakObj, setWeakObj)
 MMMSynthesizeCGRectProperty(rectValue, setRectValue)

 @end
 @endcode
 */

#pragma mark - Meta Marcos

#define _MMMSynthesizeId(_getterName, _setterName, _policy) \
_Pragma("clang diagnostic push") _Pragma(MMMClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(MMMClangWarningConcat("-Wmismatched-return-types"))\
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(id)_getterName {\
    objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, _getterName, OBJC_ASSOCIATION_##_policy##_NONATOMIC);\
}\
\
- (id)_getterName {\
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName);\
}\
_Pragma("clang diagnostic pop")

#define _MMMSynthesizeWeakId(_getterName, _setterName) \
_Pragma("clang diagnostic push") _Pragma(MMMClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(MMMClangWarningConcat("-Wmismatched-return-types"))\
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(id)_getterName {\
    objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, [[YYWeakProxy alloc] initWithTarget:_getterName], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\
\
- (id)_getterName {\
    return ((YYWeakProxy *)objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName)).target;\
}\
_Pragma("clang diagnostic pop")

#define _MMMSynthesizeNonObject(_getterName, _setterName, _type, valueInitializer, valueGetter) \
_Pragma("clang diagnostic push") _Pragma(MMMClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(MMMClangWarningConcat("-Wmismatched-return-types"))\
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(_type)_getterName {\
    objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, [NSNumber valueInitializer:_getterName], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\
\
- (_type)_getterName {\
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName)) valueGetter];\
}\
_Pragma("clang diagnostic pop")

#define _MMMSynthesizeSEL(_getterName, _setterName) \
_Pragma("clang diagnostic push") _Pragma(MMMClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(MMMClangWarningConcat("-Wmismatched-return-types"))\
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(SEL)_getterName {\
    objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, NSStringFromSelector(_getterName), OBJC_ASSOCIATION_COPY_NONATOMIC);\
}\
\
- (SEL)_getterName {\
    NSString *sel = objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName);\
    return NSSelectorFromString(sel);\
}\
_Pragma("clang diagnostic pop")


#pragma mark - Object Marcos

/// @property(nonatomic, strong) id xxx
#define MMMSynthesizeIdStrongProperty(_getterName, _setterName) _MMMSynthesizeId(_getterName, _setterName, RETAIN)

/// @property(nonatomic, weak) id xxx
#define MMMSynthesizeIdWeakProperty(_getterName, _setterName) _MMMSynthesizeWeakId(_getterName, _setterName)

/// @property(nonatomic, copy) id xxx
#define MMMSynthesizeIdCopyProperty(_getterName, _setterName) _MMMSynthesizeId(_getterName, _setterName, COPY)

/// @property(nonatomic, assign) SEL xxx
#define MMMSynthesizeSELProperty(_getterName, _setterName) _MMMSynthesizeSEL(_getterName, _setterName)

#pragma mark - NonObject Marcos

/// @property(nonatomic, assign) Int xxx
#define MMMSynthesizeIntProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, int, numberWithInt, intValue)

/// @property(nonatomic, assign) unsigned int xxx
#define MMMSynthesizeUnsignedIntProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, unsigned int, numberWithUnsignedInt, unsignedIntValue)

/// @property(nonatomic, assign) float xxx
#define MMMSynthesizeFloatProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, float, numberWithFloat, floatValue)

/// @property(nonatomic, assign) double xxx
#define MMMSynthesizeDoubleProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, double, numberWithDouble, doubleValue)

/// @property(nonatomic, assign) BOOL xxx
#define MMMSynthesizeBOOLProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, BOOL, numberWithBool, boolValue)

/// @property(nonatomic, assign) NSInteger xxx
#define MMMSynthesizeNSIntegerProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, NSInteger, numberWithInteger, integerValue)

/// @property(nonatomic, assign) NSUInteger xxx
#define MMMSynthesizeNSUIntegerProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, NSUInteger, numberWithUnsignedInteger, unsignedIntegerValue)

/// @property(nonatomic, assign) CGFloat xxx
#define MMMSynthesizeCGFloatProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, CGFloat, numberWithDouble, doubleValue)

/// @property(nonatomic, assign) CGPoint xxx
#define MMMSynthesizeCGPointProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, CGPoint, valueWithCGPoint, CGPointValue)

/// @property(nonatomic, assign) CGSize xxx
#define MMMSynthesizeCGSizeProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, CGSize, valueWithCGSize, CGSizeValue)

/// @property(nonatomic, assign) CGRect xxx
#define MMMSynthesizeCGRectProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, CGRect, valueWithCGRect, CGRectValue)

/// @property(nonatomic, assign) UIEdgeInsets xxx
#define MMMSynthesizeUIEdgeInsetsProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, UIEdgeInsets, valueWithUIEdgeInsets, UIEdgeInsetsValue)

/// @property(nonatomic, assign) CGVector xxx
#define MMMSynthesizeCGVectorProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, CGVector, valueWithCGVector, CGVectorValue)

/// @property(nonatomic, assign) CGAffineTransform xxx
#define MMMSynthesizeCGAffineTransformProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, CGAffineTransform, valueWithCGAffineTransform, CGAffineTransformValue)

/// @property(nonatomic, assign) NSDirectionalEdgeInsets xxx
#define MMMSynthesizeNSDirectionalEdgeInsetsProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, NSDirectionalEdgeInsets, valueWithDirectionalEdgeInsets, NSDirectionalEdgeInsetsValue)

/// @property(nonatomic, assign) UIOffset xxx
#define MMMSynthesizeUIOffsetProperty(_getterName, _setterName) _MMMSynthesizeNonObject(_getterName, _setterName, UIOffset, valueWithUIOffset, UIOffsetValue)

#pragma mark - Clang

#define MMMArgumentToString(macro) #macro
#define MMMClangWarningConcat(warning_name) MMMArgumentToString(clang diagnostic ignored warning_name)

/// 消除编译器警告，参数可直接传入 clang 的 warning 名，warning 列表参考：https://clang.llvm.org/docs/DiagnosticsReference.html
#define MMMClangWarningIgnoreBegin(warningName) _Pragma("clang diagnostic push") _Pragma(MMMClangWarningConcat(#warningName))
#define MMMClangWarningIgnoreEnd _Pragma("clang diagnostic pop")

/// 消除内存泄露警告
#define MMMClangWarningIgnorePerformSelectorLeaksBegin  MMMClangWarningIgnoreBegin(-Warc-performSelector-leaks)
/// 消除结果未使用警告
#define MMMClangWarningIgnoreNoUnusedResultBegin        MMMClangWarningIgnoreBegin(-Wunused-result)

#endif /* MMMLab_h */
