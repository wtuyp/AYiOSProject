//   
//  AccountManager.m
//   
//  Created by alpha yu on 2023/12/15 
//   
   

#import "AccountManager.h"
#import <MMKV/MMKV.h>
#import "AccountInfoApi.h"
#import "LogoutApi.h"

static NSString *const AccountAccessTokenKey = APP_KEY_PREFIX@"account.access.token";
static NSString *const AccountInfoKey = APP_KEY_PREFIX@"account.info";

@interface AccountManager ()


@end

@implementation AccountManager

+ (instancetype)shared {
    static AccountManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AccountManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}

- (void)loadData {
    self.accessToken = [[MMKV defaultMMKV] getStringForKey:AccountAccessTokenKey];
    
    NSString *infoJSONString = [[MMKV defaultMMKV] getStringForKey:AccountInfoKey];
    _account = [AccountInfoModel yy_modelWithJSON:infoJSONString];
}

- (void)setAccessToken:(NSString *)accessToken {
    _accessToken = accessToken;
    if (accessToken) {
        [[MMKV defaultMMKV] setString:accessToken forKey:AccountAccessTokenKey];
    } else {
        [[MMKV defaultMMKV] removeValueForKey:AccountAccessTokenKey];
    }
}

- (void)updateAccount:(AccountInfoModel * _Nullable)account {
    _account = account;
    if (account) {
        [[MMKV defaultMMKV] setString:[account yy_modelToJSONString] forKey:AccountInfoKey];
    } else {
        [[MMKV defaultMMKV] removeValueForKey:AccountInfoKey];
    }
}

- (void)logout {
    self.accessToken = nil;
    [self updateAccount:nil];
}

- (BOOL)isLogin {
    return self.accessToken.length > 0 ? YES : NO;
}

- (void)requestAccountInfo {
    AccountInfoApiRequest *request = [[AccountInfoApiRequest alloc] init];
    [request startRequestWithSuccess:^(NSInteger statusCode, NSString * _Nullable message, id  _Nullable data) {
        AccountInfoApiResponse *response = (AccountInfoApiResponse *)data;
        [self updateAccount:response.account];
    } failure:nil];
}

/// 退出登录请求
- (void)requestLogout {
    LogoutApiRequest *request = [[LogoutApiRequest alloc] init];
    [request startRequestWithSuccess:^(NSInteger statusCode, NSString * _Nullable message, id  _Nullable data) {
//        [MBProgressHUD hideAllTipsInView:self.view];
//        <#response#> *response = (<#response#> *)data;
    } failure:^(NSInteger statusCode, NSString * _Nullable message, id  _Nullable data) {
//        [MBProgressHUD hideAllTipsInView:self.view];
//        [MBProgressHUD showWithText:message inView:self.view];
    }];
}

@end
