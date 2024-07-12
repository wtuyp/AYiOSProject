//
//  NetworkManager.m
//
//  Created by MMM on 2021/9/15.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

NSString *const NetworkResponseParamStatusCode = @"code";
NSString *const NetworkResponseParamMessage = @"msg";
NSString *const NetworkResponseParamData = @"data";

@interface NetworkManager ()

@property (nonatomic, assign) NetworkReachableStatus reachableStatus;

@end

@implementation NetworkManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static NetworkManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 网络状态监控
//        [self startMonitorReachableStatus];
    }
    return self;
}

#pragma mark - public

- (void)startRequest:(BaseRequest *)request {
#if DEBUG
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    if (request.userInfo) {
        [userInfo addEntriesFromDictionary:request.userInfo];
    }
    userInfo[@"requestStartDate"] = [NSDate date];
    request.userInfo = userInfo;
#endif
    request.delegate = (id<YTKRequestDelegate>)self;
    [request start];
    NSLog(@"\nRequest start: %@", request);
}

- (void)stopRequest:(BaseRequest *)request {
    NSLog(@"\nRequest stop: %@", request);
    [request stop];
}

- (void)setBaseUrl:(NSString *)baseUrl {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = baseUrl;
}

- (NSString *)baseUrl {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    return config.baseUrl;
}

#pragma mark - private

/// 获取默认响应模型
- (Class)_baseResponseClassOfBaseRequest:(BaseRequest *)req {
    NSString *string = [NSStringFromClass(req.class) stringByReplacingOccurrencesOfString:@"Request" withString:@"Response"];
    return NSClassFromString(string);
}

// 处理离线
- (void)_handleOffline {
    [AppManager.shared accountLogout];
}

// 处理升级
- (void)_handleUpgradeWithData:(id)data {
    
}

/// 打印日志
- (void)_logger:(BaseRequest *)req
           task:(NSURLSessionTask *)task
 responseObject:(id _Nullable)responseObject
          error:(NSError * _Nullable)error {

    if(!task) {
        NSLog(@"请求任务不存在");
        return;
    }
    
    // 请求时长
    NSDate *requestStartDate = req.userInfo[@"requestStartDate"];
    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:requestStartDate];
    
    // 请求实体
    NSURLRequest *request = task.originalRequest;
    
    // 响应实体
    NSInteger statusCode = 0;
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        statusCode = [(NSHTTPURLResponse *)task.response statusCode];
    }
    NSLog(@"\n--------------------\nRequest response:%@ [%.3f s] code: %li\nurl: %@\n%@\n--------------------",
         [requestStartDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss.SSS"],
         duration,
         (long)statusCode,
         [[request URL] absoluteString],
         error ? error : [responseObject jsonStringPrettyWithoutEscapingSlashes]);
}

#pragma mark - YTKRequestDelegate

- (void)requestFinished:(BaseRequest *)request {
#if DEBUG
    [self _logger:request task:request.requestTask responseObject:request.responseObject error:nil];
#endif
    
    id responseObject = request.responseObject;
    if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
        !request.failure ?: request.failure(NetworkErrorResponse, @"网络响应异常", nil);
        return;
    }
    
    NSDictionary *dict = (NSDictionary *)responseObject;
    NSInteger statusCode = [dict[NetworkResponseParamStatusCode] integerValue];
    id msg = dict[NetworkResponseParamMessage];
    NSString *message = [msg isKindOfClass:NSString.class] ? (NSString *)msg : @"";
    id data = dict[NetworkResponseParamData];
    
    if (statusCode == NetworkResponseStatusCodeSuccess) {
        id responseData = data;
        if (data) {
            Class class = [self _baseResponseClassOfBaseRequest:request];
            if ([data isKindOfClass:NSDictionary.class]) {
                if (class) {
                    responseData = [class yy_modelWithDictionary:data];
                }
            } else if ([data isKindOfClass:NSArray.class]) {
                if (class) {
                    NSMutableDictionary *responseDic = [[NSMutableDictionary alloc] init];
                    responseDic[@"list"] = (NSArray *)data;
                    responseData = [class yy_modelWithDictionary:responseDic];
                }
            } else {
                NSLog(@"--------------------\n网络请求返回字段data，不是 NSDictionary / NSArray 数据类型，请调整接口\n--------------------");
//                !request.failure ?: request.failure(NetworkErrorFormat, @"响应数据异常", responseData);
//                !request.failure ?: request.failure(NetworkErrorFormat, nil, nil);
//                return;
                
                responseData = nil;
            }
        }
        if (request.success) {
            request.success(statusCode, message, responseData);
        }
        return;
    }
    if (statusCode == NetworkResponseStatusCodeOffline
        || statusCode == NetworkResponseStatusCodeNoAccess) {
        !request.failure ?: request.failure(statusCode, message, data);
        NSTimeInterval delay = [MBProgressHUD secondsToHideWithText:message];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self _handleOffline];
        });
        return;
    }
    if (statusCode == NetworkResponseStatusCodeTokenExpired) {
        !request.failure ?: request.failure(statusCode, nil, data);

        AccountManager.shared.accessToken = data[@"accessToken"];
        AccountManager.shared.refreshToken = data[@"refreshToken"];
        
        // 重新发起请求
        [request retryRequest];
        return;
    }
    if (statusCode == NetworkResponseStatusCodeUpgrade) {
        !request.failure ?: request.failure(statusCode, nil, data);
        [self _handleUpgradeWithData:data];
        return;
    }

    !request.failure ?: request.failure(statusCode, message, data);
}

- (void)requestFailed:(BaseRequest *)request {
#if DEBUG
    [self _logger:request task:request.requestTask responseObject:nil error:request.error];
#endif
    
    if (request.failure) {
        request.failure(request.response.statusCode, request.error.localizedDescription, nil);
    }
}

#pragma mark - Reachability

- (void)startMonitorReachableStatus {
    self.reachableStatus = NetworkReachableStatusUnknown;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                self.reachableStatus = NetworkReachableStatusWifi;
                NSLog(@"Network Reachable Status: 连上Wifi了");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                self.reachableStatus = NetworkReachableStatusWWAN;
                NSLog(@"Network Reachable Status: 连上蜂窝网络了");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable: {
                self.reachableStatus = NetworkReachableStatusNone;
                NSLog(@"Network Reachable Status: 没网络了");
            }
                break;
            case AFNetworkReachabilityStatusUnknown: {
                self.reachableStatus = NetworkReachableStatusUnknown;
                NSLog(@"Network Reachable Status: 不知道什么状态");
            }
                break;
        }
    }];
}
    
- (BOOL)isReachable {
    return (self.reachableStatus == NetworkReachableStatusWifi || self.reachableStatus == NetworkReachableStatusWWAN) ? YES : NO;
}

- (BOOL)isWWAN {
    return (self.reachableStatus == NetworkReachableStatusWWAN) ? YES : NO;
}

- (BOOL)isWiFi {
    return (self.reachableStatus == NetworkReachableStatusWifi) ? YES : NO;
}

@end
