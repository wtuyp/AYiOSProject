//
//  RootController.h
//
//  Created by alpha yu on 2021/11/26.
//

#import "AppBaseTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AppTabBarItem) {
    AppTabBarItemHome = 0,  // 首页
    AppTabBarItemMine,      // 我的
};

@interface RootController : AppBaseTabBarController

@end

NS_ASSUME_NONNULL_END
