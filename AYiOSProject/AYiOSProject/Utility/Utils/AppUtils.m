//
//  AppUtils.m
//
//  Created by MMM on 2021/8/6.
//
#import "AppUtils.h"
#import <UserNotifications/UserNotifications.h>
#import "AppAlert.h"

@implementation AppUtils

+ (void)callPhoneNumber:(NSString *)number {
    if (number.length == 0) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", number]];
    [[UIApplication sharedApplication] openURL:url
                                       options:@{}
                             completionHandler:^(BOOL success) {
    }];
}

+ (void)isAppNotificationAuthorized:(void(^)(BOOL isAuthorized))result {
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (result) {
            result(settings.authorizationStatus == UNAuthorizationStatusAuthorized ? YES : NO);
        }
    }];
}

+ (void)openAppNotificationSetting {
    if (@available(iOS 15.4, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenNotificationSettingsURLString] options:@{} completionHandler:nil];
    } else {
        [AppUtils openAppSetting];
    }
}

+ (void)openAppSetting {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}

@end
