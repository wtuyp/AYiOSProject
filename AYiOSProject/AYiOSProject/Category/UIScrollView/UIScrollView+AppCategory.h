//   
//   UIScrollView+AppCategory.h
//   
//   Created by alpha yu on 2023/3/30 
//   
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (AppCategory)

// 直接把子视图加入hContainerView/vContainerView中，最后记得设置right/bottom约束
@property (nonatomic, strong, readonly) UIView *hContainerView; ///< 水平滚动容器
@property (nonatomic, strong, readonly) UIView *vContainerView; ///< 垂直滚动容器

@end

NS_ASSUME_NONNULL_END
