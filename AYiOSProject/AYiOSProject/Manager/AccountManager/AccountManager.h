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
@property (nonatomic, copy, nullable) NSString *accessToken;                ///< 访问 token

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

NS_ASSUME_NONNULL_END
