//   
//  NSDictionary+AppCategory.m
//   
//  Created by alpha yu on 2024/4/2 
//   
   

#import "NSDictionary+AppCategory.h"

@implementation NSDictionary (AppCategory)

- (NSString *)jsonStringPrettyWithoutEscapingSlashes {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSJSONWritingOptions options = NSJSONWritingPrettyPrinted;
        if (@available(iOS 13.0, *)) {
            options = NSJSONWritingPrettyPrinted | NSJSONWritingWithoutEscapingSlashes;
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:options error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

@end
