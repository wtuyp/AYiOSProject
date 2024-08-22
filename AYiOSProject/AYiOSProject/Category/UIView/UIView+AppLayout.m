//
//  UIView+AppLayout.m
//
//  Created by alpha yu on 2023/1/26
//

#import "UIView+AppLayout.h"

@implementation UIView (AppLayout)

@end

@implementation UIView (AppLayoutVertical)

- (void)verticalLayoutLeftAlignSubviewsWithItemWidth:(CGFloat)itemWidth
                                          itemHeight:(CGFloat)itemHeight
                                         itemSpacing:(CGFloat)itemSpacing
                                          topSpacing:(CGFloat)topSpacing
                                       bottomSpacing:(CGFloat)bottomSpacing
                                         leadSpacing:(CGFloat)leadSpacing
                                         tailSpacing:(CGFloat)tailSpacing {
    if (self.subviews.count < 1) {
        return;
    }
    
    UIView *prev = nil;
    for (NSInteger currentRow = 0; currentRow < self.subviews.count; currentRow++) {
        UIView *view = self.subviews[currentRow];
        
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leadSpacing);
            if (itemWidth) {
                make.width.mas_equalTo(itemWidth);
                make.right.mas_lessThanOrEqualTo(-tailSpacing);
            } else {
                make.right.mas_equalTo(-tailSpacing);
            }
            if (itemHeight) {
                make.height.mas_equalTo(itemHeight);
            }

            if (currentRow == 0) {  // 第一行
                make.top.mas_equalTo(topSpacing);
            }
            if (currentRow == self.subviews.count - 1) {    // 最后一行
                make.bottom.mas_lessThanOrEqualTo(-bottomSpacing);
            }
            if (currentRow != 0) { // 非第一行
                make.top.equalTo(prev.mas_bottom).offset(itemSpacing);
            }
        }];
        prev = view;
    }
}

- (void)verticalLayoutLeftAlignSubviewsWithItemWidth:(CGFloat)itemWidth
                                          itemHeight:(CGFloat)itemHeight
                                         itemSpacing:(CGFloat)itemSpacing {
    [self verticalLayoutLeftAlignSubviewsWithItemWidth:itemWidth itemHeight:itemHeight itemSpacing:itemSpacing topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)verticalLayoutSubviewsWithItemHeight:(CGFloat)itemHeight
                                 itemSpacing:(CGFloat)itemSpacing
                                  topSpacing:(CGFloat)topSpacing
                               bottomSpacing:(CGFloat)bottomSpacing
                                 leadSpacing:(CGFloat)leadSpacing
                                 tailSpacing:(CGFloat)tailSpacing {
    [self verticalLayoutLeftAlignSubviewsWithItemWidth:0 itemHeight:itemHeight itemSpacing:itemSpacing topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)verticalLayoutSubviewsWithItemHeight:(CGFloat)itemHeight
                                 itemSpacing:(CGFloat)itemSpacing {
    [self verticalLayoutSubviewsWithItemHeight:itemHeight itemSpacing:itemSpacing topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)verticalLayoutCenterAlignSubviewsWithItemWidth:(CGFloat)itemWidth
                                            itemHeight:(CGFloat)itemHeight
                                           itemSpacing:(CGFloat)itemSpacing
                                            topSpacing:(CGFloat)topSpacing
                                         bottomSpacing:(CGFloat)bottomSpacing {
    if (self.subviews.count < 1) {
        return;
    }
    
    UIView *prev = nil;
    for (NSInteger currentRow = 0; currentRow < self.subviews.count; currentRow++) {
        UIView *view = self.subviews[currentRow];
        
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            if (itemWidth) {
                make.width.mas_equalTo(itemWidth);
            }
            if (itemHeight) {
                make.height.mas_equalTo(itemHeight);
            }

            if (currentRow == 0) {  // 第一行
                make.top.mas_equalTo(topSpacing);
            }
            if (currentRow == self.subviews.count - 1) {    // 最后一行
                make.bottom.mas_lessThanOrEqualTo(-bottomSpacing);
            }
            if (currentRow != 0) { // 非第一行
                make.top.equalTo(prev.mas_bottom).offset(itemSpacing);
            }
        }];
        prev = view;
    }
}

@end

@implementation UIView (AppLayoutHorizontal)

- (void)horizontalLayoutSubviewsWithItemWidth:(CGFloat)itemWidth
                                   itemHeight:(CGFloat)itemHeight
                                  itemSpacing:(CGFloat)itemSpacing
                                   topSpacing:(CGFloat)topSpacing
                                bottomSpacing:(CGFloat)bottomSpacing
                                  leadSpacing:(CGFloat)leadSpacing
                                  tailSpacing:(CGFloat)tailSpacing {
    if (self.subviews.count < 1) {
        return;
    }
                
    UIView *prev;
    for (NSInteger index = 0; index < self.subviews.count; index++) {
        UIView *view = self.subviews[index];
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.top.mas_greaterThanOrEqualTo(topSpacing);
            make.bottom.mas_lessThanOrEqualTo(-bottomSpacing);
            if (itemWidth) {
                make.width.mas_equalTo(itemWidth);
            }
            if (itemHeight) {
                make.height.mas_equalTo(itemHeight);
            }
            
            if (index == 0) {   // 第一列
                make.left.mas_equalTo(leadSpacing);
            }
            if (index == self.subviews.count - 1) { // 最后一列
                make.right.mas_lessThanOrEqualTo(-tailSpacing);
            }
            if (index != 0) {   // 非第一列
                make.left.equalTo(prev.mas_right).offset(itemSpacing);
            }
        }];
        prev = view;
    }
}

- (void)horizontalLayoutSubviewsWithItemWidth:(CGFloat)itemWidth
                                   itemHeight:(CGFloat)itemHeight
                                  itemSpacing:(CGFloat)itemSpacing {
    [self horizontalLayoutSubviewsWithItemWidth:itemWidth itemHeight:itemHeight itemSpacing:itemSpacing topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)horizontalFillLayoutSubviewsWithItemWidth:(CGFloat)itemWidth
                                       itemHeight:(CGFloat)itemHeight
                                       topSpacing:(CGFloat)topSpacing
                                    bottomSpacing:(CGFloat)bottomSpacing
                                      leadSpacing:(CGFloat)leadSpacing
                                      tailSpacing:(CGFloat)tailSpacing {
    if (self.subviews.count < 1) {
        return;
    }
    
    [self.subviews mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.top.mas_greaterThanOrEqualTo(topSpacing);
        make.bottom.mas_lessThanOrEqualTo(-bottomSpacing);
        if (itemWidth) {
            make.height.mas_equalTo(itemWidth);
        }
        if (itemHeight) {
            make.height.mas_equalTo(itemHeight);
        }
    }];
    [self.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:itemWidth leadSpacing:leadSpacing tailSpacing:tailSpacing];
}

- (void)horizontalFillLayoutSubviewsWithItemWidth:(CGFloat)itemWidth
                                       itemHeight:(CGFloat)itemHeight {
    [self horizontalFillLayoutSubviewsWithItemWidth:itemWidth itemHeight:itemHeight topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)horizontalFillLayoutSubviewsWithItemSpacing:(CGFloat)itemSpacing
                                         itemHeight:(CGFloat)itemHeight
                                         topSpacing:(CGFloat)topSpacing
                                      bottomSpacing:(CGFloat)bottomSpacing
                                        leadSpacing:(CGFloat)leadSpacing
                                        tailSpacing:(CGFloat)tailSpacing {
    if (self.subviews.count < 1) {
        return;
    }
    
    [self.subviews mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo((topSpacing - bottomSpacing) / 2.0);
        make.top.mas_greaterThanOrEqualTo(topSpacing);
        make.bottom.mas_lessThanOrEqualTo(-bottomSpacing);
        if (itemHeight) {
            make.height.mas_equalTo(itemHeight);
        }
    }];
    [self.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:itemSpacing leadSpacing:leadSpacing tailSpacing:tailSpacing];
}

- (void)horizontalFillLayoutSubviewsWithItemSpacing:(CGFloat)itemSpacing
                                         itemHeight:(CGFloat)itemHeight {
    [self horizontalFillLayoutSubviewsWithItemSpacing:itemSpacing itemHeight:itemHeight topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)horizontalFillLayoutSubviewsWithItemSpacing:(CGFloat)itemSpacing
                                         topSpacing:(CGFloat)topSpacing
                                      bottomSpacing:(CGFloat)bottomSpacing
                                        leadSpacing:(CGFloat)leadSpacing
                                        tailSpacing:(CGFloat)tailSpacing {
    if (self.subviews.count < 1) {
        return;
    }
    
    [self.subviews mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topSpacing);
        make.bottom.mas_equalTo(-bottomSpacing);
    }];
    [self.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:itemSpacing leadSpacing:leadSpacing tailSpacing:tailSpacing];
}

- (void)horizontalFillLayoutSubviewsWithItemSpacing:(CGFloat)itemSpacing {
    [self horizontalFillLayoutSubviewsWithItemSpacing:itemSpacing topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)horizontalFillLayoutSubviews {
    [self horizontalFillLayoutSubviewsWithItemSpacing:0 topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}


@end

@implementation UIView (AppLayoutGrid)

- (void)gridLayoutSubviewsWithItemWidth:(CGFloat)itemWidth
                             itemHeight:(CGFloat)itemHeight
                            lineSpacing:(CGFloat)lineSpacing
                       interitemSpacing:(CGFloat)interitemSpacing
                              warpCount:(NSInteger)warpCount
                             topSpacing:(CGFloat)topSpacing
                          bottomSpacing:(CGFloat)bottomSpacing
                            leadSpacing:(CGFloat)leadSpacing
                            tailSpacing:(CGFloat)tailSpacing {
    NSArray *subviews = self.subviews;
    if (subviews.count < 1) {
        return;
    }
    if (warpCount < 1) {
        NSAssert(NO, @"warp count need to bigger than zero");
        return;
    }
        
    NSInteger rowCount = subviews.count % warpCount == 0 ? subviews.count / warpCount : subviews.count / warpCount + 1;
    MAS_VIEW *prev = nil;
    for (NSInteger i = 0; i < subviews.count; i++) {
        MAS_VIEW *itemView = subviews[i];
        NSInteger currentRow = i / warpCount;
        NSInteger currentColumn = i % warpCount;
        
        [itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (prev) { // 固定宽度
                make.width.equalTo(prev);
                make.height.equalTo(prev);
            } else {
                // 如果写的item高宽分别是0，则表示自适应
                if (itemWidth) {
                    make.width.mas_equalTo(itemWidth);
                }
                if (itemHeight) {
                    make.height.mas_equalTo(itemHeight);
                }
            }
            
            if (currentRow == 0) {  // 第一行
                make.top.mas_equalTo(topSpacing);
            }
            if (currentRow == rowCount - 1) {   // 最后一行
                if (currentRow != 0 && i-warpCount >= 0) {  // 如果只有一行
                    make.top.equalTo(((MAS_VIEW *)subviews[i-warpCount]).mas_bottom).offset(lineSpacing);
                }
                make.bottom.mas_equalTo(-bottomSpacing);
            }
            if (currentRow != 0 && currentRow != rowCount - 1) {    // 中间的若干行
                make.top.equalTo(((MAS_VIEW *)subviews[i-warpCount]).mas_bottom).offset(lineSpacing);
            }
            
            if (currentColumn == 0) {   // 第一列
                make.left.mas_equalTo(leadSpacing);
            }
            if (currentColumn == warpCount - 1) {   // 最后一列
                if (currentColumn != 0) {   // 如果只有一列
                    make.left.equalTo(prev.mas_right).offset(interitemSpacing);
                }
                make.right.mas_equalTo(-tailSpacing);
            }
            if (currentColumn != 0 && currentColumn != warpCount - 1) { // 中间若干列
                make.left.equalTo(prev.mas_right).offset(interitemSpacing);
            }
        }];
        prev = itemView;
    }
}

- (void)gridLayoutSubviewsWithItemWidth:(CGFloat)itemWidth
                             itemHeight:(CGFloat)itemHeight
                            lineSpacing:(CGFloat)lineSpacing
                       interitemSpacing:(CGFloat)interitemSpacing
                              warpCount:(NSInteger)warpCount {
    [self gridLayoutSubviewsWithItemWidth:itemWidth
                               itemHeight:itemHeight
                              lineSpacing:lineSpacing
                         interitemSpacing:interitemSpacing
                                warpCount:warpCount
                               topSpacing:0
                            bottomSpacing:0
                              leadSpacing:0
                              tailSpacing:0];
}

@end

@implementation UIView (AppLayoutAligned)

- (void)leftAlignedLayoutSubviewsWithItemWidthBlock:(CGFloat (^)(__kindof UIView *item, NSInteger index))itemWidthBlock
                                         itemHeight:(CGFloat)itemHeight
                                        lineSpacing:(CGFloat)lineSpacing
                                   interitemSpacing:(CGFloat)interitemSpacing
                                           maxWidth:(CGFloat)maxWidth
                                         topSpacing:(CGFloat)topSpacing
                                      bottomSpacing:(CGFloat)bottomSpacing
                                        leadSpacing:(CGFloat)leadSpacing
                                        tailSpacing:(CGFloat)tailSpacing {
    if (self.subviews.count < 1) {
        return;
    }
    
    CGFloat itemLeft = leadSpacing;
    CGFloat itemTop = topSpacing;
    
    for (NSInteger index = 0; index < self.subviews.count; index++) {
        MAS_VIEW *itemView = self.subviews[index];
        
        CGFloat itemWidth = itemWidthBlock(itemView, index);        
        if (itemLeft > leadSpacing && (itemLeft + itemWidth + tailSpacing > maxWidth)) {
            itemLeft = leadSpacing;
            itemTop += (itemHeight + lineSpacing);
        }
        if (itemLeft == leadSpacing && (leadSpacing + itemWidth + tailSpacing > maxWidth)) {
            itemWidth = maxWidth - leadSpacing - tailSpacing;
        }
        
        [itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(itemLeft);
            make.top.mas_equalTo(itemTop);
            if (index == self.subviews.count - 1) {
                make.bottom.mas_equalTo(-bottomSpacing);
            }
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(itemHeight);
        }];
        
        itemLeft += (itemWidth + interitemSpacing);
    }
}

@end
