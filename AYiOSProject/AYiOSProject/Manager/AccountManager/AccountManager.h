//   
//  AccountManager.h
//   
//  Created by alpha yu on 2023/12/15 
//   
   

#import <Foundation/Foundation.h>
#import "AccountInfoModel.h"

#define IS_LOGIN    [AccountManager.shared isLogin]

NS_ASSUME_NONNULL_BEGIN

/// 账户管理
@interface AccountManager : NSObject

@property (nonatomic, copy, readonly, nullable) AccountInfoModel *account;  ///< 账户信息
@property (nonatomic, copy, nullable) NSString *accessToken;        ///< 访问token
@property (nonatomic, copy, nullable) NSString *refreshToken;       ///< 刷新token

+ (instancetype)shared;
- (instancetype)init NS_UNAVAILABLE;

/// 更新账户信息
- (void)updateAccount:(AccountInfoModel * _Nullable)account;

/// 退出登录
- (void)logout;

/// 是否登录
- (BOOL)isLogin;

/// 请求并更新账户信息
- (void)requestAccountInfo;
/// 退出登录
- (void)requestLogout;

@end

/**
 关于 accessToken 和 refreshToken 的说明：
 第一次登录，后端返回access_token和refresh_token，你们存住，每次请求都带这两个token，
 我会判断access_token是否失效，没失效正常访问，失效了就返回两个新的access_token和refresh_token，你们继续存下。
 如果refresh_token也失效，就让重新登录。
 这样一段时间有登录就不用手动登录，除非太久没登录，refresh_token也失效了，才让重新登录。
 两个token失效我会返回401。
 
 情况一：access_token有效，正常访问；
 情况二：access_token失效，refresh_token有效，后端返回两个新的token，code403；
 情况三：两个都失效，返回code401，重新登录；
 */

NS_ASSUME_NONNULL_END
