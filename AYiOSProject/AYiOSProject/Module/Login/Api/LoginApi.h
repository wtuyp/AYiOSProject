//   
//  LoginApi.h
//   
//  Created by alpha yu on 2024/1/22 
//   
   

#import "BaseRequest.h"
#import "AccountInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

/// App登录
@interface LoginApiRequest : BaseRequest

@property (nonatomic, copy) NSString *account;      ///< 账号
@property (nonatomic, copy) NSString *authCode;     ///< 验证码
@property (nonatomic, copy) NSString *password;     ///< 密码
@property (nonatomic, assign) LoginType loginType;  ///< 登录方式(0:验证码登录;1:密码登录)

@end


@interface LoginApiResponse : NSObject

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, strong) AccountInfoModel *accountInfo;

@end

NS_ASSUME_NONNULL_END
