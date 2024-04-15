//   
//  BasePageRequest.m
//   
//  Created by alpha yu on 2024/1/23 
//   
   

#import "BasePageRequest.h"

@implementation BasePageRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageNum = TableViewDataFirstPageIndex;
        _pageSize = TableViewDataDefaultPageSize;
    }
    return self;
}

@end
