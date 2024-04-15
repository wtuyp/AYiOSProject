//   
//  AppManager.m
//   
//  Created by alpha yu on 2023/12/15 
//   
   

#import "AppManager.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "AccountManager.h"

#import "BaseNavigationController.h"
#import "LoginController.h"
#import "AppWebViewController.h"


static NSString *const FirstLaunchKey = APP_KEY_PREFIX@"manager.first_launch";

@interface AppManager ()

@end

@implementation AppManager

+ (instancetype)shared {
    static AppManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AppManager alloc] init];
    });
    
    return manager;
}

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//    }
//    return self;
//}

- (BOOL)isFirstTimeLaunch {
    return [[MMKV defaultMMKV] getBoolForKey:FirstLaunchKey];
}

- (void)setIsFirstTimeLaunch:(BOOL)isFirstTimeLaunch {
    [[MMKV defaultMMKV] setBool:isFirstTimeLaunch forKey:FirstLaunchKey];
}

- (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initBeforeRootModuleWithLaunchOptions:launchOptions];
    
    if (!self.isFirstTimeLaunch) {
        self.isFirstTimeLaunch = YES;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    
    if (IS_LOGIN) {
        [self loadRootModule];
    } else {
        [self loadLoginModule];
    }    
    
    [self.window makeKeyAndVisible];
    
    [self initAfterRootModuleWithLaunchOptions:launchOptions];
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 处理注册推送获取到的deviceToken
}

/// 加载根模块
- (void)loadRootModule {
    self.rootController = [[RootController alloc] init];
    self.window.rootViewController = self.rootController;
}

/// 加载登录模块
- (void)loadLoginModule {
    LoginController *vc = [[LoginController alloc] init];
    BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navi;
}

#pragma mark - private

- (void)initBeforeRootModuleWithLaunchOptions:(NSDictionary *)launchOptions {
    // 初始化MMKV数据存储
    [MMKV initializeMMKV:nil logLevel:MMKVLogNone];
    
    // UIKit 设置
    UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    if (@available(iOS 15.0, *)) {
        UITableView.appearance.sectionHeaderTopPadding = 0;
    }
}

- (void)initAfterRootModuleWithLaunchOptions:(NSDictionary *)launchOptions {
    // 键盘管理
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.enableAutoToolbar = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
    keyboardManager.toolbarDoneBarButtonItemText = @"完成";
    
    // 推送配置
    
    // IM 配置
    
    // 微信

}

@end

@implementation AppManager (Account)

- (void)accountLogin {
    // 其他登录
    // ...
    
    [self loadRootModule];
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFY_ACCOUNT_LOGIN object:nil];
}

- (void)accountLogout {
    [AccountManager.shared logout];
    UIApplication.sharedApplication.applicationIconBadgeNumber = 0;
    
    // 其他退出登录
    // ...
    
    [self loadLoginModule];
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFY_ACCOUNT_LOGOUT object:nil];
}

@end

@implementation AppManager (Router)

- (void)loginWithSuccessBlock:(nullable void(^)(void))successBlock {
    if (IS_LOGIN) {
        !successBlock ?: successBlock();
        return;
    }

//    LoginController *vc = [[LoginController alloc] init];
//    WEAK_SELF
//    vc.loginSuccessBlock = ^{
//        STRONG_SELF
//        [self.rootController dismissViewControllerAnimated:YES completion:nil];
//        !successBlock ?: successBlock();
//    };
//    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
//    nav.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self.rootController presentViewController:nav animated:YES completion:nil];
}

- (void)showUserAgreementController {
    AppWebViewController *vc = [[AppWebViewController alloc] init];
    vc.url = URL_USER_AGREEMENT;
    [UIUtils.getNavigationController pushViewController:vc animated:YES];
}

- (void)showPrivacyPolicyController {
    AppWebViewController *vc = [[AppWebViewController alloc] init];
    vc.url = URL_PRIVACY_POLICY;
    [UIUtils.getNavigationController pushViewController:vc animated:YES];
}

@end
