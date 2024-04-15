//
//  RootController.m
//
//  Created by alpha yu on 2021/11/26.
//

#import "RootController.h"
#import "AppTabBarItemConfig.h"
#import "BaseNavigationController.h"
#import "HomeController.h"
#import "AccountInfoController.h"
#import "MineController.h"

@interface RootController ()

@end


@implementation RootController

#pragma mark - lift

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

#pragma mark - override

- (NSArray *)tabBarControllers {
    HomeController *vc1 = [[HomeController alloc] init];
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:vc1];
    nav1.app_tabBarItemConfig = [AppTabBarItemConfig configWithTitle:@"首页" image:IMAGE(@"tabbar_home_normal") selectedImage:IMAGE(@"tabbar_home_selected") tag:AppTabBarItemHome];

    MineController *vc2 = [[MineController alloc] init];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:vc2];
    nav2.app_tabBarItemConfig = [AppTabBarItemConfig configWithTitle:@"我的" image:IMAGE(@"tabbar_mine_normal") selectedImage:IMAGE(@"tabbar_mine_selected") tag:AppTabBarItemMine];
    
    return @[nav1, nav2];
}

@end
