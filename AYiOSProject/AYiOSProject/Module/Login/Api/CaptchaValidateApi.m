//   
//  CaptchaValidateApi.m
//
//  Created by alpha yu on 2024/1/30 
//   
   

#import "CaptchaValidateApi.h"

@implementation CaptchaValidateApiRequest

- (NSString *)requestUrl {
    return @"/auth/captcha/validate";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end


@implementation CaptchaValidateApiResponse



@end
