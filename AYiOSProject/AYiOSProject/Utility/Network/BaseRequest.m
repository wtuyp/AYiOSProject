//
//  BaseRequest.m
//
//  Created by MMM on 2021/9/15.
//

#import "BaseRequest.h"
#import "NetworkManager.h"
#import "NetworkUrl.h"

#import "AccountManager.h"

@implementation BaseRequest

#pragma mark - override

/// 请求的BaseURL
- (NSString *)baseUrl {
    return BASE_URL;
}

/// 请求方法
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

/// 请求超时间隔，默认是15S
- (NSTimeInterval)requestTimeoutInterval {
    return 15.0;
}

/// 请求参数
- (nullable id)requestArgument {
    id arg = [self yy_modelToJSONObject];
    return arg ?: @{};
}

/// HTTP请求Header
- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary {
    NSMutableDictionary<NSString *, NSString *> *headerDic = [[NSMutableDictionary alloc] init];
    headerDic[@"App-Version"] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    headerDic[@"Device-Platform"] = @"iOS";
    if (AccountManager.shared.accessToken && AccountManager.shared.refreshToken) {
        headerDic[@"Access-Token"] = AccountManager.shared.accessToken;
        headerDic[@"Refresh-Token"] = AccountManager.shared.refreshToken;
    }

    return headerDic;
}

/// 请求序列化类型
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

/// 响应序列化类型
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

/// 需要忽略的属性名数组
+ (NSArray *)ignoreRequestModelPropertyNameArray {
    return nil;
}

#pragma mark - yymodel

/// 屏蔽BaseRequest及父类属性
+ (NSArray *)modelPropertyBlacklist {
    static NSMutableArray *propertyNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyNames = [[NSMutableArray alloc] init];
        Class cls = [BaseRequest class];
        while (cls != nil) {
            unsigned int propertyCount = 0;
            objc_property_t *propertys = class_copyPropertyList(cls, &propertyCount);
            for (int i = 0; i < propertyCount; i++) {
                objc_property_t property = propertys[i];
                const char *propertyName = property_getName(property);
                [propertyNames addObject:[NSString stringWithUTF8String:propertyName]];
            }
            free(propertys);
            
            cls = class_getSuperclass(cls);
            if ([cls isEqual:NSObject.class]) {
                break;
            }
        }
    });
    
    if (![self ignoreRequestModelPropertyNameArray]) {
        return propertyNames;
    } else {
        NSArray *ignoreModelPropertyNameArray = [propertyNames arrayByAddingObjectsFromArray:[self ignoreRequestModelPropertyNameArray]];
        return ignoreModelPropertyNameArray;
    }
}

#pragma mark - public

- (void)startRequest {
    [[NetworkManager shared] startRequest:self];
}

- (void)startRequestWithSuccess:(SuccessHandler _Nullable)success failure:(FailureHandler _Nullable)failure {
    self.success = success;
    self.failure = failure;
    [self startRequest];
}

- (void)stopRequest {
    [[NetworkManager shared] stopRequest:self];
}

- (__kindof BaseRequest *)retryRequest {
    BaseRequest *request = [self yy_modelCopy];
    request.success = self.success;
    request.failure = self.failure;
    [request startRequest];
    return request;
}

#pragma mark - private

- (NSString *)description {
    NSURLRequest *request = self.currentRequest;
    
    return [NSString stringWithFormat:@"<%@: %p>\n%@ %@\n%@\nBody:\n%@",
            NSStringFromClass([self class]),
            self,
            request.HTTPMethod,
            request.URL,
            [request.allHTTPHeaderFields jsonStringPrettyWithoutEscapingSlashes],
            [self.requestArgument jsonStringPrettyWithoutEscapingSlashes]];
}

@end
