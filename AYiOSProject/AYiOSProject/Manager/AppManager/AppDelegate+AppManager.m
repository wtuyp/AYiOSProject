//   
//   AppDelegate+AppManager.m
//
//   Created  by alpha yu on 2024/1/16
//
   

#import "AppDelegate+AppManager.h"
#import "AppManager.h"

@implementation AppDelegate (AppManager)

#pragma mark - Remote Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [AppManager.shared didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

@end
