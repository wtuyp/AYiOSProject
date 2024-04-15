//   
//  BasePageResponse.h
//   
//  Created by alpha yu on 2024/1/11 
//   
   

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 分页的网络响应基类
@interface BasePageResponse : NSObject

@property (nonatomic, copy) NSArray *list;  ///< 列表
@property (nonatomic, assign) BOOL hasMore; ///< 是否有更多

//@property (nonatomic, assign) NSInteger pageSize;
//@property (nonatomic, assign) NSInteger totalCount;
//@property (nonatomic, assign) NSInteger currPage;
//@property (nonatomic, assign) NSInteger totalPage;

@end

NS_ASSUME_NONNULL_END
