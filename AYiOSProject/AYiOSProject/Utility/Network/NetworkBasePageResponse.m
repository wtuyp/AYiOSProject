//   
//  NetworkBasePageResponse.m
//   
//  Created by alpha yu on 2024/1/11 
//   
   

#import "NetworkBasePageResponse.h"

@interface NetworkBasePageResponse ()

@end

@implementation NetworkBasePageResponse

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"list" : @[@"list", @"data", @"items"],
        @"hasMore" : @"pageDomain.more",
    };
}

@end
