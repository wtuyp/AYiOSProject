//   
//   NSObject+AppCategory.h
//   
//   Created by alpha yu on 2023/3/31 
//   
   

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 对象常用配置
@interface NSObject (AppCategory)

@property (nonatomic, strong) id app_data;          ///< 数据
@property (nonatomic, assign) BOOL app_selected;    ///< 是否选中

@end

NS_ASSUME_NONNULL_END
