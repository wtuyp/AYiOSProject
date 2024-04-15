//
//  UITextField+ZGExtand.m
//  TextFieldExtand
//
//  Created by Cheney on 2018/5/10.
//  Copyright © 2018年 MMM. All rights reserved.
//

#import "UITextField+ZGExtand.h"
#import <objc/runtime.h>

#define kZgTextFieldCharacterNumber     @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kZgTextFieldChineseInputs       @"➋➌➍➎➏➐➑➒"

typedef NS_ENUM(NSInteger, ZGTextFieldStringType) {
    ZGTextFieldStringTypeNumber,    ///< 数字
    ZGTextFieldStringTypeLetter,    ///< 字母
    ZGTextFieldStringTypeCode128,   ///< 条形码 code128 ASCII 0 - 128 八进制 0 - 177
    ZGTextFieldStringTypeChinese,   ///< 汉字
};

@implementation NSString (ZGExtand)

/**
 是否是特殊符号,除数字、字母、汉字以外的
 @return 真假
 */
- (BOOL)zg_isSpecialLetter {
    if ([self zg_matchRegularWithType:ZGTextFieldStringTypeNumber] 
        || [self zg_matchRegularWithType:ZGTextFieldStringTypeLetter]
        || [self zg_matchRegularWithType:ZGTextFieldStringTypeChinese]) {
        return NO;
    }
    return YES;
}

/**
 用正则判断字符
 @param type 类型
 @return 是否对应
 */
- (BOOL)zg_matchRegularWithType:(ZGTextFieldStringType)type {
    NSString *regular = @"";
    switch (type) {
        case ZGTextFieldStringTypeNumber:
            regular = @"^[0-9]*$";
            break;
        case ZGTextFieldStringTypeLetter:
            regular = @"^[A-Za-z]+$";
            break;
        case ZGTextFieldStringTypeCode128:
            regular = @"^[\0-\177]{0,}$";
            break;
        case ZGTextFieldStringTypeChinese:
            regular = @"^[\u4e00-\u9fa5]{0,}$";
            break;
        default:
            break;
    }
    
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    return [regex evaluateWithObject:self];
}

/**
 字符个数
 */
- (NSUInteger)zg_lengthWithCh2En1 {
    int strLength = 0;
    char *p = (char *) [self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strLength++;
        } else {
            p++;
        }
    }
    return strLength;
}

/**
 移除字符串中除exceptLetters外的所有特殊字符
 */
- (NSString *)zg_removeSpecialLettersExceptLetters:(NSArray<NSString *> *)exceptLetters {
    if (self.length > 0) {
        NSMutableString *resultStr = [[NSMutableString alloc] init];
        for (int i = 0; i < self.length; i++) {
            NSString *indexStr = [self substringWithRange:NSMakeRange(i, 1)];
            if (![indexStr zg_isSpecialLetter] || (exceptLetters && [exceptLetters containsObject:indexStr])) {
                [resultStr appendString:indexStr];
            }
        }
        if (resultStr.length > 0) {
            return resultStr;
        }
    }
    
    return @"";
}

@end

/// 代理转发
@interface ZGTextFieldProxy : NSProxy <UITextFieldDelegate>

@property (nonatomic, weak, nullable) id target;

- (instancetype)initWithTarget:(id)target;

@end

@implementation ZGTextFieldProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

- (id)forwardingTargetForSelector:(SEL)selector {
    if (sel_isEqual(selector, @selector(textFieldShouldBeginEditing:))
        || sel_isEqual(selector, @selector(textFieldDidBeginEditing:))
        || sel_isEqual(selector, @selector(textFieldShouldEndEditing:))
        || sel_isEqual(selector, @selector(textFieldDidEndEditing:))
        || sel_isEqual(selector, @selector(textFieldDidEndEditing:reason:))
        || sel_isEqual(selector, @selector(textField:shouldChangeCharactersInRange:replacementString:))
        || sel_isEqual(selector, @selector(textFieldShouldClear:))
        || sel_isEqual(selector, @selector(textFieldShouldReturn:))) {
        return self;
    }
    
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self forwardingTargetForSelector:aSelector] == self) {
        return YES;
    }
    
    return [_target respondsToSelector:aSelector];
}

- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}

- (NSUInteger)hash {
    return [_target hash];
}

- (Class)superclass {
    return [_target superclass];
}

- (Class)class {
    return [_target class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isProxy {
    return YES;
}

- (NSString *)description {
    return [_target description];
}

- (NSString *)debugDescription {
    return [_target debugDescription];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL result = YES;
    if ([self.target respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        result = [self.target textFieldShouldBeginEditing:textField];
    }
    
    return result;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.target respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.target textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    BOOL result = YES;
    
    if ([self.target respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        result = [self.target textFieldShouldEndEditing:textField];
    }
    return result;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.target respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.target textFieldDidEndEditing:textField];
    }
}

//- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
//    if ([self.target respondsToSelector:@selector(textFieldDidEndEditing:reason:)]) {
//        [self.target textFieldDidEndEditing:textField reason:reason];
//    }
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL result = YES;
    
    if ([self.target respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        result = [self.target textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    if (result) {
        if ([textField.zg_filterArray containsObject:string]) {
            return result;
        }
        
        //数字
        if (textField.zg_isNumber) {
            result = [string zg_matchRegularWithType:ZGTextFieldStringTypeNumber];
            if (!result) return result;
        }
        
        //code128
        if (textField.zg_isCode128) {
            result = [string zg_matchRegularWithType:ZGTextFieldStringTypeCode128];
            if (!result) return result;
        }
        
        //价格
        if (textField.zg_isPrice) {
            result = [self limitPriceWithTextField:textField shouldChangeCharactersInRange:range replacementString:string];
            if (!result) return result;
        }
        
        //密码
        if (textField.zg_isPassword) {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kZgTextFieldCharacterNumber] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            result = [string isEqualToString:filtered];
            if (!result) return result;
        }
        
        // 身份证号
        if (textField.zg_isIdNumber) {
            result = [self handleIdNumberWithTextField:textField shouldChangeCharactersInRange:range replacementString:string];
            if (!result) return result;
        }
        
        // 如果是中文输入法正在输入拼音的过程中（markedTextRange 不为 nil），是不应该限制字数的（例如输入“huang”这5个字符，其实只是为了输入“黄”这一个字符），所以在 shouldChange 这里不会限制，而是放在 didChange 那里限制。
        BOOL isDeleting = range.length > 0 && string.length <= 0;
        if (isDeleting || textField.markedTextRange) return result;
        
        if (textField.zg_isNoSpecialChar) {
            if ([kZgTextFieldChineseInputs rangeOfString:string].location == NSNotFound) {
                for (int i = 0; i < string.length; i++) {
                    NSString *indexStr = [string substringWithRange:NSMakeRange(i, 1)];
                    if ([indexStr zg_isSpecialLetter]) {
                        return NO;
                    }
                }
            }
        }
        
        NSUInteger maxLength = textField.zg_maxLength;
        if (maxLength < NSUIntegerMax) {
            NSString *text = textField.text;
            NSUInteger oldLength = text.length;
            NSUInteger newLength = oldLength - range.length + string.length;
            if (newLength >= maxLength) {
                if (oldLength == maxLength) {
                    //防止最大长度下还继续输入
                    return NO;
                }
                
                NSString *textNew = [text stringByReplacingCharactersInRange:range withString:string];
                if (![textNew isEqualToString:text]) {
                    textField.text = [textNew substringToIndex:maxLength];
                    [textField sendActionsForControlEvents:UIControlEventEditingChanged];
                    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:textField];
                }
                return NO;
            }
        }
    }
    
    return result;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    BOOL result = YES;
    if ([self.target respondsToSelector:@selector(textFieldShouldClear:)]) {
        result = [self.target textFieldShouldClear:textField];
    }
    return result;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL result = YES;
    if ([self.target respondsToSelector:@selector(textFieldShouldReturn:)]) {
        result = [self.target textFieldShouldReturn:textField];
    }
    return result;
}

/**
 价格处理
 */
- (BOOL)limitPriceWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //参考：http://www.cnblogs.com/fcug/p/5500349.html
    
    NSUInteger length = [string length];
    if (length == 0) return YES;
    if (length > 1) return NO;
    
    //当前输入的字符
    unichar single = [string characterAtIndex:0];
    //数据格式正确
    if ((single >= '0' && single <= '9') || single == '.') {
        NSString *text = textField.text;
        
        //首字母为小数点
        if ([text length] == 0) {
            if (single == '.') {
                //此处强制让textField.text = 0,然后又return YES,这样第一个字符输入.，显示的就是0.
                textField.text = @"0";
                return YES;
//                //首字母不能为小数点
//                [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                return NO;
            }
        }
        
        if ([text isEqualToString:@"0"]) {
            if (single != '.') {
                textField.text = @"";
                return YES;
            }
        }
        
        BOOL isHaveDian = [text rangeOfString:@"."].location != NSNotFound;
        
        if (single == '.') {    //text中还没有小数点
            return !isHaveDian;
        }
        
        if (isHaveDian) {   //存在小数点
            //限制整数位长度
            if (text.length >= textField.zg_priceIntLength + textField.zg_priceDecimalIntLength + 1) {
                return NO;
            }
            //判断小数点的位数
            NSRange ran = [textField.text rangeOfString:@"."];
            if(range.location > ran.location ){
                NSInteger tt = textField.text.length - ran.location;
                return tt <= textField.zg_priceDecimalIntLength ;
            }else{
                return YES;
            }
        }
        
        //限制整数位长度
        if (text.length >= textField.zg_priceIntLength) {
            return NO;
        }
        return YES;
    }
    
    //输入的数据格式不正确
    return NO;
}

/**
 身份证号处理
 */
- (BOOL)handleIdNumberWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger length = [string length];
    if (length == 0) return YES;
    if (length > 1) return NO;
    
    NSString *text = textField.text;
    
    //限制整数位长度
    if (text.length >= 18) {
        return NO;
    }
    
    //当前输入的字符
    unichar single = [string characterAtIndex:0];
    if (single >= '0' && single <= '9') {
        return YES;
    } else if ((single == 'x' || single == 'X') && text.length == 17) {
        return YES;
    }
    
    return NO;
}

@end

@implementation UITextField (ZGExtand)

/**
 HOOK函数
 @param originalSel 原函数
 @param newSel 新函数
 @return 是否成功
 */
+ (BOOL)zg_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

/**
 加载
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zg_swizzleInstanceMethod:@selector(initWithFrame:) with:@selector(zg_initWithFrame:)];
        [self zg_swizzleInstanceMethod:@selector(initWithCoder:) with:@selector(zg_initWithCoder:)];
        [self zg_swizzleInstanceMethod:@selector(setDelegate:) with:@selector(zg_setDelegate:)];
        [self zg_swizzleInstanceMethod:@selector(layoutSubviews) with:@selector(zg_layoutSubviews)];
        [self zg_swizzleInstanceMethod:@selector(setText:) with:@selector(zg_setText:)];
    });
}

/**
 代码初始化的时候
 @return 对象
 */
- (instancetype)zg_initWithFrame:(CGRect)frame {
    id obj = [self zg_initWithFrame:frame];
    if (obj != nil) {
        [self zg_initValues];
    }
    return obj;
}

/**
 当从XIB初始化的时候
 @return 对象
 */
- (instancetype)zg_initWithCoder:(NSCoder *)coder {
    id obj = [self zg_initWithCoder:coder];
    if (obj != nil) {
        [self zg_initValues];
    }
    return obj;
}

/**
 初始化数据
 */
- (void)zg_initValues {
    [self addTarget:self action:@selector(zg_handleTextChangeEvent:) forControlEvents:UIControlEventEditingChanged];
    [self setZg_proxy:[[ZGTextFieldProxy alloc] initWithTarget:nil]];
    [self setDelegate:self.zg_proxy];
    self.zg_maxLength = NSUIntegerMax;
    self.zg_priceIntLength = 5;
    self.zg_priceDecimalIntLength = 2;
}

/**
 HOOK子控件布局
 */
-(void)zg_layoutSubviews{
    [self zg_layoutSubviews];
    if (self.borderStyle == UITextBorderStyleNone && self.clipsToBounds == NO) {
//        self.clipsToBounds = YES;
        
        CGRect maskFrame = self.layer.mask.bounds;
        CAShapeLayer *mask = (CAShapeLayer *)self.layer.mask;
        if (!mask) {
            mask = [CAShapeLayer layer];
            self.layer.mask = mask;
        }
        
        if (!CGRectEqualToRect(maskFrame, self.bounds)) {
            maskFrame = self.bounds;
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:maskFrame];
            mask.frame = maskFrame;
            mask.path = maskPath.CGPath;
        }
    }
}

/**
 HOOK setText 如果是 price 类型，过滤成两位小数
 */
- (void)zg_setText:(NSString *)text{
//    if(self.zg_isPrice){
//        double price = [text doubleValue];
//        if (fmodf(price * 10, 1) != 0) {//如果有两位小数点
//            price = (double)(int)(100 * price)/100;
//            text = [NSString stringWithFormat:@"%.2f",price];
//        }
//    }
    [self zg_setText:text];
}

/**
 HOOK代理
 @param delegate 代理
 */
- (void)zg_setDelegate:(id <UITextFieldDelegate>)delegate {
    if(self.zg_proxy != delegate) {
        self.zg_proxy.target = delegate;
    }
    [self zg_setDelegate:self.zg_proxy];
}

/**
 输入内容改变事件
 @param textField 输入框
 */
- (void)zg_handleTextChangeEvent:(UITextField *)textField {
    NSUInteger maxLength = self.zg_maxLength;
    
    //排除高亮状态
    if (!textField.markedTextRange) {
        NSString *text = textField.text;
        
        //特殊字符过滤
        BOOL isUpdate = NO;
        if (textField.zg_isNoSpecialChar) {
            NSString *newText = [text zg_removeSpecialLettersExceptLetters:self.zg_filterArray];
            if(![newText isEqualToString:text]) {
                text = newText;
                isUpdate = YES;
            }
        }
        
        if (text.length > maxLength) {
            text = [text substringToIndex:maxLength];
            isUpdate = YES;
        }
        
        if (isUpdate) textField.text = text;
    }
}

#pragma mark - 输入长度限制

- (NSUInteger)zg_maxLength {
    NSNumber *num = objc_getAssociatedObject(self, _cmd);
    return num.unsignedIntegerValue;
}

- (void)setZg_maxLength:(NSUInteger)zg_maxLength {
    objc_setAssociatedObject(self, @selector(zg_maxLength), @(zg_maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 数字

- (BOOL)zg_isNumber {
    NSNumber *num = objc_getAssociatedObject(self, _cmd);
    return num.unsignedIntegerValue;
}

- (void)setZg_isNumber:(BOOL)zg_isNumber {
    objc_setAssociatedObject(self, @selector(zg_isNumber), @(zg_isNumber), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 价格

- (BOOL)zg_isPrice {
    NSNumber *num = objc_getAssociatedObject(self, _cmd);
    return num.boolValue;
}

- (void)setZg_isPrice:(BOOL)zg_isPrice {
    objc_setAssociatedObject(self, @selector(zg_isPrice), @(zg_isPrice), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)zg_priceIntLength {
    NSNumber *num = objc_getAssociatedObject(self, _cmd);
    return num.unsignedIntegerValue;
}

- (void)setZg_priceIntLength:(NSUInteger)zg_priceIntLength {
    objc_setAssociatedObject(self, @selector(zg_priceIntLength), @(zg_priceIntLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)zg_priceDecimalIntLength {
    NSNumber *num = objc_getAssociatedObject(self, _cmd);
    return num.unsignedIntegerValue;
}

- (void)setZg_priceDecimalIntLength:(NSUInteger)zg_priceDecimalIntLength {
    objc_setAssociatedObject(self, @selector(zg_priceDecimalIntLength), @(zg_priceDecimalIntLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 密码

- (BOOL)zg_isPassword {
    NSNumber *num = objc_getAssociatedObject(self, _cmd);
    return num.boolValue;
}

- (void)setZg_isPassword:(BOOL)zg_isPassword {
    objc_setAssociatedObject(self, @selector(zg_isPassword), @(zg_isPassword), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 手机号

- (BOOL)zg_isPhoneNumber {
    NSNumber *num = objc_getAssociatedObject(self, _cmd);
    return num.boolValue;
}

- (void)setZg_isPhoneNumber:(BOOL)zg_isPhoneNumber {
    objc_setAssociatedObject(self, @selector(zg_isPhoneNumber), @(zg_isPhoneNumber), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 无特殊符号

- (BOOL)zg_isNoSpecialChar {
    NSNumber *num = objc_getAssociatedObject(self, _cmd);
    return num.boolValue;
}

- (void)setZg_isNoSpecialChar:(BOOL)zg_isNoSpecialChar {
    objc_setAssociatedObject(self, @selector(zg_isNoSpecialChar), @(zg_isNoSpecialChar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Code128

- (BOOL)zg_isCode128 {
    NSNumber *num = objc_getAssociatedObject(self, _cmd);
    return num.boolValue;
}

- (void)setZg_isCode128:(BOOL)zg_isCode128 {
    objc_setAssociatedObject(self, @selector(zg_isCode128), @(zg_isCode128), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 身份证号

- (BOOL)zg_isIdNumber {
    NSNumber *num = objc_getAssociatedObject(self, _cmd);
    return num.boolValue;
}

- (void)setZg_isIdNumber:(BOOL)zg_isIdNumber{
    if (zg_isIdNumber) {
        self.zg_maxLength = 18;
    }
    objc_setAssociatedObject(self, @selector(zg_isIdNumber), @(zg_isIdNumber), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 过滤的字符列表，不进行替换

- (NSArray *)zg_filterArray {
    return (NSArray *)objc_getAssociatedObject(self, _cmd);
}

- (void)setZg_filterArray:(NSArray *)zg_filterArray {
    objc_setAssociatedObject(self, @selector(zg_filterArray), zg_filterArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - 代理转发

- (ZGTextFieldProxy *)zg_proxy {
    return (ZGTextFieldProxy *)objc_getAssociatedObject(self, _cmd);
}

- (void)setZg_proxy:(ZGTextFieldProxy *)zg_proxy {
    objc_setAssociatedObject(self, @selector(zg_proxy), zg_proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
