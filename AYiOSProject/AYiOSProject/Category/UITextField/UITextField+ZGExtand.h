//
//  UITextField+ZGExtand.h
//  TextFieldExtand
//
//  Created by Cheney on 2018/5/10.
//  Copyright © 2018年 MMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ZGExtand)

/* 长度，默认NSUIntegerMax */
@property(nonatomic, assign) IBInspectable NSUInteger zg_maxLength;

/* 是否只能输入数字，默认为NO */
@property(nonatomic, assign) IBInspectable BOOL zg_isNumber;

/* 价格(只有一个"."，小数点后保留2位小数), 默认NO */
@property(nonatomic, assign) IBInspectable BOOL zg_isPrice;

/* 价格整数位长度，默认为5 */
@property(nonatomic, assign) IBInspectable NSUInteger zg_priceIntLength;

/* 价格小数位位长度，默认为2 */
@property(nonatomic, assign) IBInspectable NSUInteger zg_priceDecimalIntLength;

/* 是不是密码，字母和数字, 默认 NO */
@property(nonatomic, assign) IBInspectable BOOL zg_isPassword;

/* 是否无特殊字符，汉字、数字、字母，默认 NO */
@property(nonatomic, assign) IBInspectable BOOL zg_isNoSpecialChar;

/* 是否是 code128，默认NO */
@property(nonatomic, assign) IBInspectable BOOL zg_isCode128;

/* 是否是身份证号，默认NO */
@property(nonatomic, assign) IBInspectable BOOL zg_isIdNumber;

/* 过滤字符，某些字符让其输入 */
@property(nonatomic, copy) NSArray<NSString *> *zg_filterArray;

@end
