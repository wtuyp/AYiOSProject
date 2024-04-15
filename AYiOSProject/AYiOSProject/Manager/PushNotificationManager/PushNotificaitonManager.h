//   
//  PushNotificaitonManager.h
//   
//  Created by alpha yu on 2024/1/16 
//   
   

#import <Foundation/Foundation.h>
#import "PushNotificaitonContent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PushNotificaitonContentListenerDelegate <NSObject>

@optional

/// 收到前台推送消息
- (void)pushNotificaitonManagerReceivedForegroundWithMessage:(PushNotificaitonContent *)content;

@end


/// 推送管理
@interface PushNotificaitonManager : NSObject

+ (instancetype)shared;
- (instancetype)init NS_UNAVAILABLE;

/// 初始化。在 application:didFinishLaunchingWithOptions: 中调用
- (void)initConfigWithLaunchOptions:(NSDictionary *)launchOptions;

/// 更新推送token, 由 application:didRegisterForRemoteNotificationsWithDeviceToken: 获得
- (void)updateAPNSToken:(NSData *)token;

/// 与登录账号绑定
- (void)bindAccount;

/// 加入推送监听
- (void)addListener:(id<PushNotificaitonContentListenerDelegate>)listener;

@end

NS_ASSUME_NONNULL_END
