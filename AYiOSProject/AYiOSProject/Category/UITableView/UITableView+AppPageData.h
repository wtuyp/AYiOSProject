//   
//   UITableView+AppPageData.h
//   
//   Created by alpha yu on 2023/6/21 
//   
   

#import <UIKit/UIKit.h>

extern const NSInteger TableViewDataFirstPageIndex;     ///< 首页序号（根据实际情况修改，可能是0，可能是1）
extern const NSInteger TableViewDataDefaultPageSize;    ///< 每页几条数据

NS_ASSUME_NONNULL_BEGIN

/// UITableView 分页相关
@interface UITableView (AppPageData)

@property (nonatomic, strong, readonly) NSMutableArray *dataArray;  ///< 列表数据
@property (nonatomic, assign, readonly) BOOL hasData;               ///< 列表是否有数据

@property (nonatomic, assign, readonly) NSInteger pageIndex;        ///< 当前页序号
@property (nonatomic, assign, readonly) NSInteger nextPageIndex;    ///< 下一页序号
@property (nonatomic, assign, readonly) BOOL hasMore;               ///< 是否有更多数据

// 使用 page 会引起列表数据重复或丢失，建议使用 id 来处理。
@property (nonatomic, strong, nullable) id firstDataId;             ///< 第一条数据 Id
@property (nonatomic, strong, nullable) id lastDataId;              ///< 最后一条数据 Id


/// 根据刷新情况返回对应分页序号
- (NSInteger)pageIndexWithRefresh:(BOOL)refresh;

/// 更新数据（使用 pageIndex 时）
- (void)addPageDataArray:(NSArray *)array hasMore:(BOOL)hasMore isRefresh:(BOOL)isRefresh;

/// 更新数据（使用 dataId 时）
- (void)addPageDataArray:(NSArray *)array dataIdKey:(NSString *)dataIdKey hasMore:(BOOL)hasMore isRefresh:(BOOL)isRefresh;

/// 结束 刷新 或 加载更多
- (void)endRefreshing;

@end

NS_ASSUME_NONNULL_END
