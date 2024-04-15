//   
//   UITableView+AppPageData.m
//   
//   Created by alpha yu on 2023/6/21 
//   
   

#import "UITableView+AppPageData.h"
#import <MJRefresh/MJRefresh.h>

const NSInteger TableViewDataFirstPageIndex = 1;
const NSInteger TableViewDataDefaultPageSize = 15;

@interface UITableView ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL hasMore;

@end

@implementation UITableView (AppPageData)

#pragma mark - public

- (void)resetData {
    [self.dataArray removeAllObjects];
    self.pageIndex = TableViewDataFirstPageIndex;
    self.hasMore = NO;
}

- (NSInteger)pageIndexWithRefresh:(BOOL)refresh {
    return refresh ? TableViewDataFirstPageIndex : self.nextPageIndex;
}

- (void)addPageDataArray:(NSArray *)array hasMore:(BOOL)hasMore isRefresh:(BOOL)isRefresh {
    self.hasMore = hasMore;
    if (isRefresh) {
        self.pageIndex = TableViewDataFirstPageIndex;
        [self.dataArray removeAllObjects];
    } else {
        self.pageIndex++;
    }
    [self.dataArray addObjectsFromArray:array];
    [self endRefreshing];
}

- (void)endRefreshing {
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
    if (self.hasMore) {
        [self.mj_footer endRefreshing];
    } else {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
    self.mj_footer.hidden = self.dataArray.count == 0 ? YES : NO;
}

- (NSInteger)nextPageIndex {
    return self.pageIndex + 1;
}

- (BOOL)hasData {
    return self.dataArray.count > 0 ? YES : NO;
}

- (NSMutableArray *)dataArray {
    NSMutableArray *array = objc_getAssociatedObject(self, _cmd);
    if (!array) {
        array = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, @selector(dataArray), array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}

- (NSInteger)pageIndex {
    NSNumber *index = objc_getAssociatedObject(self, _cmd);
    if (!index) {
        self.pageIndex = TableViewDataFirstPageIndex;
        index = @(TableViewDataFirstPageIndex);
    }
    return [index integerValue];
}

- (void)setPageIndex:(NSInteger)pageIndex {
    objc_setAssociatedObject(self, @selector(pageIndex), @(pageIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hasMore {
    NSNumber *more = objc_getAssociatedObject(self, _cmd);
    return [more boolValue];
}

- (void)setHasMore:(BOOL)hasMore {
    objc_setAssociatedObject(self, @selector(hasMore), @(hasMore), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
