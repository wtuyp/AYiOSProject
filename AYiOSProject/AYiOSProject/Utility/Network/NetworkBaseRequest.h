//
//  NetworkBaseRequest.h
//
//  Created by MMM on 2021/9/15.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SuccessHandler)(NSInteger statusCode, NSString * _Nullable message, id _Nullable data);
typedef void (^FailureHandler)(NSInteger statusCode, NSString * _Nullable message, id _Nullable data);

/**
 请求基类，子类继承发起请求。
 子类命名规范 xxxRequest；默认响应数据模型为 xxxResponse，由开发者生成。
 */
@interface NetworkBaseRequest : YTKRequest

@property (nonatomic, copy, nullable) SuccessHandler success;
@property (nonatomic, copy, nullable) FailureHandler failure;

/// 开始请求
- (void)startRequest;

/// 开始请求，成功与失败回调
- (void)startRequestWithSuccess:(SuccessHandler _Nullable)success 
                        failure:(FailureHandler _Nullable)failure;

/// 停止请求
- (void)stopRequest;

/// 重试请求，返回一个新的请求实例
- (__kindof NetworkBaseRequest *)retryRequest;

/// 上传文件时配置，使用 NSData
- (void)setUploadConfigWithKey:(NSString *)key
                      fileData:(NSData *)fileData
                      fileName:(NSString *)fileName
                  fileMIMEType:(NSString *)fileMIMEType;

/// 上传文件时配置，使用 文件路径
- (void)setUploadConfigWithKey:(NSString *)key
                      filePath:(NSString *)filePath
                      fileName:(NSString *)fileName
                  fileMIMEType:(NSString *)fileMIMEType;

/// 请求时需要忽略的属性名，用于有值但不用发送的时候
+ (NSArray * _Nullable)ignoreRequestModelPropertyNameArray;

@end

NS_ASSUME_NONNULL_END
