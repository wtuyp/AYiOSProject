//   
//  CaptchaGetApi.m
//
//  Created by alpha yu on 2024/1/22 
//   
   

#import "CaptchaGetApi.h"

@implementation CaptchaGetApiRequest

- (NSString *)requestUrl {
    return @"/auth/captcha/get";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end


@implementation CaptchaGetApiResponse


@end
