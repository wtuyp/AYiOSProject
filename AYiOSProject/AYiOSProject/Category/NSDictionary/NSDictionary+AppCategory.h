//   
//  NSDictionary+AppCategory.h
//   
//  Created by alpha yu on 2024/4/2 
//   
   

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (AppCategory)

/// 字典转字符串（用于控制台输出）
- (NSString *)jsonStringPrettyWithoutEscapingSlashes;

@end

NS_ASSUME_NONNULL_END
