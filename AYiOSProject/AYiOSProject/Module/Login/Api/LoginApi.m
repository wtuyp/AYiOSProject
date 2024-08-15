//   
//  LoginApi.m
//   
//  Created by alpha yu on 2024/1/22 
//   
   

#import "LoginApi.h"

@implementation LoginApiRequest

- (NSString *)requestUrl {
    return @"/auth/app/login";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end


@implementation LoginApiResponse


@end
