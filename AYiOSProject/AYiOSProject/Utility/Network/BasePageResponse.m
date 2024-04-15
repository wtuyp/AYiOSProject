//   
//  BasePageResponse.m
//   
//  Created by alpha yu on 2024/1/11 
//   
   

#import "BasePageResponse.h"

@interface BasePageResponse ()

@end

@implementation BasePageResponse

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"list" : @[@"list", @"data", @"items"],
        @"hasMore" : @"pageDomain.more",
    };
}

@end
