//
//  UIUtils.h
//
//  Created by linxj on 2022/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (UIUtils)

/**
 获取当前controller里的最高层可见viewController（可见的意思是还会判断self.view.window是否存在）
 @see 如果要获取当前App里的可见viewController，请使用 [UIUtils visibleViewController]
 @return 当前controller里的最高层可见viewController
 */
- (nullable UIViewController *)visibleViewControllerIfExist;

@end


@interface UIUtils : NSObject

+ (UINavigationController * _Nullable)getNavigationController;
+ (UIViewController *)visibleViewController;
+ (UIViewController *)rootViewController;
+ (UIWindow *)keywindow;

@end

NS_ASSUME_NONNULL_END
