//
//  AppTabBarItemView.h
//
//  Created by linxj on 2022/11/9.
//

#import "TitleImageButton.h"
#import "BadgeView.h"

NS_ASSUME_NONNULL_BEGIN

/// 自定义TabBar item
@interface AppTabBarItemView : TitleImageButton

@property (nonatomic, strong, readonly) BadgeView *badgeView;

@end

NS_ASSUME_NONNULL_END
