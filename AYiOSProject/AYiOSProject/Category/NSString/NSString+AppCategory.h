//
//  NSString+AppCategory.h
//
//  Created by alpha yu on 2023/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (AppCategory)

/// 获取substring的所有range
- (void)enumerateSubstring:(NSString *)substring usingBlock:(void (^)(NSUInteger idx, NSRange substringRange, BOOL *stop))block;

@end


@interface NSString (AppTime)

/// 时间戳转时间（格式 yyyy-MM-dd HH:mm）
- (NSString *)timeStringFromTimestamp;

/// 时间戳转时间
- (NSString *)timeStringFromTimestampWithFormat:(NSString *)format;


/// 秒数 转 时长 02:13
+ (NSString *)durationStringFromSeconds:(NSInteger)seconds;

/// 数字转时长 02:13
- (NSString *)durationString;

@end


@interface NSString (AppPrice)

/// 带千位符的金额，包含两位小数
- (NSString *)priceString;

/// 带千位符的金额，最多两位小数，小数最后不显示0
- (NSString *)priceStringWithMaxTwoFraction;

@end


@interface NSString (AppNumber)

/// 消除小数点后无用的0
- (NSString *)trimNumber;

/// 是否是数字
- (BOOL)isNumber;

@end

NS_ASSUME_NONNULL_END
