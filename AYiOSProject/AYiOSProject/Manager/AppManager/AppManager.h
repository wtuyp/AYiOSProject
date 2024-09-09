//   
//  AppManager.h
//   
//  Created by alpha yu on 2023/12/15 
//   
   

#import <Foundation/Foundation.h>
#import "RootController.h"

//#define WINDOW  (AppManager.shared.window)

NS_ASSUME_NONNULL_BEGIN

// App 管理
@interface AppManager : NSObject

@property (nonatomic, assign) BOOL isFirstTimeLaunch;           ///< 是否是第一次打开app
@property (nonatomic, strong) UIWindow *window;                 ///< app window


+ (instancetype)shared;
- (instancetype)init NS_UNAVAILABLE;

/// 在 application:didFinishLaunchingWithOptions: 中调用
- (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/// 在 application:didRegisterForRemoteNotificationsWithDeviceToken: 中调用
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

@end

/// 账号
@interface AppManager (Account)

/// 账号登录(登录前请先配置好账号信息，详见 AccountManager.h)
- (void)accountLogin;
/// 账号登出
- (void)accountLogout;

@end

/// 控制器跳转
@interface AppManager (Router)

/// 显示登录界面
- (void)loginWithSuccessBlock:(nullable void(^)(void))successBlock;

/// 用户协议
- (void)showUserAgreementController;

/// 隐私政策
- (void)showPrivacyPolicyController;

@end

NS_ASSUME_NONNULL_END
