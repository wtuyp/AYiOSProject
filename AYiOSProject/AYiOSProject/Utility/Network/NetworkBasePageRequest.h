//   
//  NetworkBasePageRequest.h
//   
//  Created by alpha yu on 2024/1/23 
//   
   

#import "NetworkBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

/// 分页的网络请求基类
@interface NetworkBasePageRequest : NetworkBaseRequest

@property (nonatomic, assign) NSInteger pageSize;   ///< 每页数量
@property (nonatomic, assign) NSInteger pageNum;    ///< 当前页码

@end

NS_ASSUME_NONNULL_END
