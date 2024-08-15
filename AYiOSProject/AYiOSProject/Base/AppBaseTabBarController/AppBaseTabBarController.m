//   
//  AppBaseTabBarController.m
//   
//  Created by alpha yu on 2024/3/19 
//   
   

#import "AppBaseTabBarController.h"
#import "AppTabBar.h"
#import "AppTabBarItemConfig.h"

@interface AppBaseTabBarController ()

@property (nonatomic, strong) AppTabBar *customTabBar;
@property (nonatomic, strong) UIVisualEffectView *effectView;

@end

@implementation AppBaseTabBarController

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllers = [self tabBarControllers];
    [self initTabBar];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.tabBar bringSubviewToFront:self.customTabBar];
    [self.tabBar sendSubviewToBack:self.effectView];
}

#pragma mark - init

- (void)initTabBar {
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *barAppearance = [[UITabBarAppearance alloc] init];
        barAppearance.backgroundColor = TAB_BAR_COLOR;
        barAppearance.backgroundEffect = nil;
        barAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.clearColor;
        barAppearance.stackedLayoutAppearance.normal.titleTextAttributes = @{
            NSForegroundColorAttributeName: UIColor.clearColor
        };
        barAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.clearColor;
        barAppearance.stackedLayoutAppearance.selected.titleTextAttributes = @{
            NSForegroundColorAttributeName: UIColor.clearColor
        };
        barAppearance.stackedLayoutAppearance.focused.iconColor = UIColor.clearColor;
        barAppearance.stackedLayoutAppearance.focused.titleTextAttributes = @{
            NSForegroundColorAttributeName: UIColor.clearColor
        };

        self.tabBar.standardAppearance = barAppearance;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = barAppearance;
        }
        
        self.tabBar.tintColor = UIColor.clearColor;
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.clearColor} forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.clearColor} forState:UIControlStateSelected];
    } else {
        self.tabBar.backgroundColor = TAB_BAR_COLOR;
        self.tabBar.barTintColor = TAB_BAR_COLOR;
        self.tabBar.tintColor = UIColor.clearColor;

        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.clearColor} forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.clearColor} forState:UIControlStateSelected];
    }
    
    [self.tabBar removeAllSubviews];
    [self.tabBar addSubview:self.customTabBar];
    [self.tabBar addSubview:self.effectView];
    
    self.customTabBar.itemConfigArray = [self.viewControllers jk_map:^id(UIViewController *object) {
        return object.app_tabBarItemConfig;
    }];
    
    UIViewController *vc = self.viewControllers.firstObject;
    self.customTabBar.selectedItemTag = vc.app_tabBarItemConfig.tag;
}

#pragma mark - getter

- (AppTabBar *)customTabBar {
    if (!_customTabBar) {
        _customTabBar = [[AppTabBar alloc] initWithFrame:self.tabBar.bounds];
        _customTabBar.backgroundColor = TAB_BAR_COLOR;

        WEAK_SELF
        _customTabBar.selectedItemBlock = ^(NSInteger tag) {
            STRONG_SELF
            [self switchItemToTag:tag];
        };
    }
    return _customTabBar;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, TAB_BAR_HEIGHT);
    }
    return _effectView;
}

#pragma mark - public

- (NSArray *)tabBarControllers {
    return nil;
}

- (void)switchItemToTag:(NSInteger)tag {
    BOOL canSwitch = [self canSwitchItemToTag:tag];
    if (!canSwitch) {
        return;
    }
    
    if (self.customTabBar.selectedItemTag == tag) {
        return;
    }
    
    self.customTabBar.selectedItemTag = tag;
    self.selectedViewController = [self selectedControllerWithTag:tag];
    [self.tabBar bringSubviewToFront:self.customTabBar];    // 始终保持在最前面
}

- (NSInteger)selectedItemTag {
    return self.customTabBar.selectedItemTag;
}

// 是否可以切换
- (BOOL)canSwitchItemToTag:(NSInteger)tag {
    return YES;
}

#pragma mark - private


- (UIViewController *)selectedControllerWithTag:(NSInteger)tag {
    for (UIViewController *vc in self.viewControllers) {
        if (tag == vc.app_tabBarItemConfig.tag) {
            return vc;
        }
    }
    
    return nil;
}


@end
