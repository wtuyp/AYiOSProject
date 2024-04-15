//   
//  LogoutApi.m
//   
//  Created by alpha yu on 2024/1/25 
//   
   

#import "LogoutApi.h"

@implementation LogoutApiRequest

- (NSString *)requestUrl {
    return @"/auth/app/logout";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDELETE;
}

@end


@implementation LogoutApiResponse



@end
