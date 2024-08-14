//   
//  CaptchaGetApi.h
//   
//  Created by alpha yu on 2024/1/22 
//   
   

#import "NetworkBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

/// 验证码获取
@interface CaptchaGetApiRequest : NetworkBaseRequest

@property (nonatomic, copy) NSString *phoneNumber;

@end


@interface CaptchaGetApiResponse : NSObject

@end

NS_ASSUME_NONNULL_END
