//
//  UILabel+AttributedString.h
//
//  Created by linxj on 2022/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (AttributedString)

/// 设置字体
/// @param font 字体
/// @param substring 子字符串
- (void)setFont:(UIFont *)font substring:(NSString *)substring;

/// 设置字体颜色
/// @param color 颜色
/// @param substring 子字符串
- (void)setColor:(UIColor *)color substring:(NSString *)substring;

/// 设置字符间隔
/// @param value 间隔值
- (void)setKern:(CGFloat)value;

/// 设置字符间隔
/// @param value 间隔值
/// @param substring 子字符串
- (void)setKern:(CGFloat)value substring:(NSString *)substring;

/// 添加行间距
/// @param lineSpacing 行间距
- (void)addLineSpacing:(CGFloat)lineSpacing;

/// 添加删除线
- (void)addStrikethrough;

/// 移除删除线
- (void)removeStrikethrough;

/// 设置删除线
/// @param style 删除线样式
- (void)setStrikethroughStyle:(NSUnderlineStyle)style;

/// 设置删除线
/// @param style 删除线样式
/// @param substring 子字符串
- (void)setStrikethroughStyle:(NSUnderlineStyle)style substring:(NSString *)substring;

/// 设置删除线颜色
/// @param color 删除线颜色
- (void)setStrikethroughColor:(UIColor *)color;

/// 设置删除线颜色
/// @param color 删除线颜色
/// @param substring 子字符串
- (void)setStrikethroughColor:(UIColor *)color substring:(NSString *)substring;

/// 添加下划线
- (void)addUnderline;

/// 移除下划线
- (void)removeUnderline;

/// 设置下划线
/// @param style 下划线样式
- (void)setUnderlineStyle:(NSUnderlineStyle)style;

/// 设置下划线
/// @param style 下划线样式
/// @param substring 子字符串
- (void)setUnderlineStyle:(NSUnderlineStyle)style substring:(NSString *)substring;

/// 设置下划线颜色
/// @param color 下划线颜色
- (void)setUnderlineColor:(UIColor *)color;

/// 设置删除线颜色
/// @param color 下划线颜色
/// @param substring 子字符串
- (void)setUnderlineColor:(UIColor *)color substring:(NSString *)substring;

@end

NS_ASSUME_NONNULL_END
