//
//  UINavigationController+AppCategory.h
//
//  Created by alpha yu on 2019/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (AppCategory)

/// 移除指定控制器
- (void)removeController:(UIViewController *)controller;

/// 根据控制器类型，返回到某个控制器
- (nullable NSArray<__kindof UIViewController *> *)popToControllerWithClass:(Class)controllerClass animated:(BOOL)animated;

/// 弹出几个控制器
- (nullable NSArray<__kindof UIViewController *> *)popViewControllersWithCount:(NSInteger)popCount animated:(BOOL)animated;

/// 移除中间顶部的几个控制器 (不会移除第一个和最后一个控制器)
- (void)removeMiddleTopViewControllersWithCount:(NSUInteger)count;

@end

NS_ASSUME_NONNULL_END
