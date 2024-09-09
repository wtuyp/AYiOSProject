//   
//  AppBaseTabBarController.h
//   
//  Created by alpha yu on 2024/3/19 
//   
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// TabBar 基类
@interface AppBaseTabBarController : UITabBarController

@property (nonatomic, assign, readonly) NSInteger selectedItemTag;

/// 配置子控制器，子类重写，要设置控制器的 AppTabBarItemConfig（重要）
- (NSArray<__kindof UIViewController *> *)tabBarControllers;

/// 是否可以切换，子类重写
- (BOOL)canSwitchItemToTag:(NSInteger)tag;

/// 切换
- (void)switchItemToTag:(NSInteger)tag;

@end

@interface UIViewController (AppBaseTabBarController)

@property (nonatomic, readonly) AppBaseTabBarController *app_baseTabBarController;

@end

NS_ASSUME_NONNULL_END
