//   
//  CheckNewVersionApi.m
//   
//  Created by alpha yu on 2024/1/23 
//   
   

#import "CheckNewVersionApi.h"

@implementation CheckNewVersionApiRequest

- (NSString *)requestUrl {
    return @"/app/version/check";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end


@implementation CheckNewVersionApiResponse



@end
