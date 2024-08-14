//   
//  NetworkBasePageRequest.m
//   
//  Created by alpha yu on 2024/1/23 
//   
   

#import "NetworkBasePageRequest.h"

@implementation NetworkBasePageRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageNum = TableViewDataFirstPageIndex;
        _pageSize = TableViewDataDefaultPageSize;
    }
    return self;
}

@end
