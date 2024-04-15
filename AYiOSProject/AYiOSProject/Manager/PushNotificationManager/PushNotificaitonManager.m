//   
//  PushNotificaitonManager.m
//   
//  Created by alpha yu on 2024/1/16 
//   
   

#import "PushNotificaitonManager.h"
#import <UMCommon/UMConfigure.h>
#import <UMPush/UMessage.h>

@interface PushNotificaitonManager () <UNUserNotificationCenterDelegate>

@property (nonatomic, strong, nullable) NSData *APNSToken;
@property (nonatomic, strong) NSPointerArray *listeners;

@end

@implementation PushNotificaitonManager

+ (instancetype)shared {
    static PushNotificaitonManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PushNotificaitonManager alloc] init];
    });
    
    return manager;
}

#pragma mark - getter

- (NSPointerArray *)listeners {
    if (!_listeners) {
        _listeners = [NSPointerArray weakObjectsPointerArray];
    }
    return _listeners;
}

#pragma mark - public

- (void)initConfigWithLaunchOptions:(NSDictionary *)launchOptions {
    [UMConfigure initWithAppkey:UMENG_APP_KEY channel:nil];
    
    // Push组件基本功能配置
    UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge | UMessageAuthorizationOptionSound | UMessageAuthorizationOptionAlert;
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"推送服务已开启");
        } else {
            NSLog(@"推送服务未开启");
        }
    }];
    
    [[NSNotificationCenter.defaultCenter rac_addObserverForName:NOTIFY_ACCOUNT_LOGIN object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        // 登录后，绑定用户和推送
        [PushNotificaitonManager.shared bindAccount];
    }];
}

- (void)updateAPNSToken:(NSData *)token {
    self.APNSToken = token;
    NSLog(@"推送获取到DeviceToken=%@", [token jk_APNSToken]);
    [UMessage registerDeviceToken:token];
}

- (void)bindAccount {
    if (!IS_LOGIN) {
        return;
    }
    
    
}

/// 加入推送监听
- (void)addListener:(id<PushNotificaitonContentListenerDelegate>)listener {
    if (!listener) {
        return;
    }

    [self.listeners addPointer:(__bridge void *)listener];
}

#pragma mark - private

/// 是否要处理推送消息
- (BOOL)isNeedHandleContent:(PushNotificaitonContent *)content {
    if(!IS_LOGIN) {
        return NO;
    }
    
//    UINavigationController *naviController = UIUtils.visibleViewController.navigationController;
//    UIViewController *topViewController = naviController.topViewController;
    if (content.type == PushNotificaitonContentTypeChat) {
//        if ([topViewController isKindOfClass:ChatController.class]) {
//            ChatController *vc = (ChatController *)topViewController;
//            if ((vc.chatType == message.to_type) && (vc.memberId == message.from_id)) { // 正在聊
//                return NO;
//            }
//        }
    }
    
    return YES;
}

/// 处理推送消息
- (void)handleContent:(PushNotificaitonContent *)content {
    if(!IS_LOGIN) {
        return;
    }
    
//    UINavigationController *naviController = UIUtils.getNavigationController;
    if (content.type == PushNotificaitonContentTypeChat) {
//        ChatController *vc = [[ChatController alloc] initWithChatType:message.to_type memberId:message.from_id memberName:message.from_name];
//        [naviController pushViewController:vc animated:YES];
    }
}

- (void)handleListenersWithContent:(PushNotificaitonContent *)content {
    [self.listeners addPointer:NULL];
    [self.listeners compact];

    for (id listener in self.listeners) {
        id<PushNotificaitonContentListenerDelegate> strongListener = listener;
        if ([strongListener respondsToSelector:@selector(pushNotificaitonManagerReceivedForegroundWithMessage:)]) {
            [strongListener pushNotificaitonManagerReceivedForegroundWithMessage:content];
        }
    }
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"\n应用内推送-->:%@", userInfo.jsonStringPrettyWithoutEscapingSlashes);
    
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        PushNotificaitonContent *content = [PushNotificaitonContent yy_modelWithDictionary:userInfo];
        if ([PushNotificaitonManager.shared isNeedHandleContent:content]) {
            [self handleListenersWithContent:content];
        }
    } else {
        //应用处于前台时的本地推送接受
    }
    
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"推送数据 = %@", userInfo.jsonStringPrettyWithoutEscapingSlashes);
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        /// 通知点击
        PushNotificaitonContent *content = [PushNotificaitonContent yy_modelWithDictionary:userInfo];
        if ([PushNotificaitonManager.shared isNeedHandleContent:content]) {
            [PushNotificaitonManager.shared handleContent:content];
        }
    } else {
        //应用处于后台时的本地推送接受
    }
    
    completionHandler();
}

@end
