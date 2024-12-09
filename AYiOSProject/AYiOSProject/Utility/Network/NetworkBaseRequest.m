//
//  NetworkBaseRequest.m
//
//  Created by MMM on 2021/9/15.
//

#import "NetworkBaseRequest.h"
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>
#import "NetworkManager.h"

#import "AccountManager.h"

@interface NetworkBaseRequest ()

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *uploadConfigs;

@end

@implementation NetworkBaseRequest

#pragma mark - override

/// 请求的BaseURL
//- (NSString *)baseUrl {
//    return BASE_URL;
//}

/// 请求方法
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

/// 请求超时间隔，默认是15s
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
    if (AccountManager.shared.accessToken) {
        headerDic[@"Access-Token"] = AccountManager.shared.accessToken;
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

- (AFConstructingBlock)constructingBodyBlock {
    if (self.uploadConfigs.count == 0) {
        return nil;
    }
    
    return ^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSDictionary *config in self.uploadConfigs) {
            NSData *data = config[@"fileData"];
            if (data) {
                [formData appendPartWithFileData:data
                                            name:config[@"key"]
                                        fileName:config[@"fileName"]
                                        mimeType:config[@"fileMIMEType"]];
            }
            
            NSString *filePath = config[@"filePath"];
            if (filePath) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath]
                                           name:config[@"key"]
                                       fileName:config[@"fileName"]
                                       mimeType:config[@"fileMIMEType"]
                                          error:nil];
            }
        }
    };
}

/// 需要忽略的属性名数组
+ (NSArray *)ignoreRequestModelPropertyNameArray {
    return nil;
}

#pragma mark - getter

- (NSMutableArray<NSDictionary *> *)uploadConfigs {
    if (!_uploadConfigs) {
        _uploadConfigs = [[NSMutableArray alloc] init];
    }
    
    return _uploadConfigs;
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

- (__kindof NetworkBaseRequest *)retryRequest {
    NetworkBaseRequest *request = [self yy_modelCopy];
    [request startRequestWithSuccess:self.success failure:self.failure];
    return request;
}

- (void)addUploadConfigWithKey:(NSString *)key
                      fileData:(NSData *)fileData
                      fileName:(NSString *)fileName
                  fileMIMEType:(NSString *)fileMIMEType {
    [self removeUploadConfigWithKey:key];
    
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    configDic[@"key"] = key;
    configDic[@"fileData"] = fileData;
    configDic[@"fileName"] = fileName;
    configDic[@"fileMIMEType"] = fileMIMEType;
    
    [self.uploadConfigs addObject:configDic];
}

- (void)addUploadConfigWithKey:(NSString *)key
                      filePath:(NSString *)filePath
                      fileName:(NSString *)fileName
                  fileMIMEType:(NSString *)fileMIMEType {
    [self removeUploadConfigWithKey:key];
    
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    configDic[@"key"] = key;
    configDic[@"filePath"] = filePath;
    configDic[@"fileName"] = fileName;
    configDic[@"fileMIMEType"] = fileMIMEType;
    
    [self.uploadConfigs addObject:configDic];
}

- (void)removeUploadConfigWithKey:(NSString *)key {
    NSDictionary *dic = nil;
    for (NSDictionary *config in self.uploadConfigs) {
        if ([config[@"key"] isEqualToString:key]) {
            dic = config;
            break;
        }
    }
    
    if (dic) {
        [self.uploadConfigs removeObject:dic];
    }
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

#pragma mark - yymodel

/// 屏蔽 NetworkBaseRequest 及父类属性
+ (NSArray *)modelPropertyBlacklist {
    static NSMutableArray *propertyNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyNames = [[NSMutableArray alloc] init];
        Class cls = [NetworkBaseRequest class];
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


@end
