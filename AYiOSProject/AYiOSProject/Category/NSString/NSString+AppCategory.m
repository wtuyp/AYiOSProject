//
//  NSString+AppCategory.m
//
//  Created by alpha yu on 2023/1/9.
//

#import "NSString+AppCategory.h"

@implementation NSString (AppCategory)

- (void)enumerateSubstring:(NSString *)substring usingBlock:(void (^)(NSUInteger idx, NSRange substringRange, BOOL *stop))block {
    if (!self.length || !substring.length || ![self containsString:substring]) {
        return;
    }
    
    __block NSUInteger length = substring.length;
    __block NSUInteger location = 0;
    NSArray <NSString *> *components = [self componentsSeparatedByString:substring];
    [components enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        location += obj.length;
        NSRange range = NSMakeRange(location, length);
        if (block) {
            block(idx, range, stop);
        };
        location += length;
        if (idx == components.count - 2) { // 到最后一个截止（不包括最后一个）
            *stop = YES;
        }
    }];
}

@end


@implementation NSString (AppTime)

- (NSString *)timeStringFromTimestamp {
    return [self timeStringFromTimestampWithFormat:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)timeStringFromTimestampWithFormat:(NSString *)format {
    NSTimeInterval timeInterval = self.doubleValue;
#ifdef TIMESTAMP_MILLISECOND_ENABLE
    timeInterval /= 1000.0;
#endif
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [date stringWithFormat:format ?: @"yyyy-MM-dd HH:mm"];
}

+ (NSString *)durationStringFromSeconds:(NSInteger)seconds {
    return STRING_FORMAT(@"%02li:%02li", (long)(seconds / 60), (long)(seconds % 60));
}

- (NSString *)durationString {
    NSInteger seconds = self.integerValue;
//#ifdef TIMESTAMP_MILLISECOND_ENABLE
//    seconds /= 1000;
//#endif
    return [NSString durationStringFromSeconds:seconds];
}

@end

@implementation NSString (AppPrice)

- (NSString *)priceString {
    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.generatesDecimalNumbers = YES;
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 2;
        formatter.roundingMode = NSNumberFormatterRoundCeiling;
    });
    
    NSNumber *number = [NSNumber numberWithDouble:self.doubleValue];
    NSString *result = [formatter stringFromNumber:number];
    return result;
}

- (NSString *)priceStringWithMaxTwoFraction {
    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.generatesDecimalNumbers = YES;
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 2;
        formatter.roundingMode = NSNumberFormatterRoundCeiling;
    });

    NSNumber *number = [NSNumber numberWithDouble:self.doubleValue];
    NSString *result = [formatter stringFromNumber:number];
    return result;
}

@end

@implementation NSString (AppNumber)

- (NSString *)trimNumber {
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:self];
    NSString *string = STRING_FORMAT(@"%@", number);
    return string;
}

- (BOOL)isNumber {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:self];
    return ![decimalNumber isEqualToNumber:[NSDecimalNumber notANumber]];
}

@end
