//
//  NSDate+AppCategory.h
//
//  Created by alpha yu on 2024/3/13
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (AppCategory)

/**
 从1970年以来的时间戳整数（根据TIMESTAMP_MILLISECOND_ENABLE配置, 返回秒或毫秒）
 可用来替换 timeIntervalSince1970 方法
 */
@property (nonatomic, readonly) NSInteger timeIntervalFrom1970;

@end



NS_ASSUME_NONNULL_END
