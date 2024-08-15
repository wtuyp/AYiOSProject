//
//  AppTabBar.h
//
//  Created by alpha yu on 2022/11/9.
//

#import <UIKit/UIKit.h>
#import "AppTabBarItemConfig.h"

NS_ASSUME_NONNULL_BEGIN

/// 自定义TabBar
@interface AppTabBar : UIView

@property (nonatomic, copy) NSArray<AppTabBarItemConfig *> *itemConfigArray;
@property (nonatomic, copy) void (^selectedItemBlock)(NSInteger tag);
@property (nonatomic, assign) NSInteger selectedItemTag;

@end

NS_ASSUME_NONNULL_END
