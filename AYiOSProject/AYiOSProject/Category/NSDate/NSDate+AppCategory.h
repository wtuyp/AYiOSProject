//
//  NSDate+AppCategory.h
//
//  Created by alpha yu on 2024/3/13
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (AppCategory)

/**
 根据 TIMESTAMP_MILLISECOND_ENABLE 配置, 返回从1970年0时0分0秒起的秒或毫秒整数
 可用来替换 timeIntervalSince1970 方法
 */
@property (nonatomic, readonly) NSInteger timeIntervalFrom1970;

/// 从1970年0时0分0秒起的毫秒整数
@property (nonatomic, readonly) NSInteger millisecondIntervalFrom1970;

@end



NS_ASSUME_NONNULL_END
