//
//  NetworkManager.h
//
//  Created by MMM on 2021/9/15.
//

#import <Foundation/Foundation.h>
#import "NetworkBaseRequest.h"

extern NSString * _Nonnull const NetworkResponseParamStatusCode;
extern NSString * _Nonnull const NetworkResponseParamMessage;
extern NSString * _Nonnull const NetworkResponseParamData;

/// 服务端返回状态码
typedef NS_ENUM(NSInteger, NetworkResponseStatusCode) {
    NetworkResponseStatusCodeDefault = -1000,       ///< 默认
    NetworkResponseStatusCodeSuccess = 200,         ///< 成功
    NetworkResponseStatusCodeOffline = 401,         ///< 触发下线
    NetworkResponseStatusCodeNoAccess = 403,        ///< 没有访问权限
    NetworkResponseStatusCodeTokenExpired = 4031,   ///< token过期
    NetworkResponseStatusCodeUpgrade = 100003,      ///< 版本更新
};

/// 网络请求错误枚举
typedef NS_ENUM(NSInteger, NetworkError) {
    NetworkErrorUnknown = 10000001,     ///< 未知错误
    NetworkErrorNetwork = 10000002,     ///< 网络异常
    NetworkErrorFormat = 10000003,      ///< 解析异常
    NetworkErrorRequest = 10000004,     ///< 请求异常
    NetworkErrorResponse = 10000005,    ///< 响应异常
};

/// 网络连接状态
typedef NS_ENUM(NSInteger, NetworkReachableStatus) {
    NetworkReachableStatusUnknown = 0,  ///< 未知
    NetworkReachableStatusNone,         ///< 无网络
    NetworkReachableStatusWWAN,         ///< 蜂窝网络
    NetworkReachableStatusWifi,         ///< wifi
};

NS_ASSUME_NONNULL_BEGIN

/// 网络请求管理
@interface NetworkManager : NSObject

@property (nonatomic, copy, nullable) NSString *baseUrl;    ///< 域名，优化级低于BaseRequest的baseUrl

+ (instancetype)shared;
- (instancetype)init NS_UNAVAILABLE;

/// 开始请求
- (void)startRequest:(NetworkBaseRequest *)request;
/// 结束请求
- (void)stopRequest:(NetworkBaseRequest *)request;

@end

NS_ASSUME_NONNULL_END
