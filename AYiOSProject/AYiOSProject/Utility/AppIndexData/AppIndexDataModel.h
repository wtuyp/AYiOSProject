//   
//  IndexDataModel.h
//   
//  Created by alpha yu on 2024/3/8 
//   
   

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 索引数据模型
@interface AppIndexDataModel : NSObject

@property (nonatomic, copy) NSString *index;    ///< 索引
@property (nonatomic, copy) NSArray *list;      ///< 列表

@end

NS_ASSUME_NONNULL_END
