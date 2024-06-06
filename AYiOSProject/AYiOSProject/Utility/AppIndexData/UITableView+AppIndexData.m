//   
//   UITableView+AppIndexData.m
//
//   Created by alpha yu on 2024/3/7
//
   

#import "UITableView+AppIndexData.h"
#import "MMMLab.h"

@interface UITableView ()

@property (nonatomic, copy) NSArray<NSString *> *indexArray;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray *> *indexDataMutableDic;

@end

@implementation UITableView (AppIndexData)

MMMSynthesizeIdCopyProperty(indexArray, setIndexArray)

#pragma mark - getter

- (NSMutableDictionary *)indexDataMutableDic {
    NSMutableDictionary *dic = objc_getAssociatedObject(self, _cmd);
    if (!dic) {
        dic = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, @selector(indexDataMutableDic), dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}

- (NSDictionary<NSString *, NSArray *> *)indexDataDic {
    return self.indexDataMutableDic;
}

#pragma mark - public

- (void)addIndexData:(id)data index:(NSString *)index {
    if (!data || !index || index.length == 0) {
        return;
    }
    
    if([[self.indexDataMutableDic allKeys] containsObject:index]){
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:self.indexDataMutableDic[index]];
        [dataArray addObject:data];
        self.indexDataMutableDic[index] = [dataArray copy];
    } else {
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:@[data]];
        self.indexDataMutableDic[index] = [dataArray copy];
    }
}

- (void)updateIndexDataArray:(NSArray *)dataArray index:(NSString *)index {
    if (index.length == 0) {
        return;
    }
    
    if (dataArray) {
        self.indexDataMutableDic[index] = [dataArray copy];
    } else {
        [self.indexDataMutableDic removeObjectForKey:index];
    }
}

- (void)updateIndexDataDic:(NSDictionary<NSString *, NSArray *> *)indexDataDic {
    if (!indexDataDic) {
        return;
    }
    
    [self.indexDataMutableDic removeAllObjects];
    [self.indexDataMutableDic addEntriesFromDictionary:indexDataDic];
}

- (void)clearIndexDataDic {
    [self.indexDataMutableDic removeAllObjects];
}

- (void)updateIndexArrayWithCompareSorted {
    self.indexArray = [[self.indexDataMutableDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    if ([self.indexArray containsObject:@"#"]) {
        NSMutableArray *indexArray = [[NSMutableArray alloc] initWithArray:self.indexArray];
        [indexArray removeObject:@"#"];
        [indexArray addObject:@"#"];
        self.indexArray = indexArray;
    }
}

- (void)updateIndexArray:(NSArray<NSString *> *)indexArray {
    self.indexArray = indexArray;
}

- (NSArray *)indexDataArrayWithIndex:(NSString *)index {
    if (!index || index.length == 0) {
        return nil;
    }
    
    return self.indexDataMutableDic[index];
}

#pragma mark - private



@end
