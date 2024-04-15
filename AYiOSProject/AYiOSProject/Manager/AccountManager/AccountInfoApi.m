//   
//  AccountInfoApi.m
//   
//  Created by alpha yu on 2024/1/23 
//   
   

#import "AccountInfoApi.h"

@implementation AccountInfoApiRequest

- (NSString *)requestUrl {
    return @"/app/account/info";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end


@implementation AccountInfoApiResponse

#pragma mark - yymodel

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    mDic[@"account"] = dic;
    return mDic;
}

@end
