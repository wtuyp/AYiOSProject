//
//  UIView+AppLayout.h
//
//  Created by alpha yu on 2023/1/26
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 布局方向
typedef NS_ENUM(NSInteger, AppLayoutDirection) {
    AppLayoutDirectionHorizontal,
    AppLayoutDirectionVertical,
};

/// 主轴对齐方式
typedef NS_ENUM(NSInteger, AppLayoutJustifyContent) {
    AppLayoutJustifyContentStart,       ///< 左对齐
    AppLayoutJustifyContentEnd,
    AppLayoutJustifyContentCenter,
    AppLayoutJustifyContentSpaceBetween,
    AppLayoutJustifyContentSpaceAround,
    AppLayoutJustifyContentSpaceEvenly,
};

/// 交叉轴对齐方式
typedef NS_ENUM(NSInteger, AppLayoutAlignItems) {
    AppLayoutAlignItemsStretch,
    AppLayoutAlignItemsStart,
    AppLayoutAlignItemsEnd,
//    AppLayoutAlignItemsCenter,
//    AppLayoutAlignItemsBaseline,
};

@interface UIView (AppLayout)

@end

@interface UIView (AppLayoutVertical)

/**
 子视图垂直左对齐布局。
 itemWidth, itemHeight 为 0，表示自适应。
 */
- (void)verticalLayoutLeftAlignSubviewsWithItemWidth:(CGFloat)itemWidth
                                          itemHeight:(CGFloat)itemHeight
                                         itemSpacing:(CGFloat)itemSpacing
                                          topSpacing:(CGFloat)topSpacing
                                       bottomSpacing:(CGFloat)bottomSpacing
                                         leadSpacing:(CGFloat)leadSpacing
                                         tailSpacing:(CGFloat)tailSpacing;

/**
 子视图垂直居中布局。(注意：容器宽度必需确定)
 itemWidth, itemHeight 为 0，表示自适应。
 */
- (void)verticalLayoutCenterAlignSubviewsWithItemWidth:(CGFloat)itemWidth
                                            itemHeight:(CGFloat)itemHeight
                                           itemSpacing:(CGFloat)itemSpacing
                                            topSpacing:(CGFloat)topSpacing
                                         bottomSpacing:(CGFloat)bottomSpacing;

/**
 子视图垂直宽度充满布局。(注意：容器宽度必需确定)
 itemHeight 为 0，表示自适应。
 */
- (void)verticalLayoutFillWidthSubviewsWithItemHeight:(CGFloat)itemHeight
                                          itemSpacing:(CGFloat)itemSpacing
                                           topSpacing:(CGFloat)topSpacing
                                        bottomSpacing:(CGFloat)bottomSpacing
                                          leadSpacing:(CGFloat)leadSpacing
                                          tailSpacing:(CGFloat)tailSpacing;

@end

@interface UIView (AppLayoutHorizontal)

/**
 子视图从左到右水平布局。
 itemWidth, itemHeight 为 0, 表示自适应。
 */
- (void)horizontalLayoutSubviewsWithItemWidth:(CGFloat)itemWidth
                                   itemHeight:(CGFloat)itemHeight
                                  itemSpacing:(CGFloat)itemSpacing
                                   topSpacing:(CGFloat)topSpacing
                                bottomSpacing:(CGFloat)bottomSpacing
                                  leadSpacing:(CGFloat)leadSpacing
                                  tailSpacing:(CGFloat)tailSpacing;

/**
 子视图等间距水平充满布局。
 itemHeight 为 0, 表示高度自适应。
 */
- (void)horizontalFillLayoutSubviewsWithItemWidth:(CGFloat)itemWidth
                                       itemHeight:(CGFloat)itemHeight
                                       topSpacing:(CGFloat)topSpacing
                                    bottomSpacing:(CGFloat)bottomSpacing
                                      leadSpacing:(CGFloat)leadSpacing
                                      tailSpacing:(CGFloat)tailSpacing;

/**
 子视图等宽水平充满布局。
 itemHeight 为 0, 表示高度自适应。
 */
- (void)horizontalFillLayoutSubviewsWithItemSpacing:(CGFloat)itemSpacing
                                         itemHeight:(CGFloat)itemHeight
                                         topSpacing:(CGFloat)topSpacing
                                      bottomSpacing:(CGFloat)bottomSpacing
                                        leadSpacing:(CGFloat)leadSpacing
                                        tailSpacing:(CGFloat)tailSpacing;

@end

@interface UIView (AppLayoutGrid)

/**
 网格布局。可配置边距。
 itemWidth        固定宽度，如果设置成0，则表示自适应
 itemHeight       固定高度，如果设置成0，则表示自适应
 lineSpacing      行间距
 interitemSpacing 列间距
 warpCount        换行点
 */
- (void)gridLayoutSubviewsWithItemWidth:(CGFloat)itemWidth
                             itemHeight:(CGFloat)itemHeight
                            lineSpacing:(CGFloat)lineSpacing
                       interitemSpacing:(CGFloat)interitemSpacing
                              warpCount:(NSInteger)warpCount
                             topSpacing:(CGFloat)topSpacing
                          bottomSpacing:(CGFloat)bottomSpacing
                            leadSpacing:(CGFloat)leadSpacing
                            tailSpacing:(CGFloat)tailSpacing;

/**
 网格布局。
 itemWidth        固定宽度，如果设置成0，则表示自适应
 itemHeight       固定高度，如果设置成0，则表示自适应
 lineSpacing      行间距
 interitemSpacing 列间距
 warpCount        换行点
 */
- (void)gridLayoutSubviewsWithItemWidth:(CGFloat)itemWidth
                             itemHeight:(CGFloat)itemHeight
                            lineSpacing:(CGFloat)lineSpacing
                       interitemSpacing:(CGFloat)interitemSpacing
                              warpCount:(NSInteger)warpCount;

@end

@interface UIView (AppLayoutAligned)

/**
 *  左对齐流式布局
 *
 *  @param itemWidthBlock   返回子视图宽度，需要手动计算
 *  @param itemHeight       子视图高度
 *  @param lineSpacing      行间距
 *  @param interitemSpacing 列间距
 *  @param maxWidth         容器最大宽度
 *  @param topSpacing       顶间距
 *  @param bottomSpacing    底间距
 *  @param leadSpacing      左间距
 *  @param tailSpacing      右间距
 */
- (void)leftAlignedLayoutSubviewsWithItemWidthBlock:(CGFloat (^)(__kindof UIView *item, NSInteger index))itemWidthBlock
                                         itemHeight:(CGFloat)itemHeight
                                        lineSpacing:(CGFloat)lineSpacing
                                   interitemSpacing:(CGFloat)interitemSpacing
                                           maxWidth:(CGFloat)maxWidth
                                         topSpacing:(CGFloat)topSpacing
                                      bottomSpacing:(CGFloat)bottomSpacing
                                        leadSpacing:(CGFloat)leadSpacing
                                        tailSpacing:(CGFloat)tailSpacing;

@end

NS_ASSUME_NONNULL_END
