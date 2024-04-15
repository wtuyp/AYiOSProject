//
//  NSDate+AppCategory.m
//
//  Created by alpha yu on 2024/3/13
//

#import "NSDate+AppCategory.h"

@implementation NSDate (AppCategory)

- (NSInteger)timeIntervalFrom1970 {
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
#ifdef TIMESTAMP_MILLISECOND_ENABLE
    return (NSInteger)(timeInterval * 1000.0);
#else
    return (NSInteger)(timeInterval);
#endif
}

@end
