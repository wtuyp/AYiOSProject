//
//  AppUtils.h
//
//  Created by MMM on 2021/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppUtils : NSObject

/// 打电话
+ (void)callPhoneNumber:(NSString *)number;

/// App推送通知是否已授权
+ (void)isAppNotificationAuthorized:(void(^)(BOOL isAuthorized))result;

/// 在手机的设置中打开 App 推送通知设置界面
+ (void)openAppNotificationSetting;

/// 在手机的设置中打开 App 设置
+ (void)openAppSetting;

@end

NS_ASSUME_NONNULL_END
