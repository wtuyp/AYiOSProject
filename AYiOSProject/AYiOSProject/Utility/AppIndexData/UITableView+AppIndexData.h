//   
//   UITableView+AppIndexData.h
//   
//   Created by alpha yu on 2024/3/7
//
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// UITableView 索引相关
@interface UITableView (AppIndexData)

@property (nonatomic, copy, readonly) NSArray<NSString *> *indexArray;  ///< 索引数组
//@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSArray *> *indexDataDic;  ///< 索引数据字典

/// 通过增加索引和数据，更新索引数据字典
- (void)addIndexData:(id)data index:(NSString *)index;

/// 通过更新索引和数据数组，更新索引数据字典
- (void)updateIndexDataArray:(NSArray * _Nullable)dataArray index:(NSString *)index;

/// 更新索引数据字典
- (void)updateIndexDataDic:(NSDictionary<NSString *, NSArray *> *)indexDataDic;

/// 清空索引数据字典
- (void)clearIndexDataDic;

/// 使用 compare 排序更新索引数组, 如有#则排在最后（索引数据字典完成后调用）
- (void)updateIndexArrayWithCompareSorted;

/// 直接更新索引数组
- (void)updateIndexArray:(NSArray<NSString *> *)indexArray;

/// 根据索引，返回数据数组
- (NSArray * _Nullable)indexDataArrayWithIndex:(NSString *)index;

@end

NS_ASSUME_NONNULL_END
