//
//  AppBaseNavigationController.m
//
//  Created by MMM on 2021/11/26.
//

#import "AppBaseNavigationController.h"

@interface AppBaseNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate, UINavigationBarDelegate>

@end


@implementation AppBaseNavigationController

+ (void)initialize {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
    UIImage *image = [NAVI_BAR_BACK_IMAGE imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
    
    UIColor *backgroundColor = NAVI_BAR_COLOR;
    UIFont *titleFont = NAVI_BAR_TITLE_FONT;
    UIColor *titleColor = NAVI_BAR_TITLE_COLOR;
    
    BOOL hiddenShadow = YES;
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = backgroundColor;
        if (hiddenShadow) {
            appearance.shadowColor = nil;
            appearance.shadowImage = [[UIImage alloc] init];
        }
        
        appearance.titleTextAttributes = @{
            NSFontAttributeName: titleFont,
            NSForegroundColorAttributeName: titleColor,
        };
        [appearance setBackIndicatorImage:image transitionMaskImage:image];
        
        navigationBar.standardAppearance = appearance;
        navigationBar.compactAppearance = appearance;
        navigationBar.scrollEdgeAppearance = appearance;
    } else {
        navigationBar.barTintColor = backgroundColor;
        navigationBar.titleTextAttributes = @{
            NSFontAttributeName: titleFont,
            NSForegroundColorAttributeName: titleColor,
        };
        // 自定义返回图片
        navigationBar.backIndicatorImage = image;
        navigationBar.backIndicatorTransitionMaskImage = image;
        // 隐藏导航栏底部的线
        if (hiddenShadow) {
            [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
            [navigationBar setShadowImage:[[UIImage alloc] init]];
        }
    }
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    __weak typeof(self) wkself = self;
    self.delegate = wkself;
    
    // 禁用全屏返回
    self.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

#pragma mark - Override

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:nil
                                                             style:UIBarButtonItemStylePlain
                                                            target:nil
                                                            action:nil];
    rootViewController.navigationItem.backBarButtonItem = item;
    return [super initWithRootViewController:rootViewController];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:nil
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
        viewController.navigationItem.backBarButtonItem = item;
        
        if (viewController.backBarButtonHidden) {
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
        }
    }
    [super pushViewController:viewController animated:animated];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    if (viewControllers.count > 1) {
        UIViewController *vc = viewControllers.lastObject;
        vc.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:nil
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
        vc.navigationItem.backBarButtonItem = item;
        
        if (vc.backBarButtonHidden) {
            vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
        }
    }
    [super setViewControllers:viewControllers animated:animated];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count == 1) {
        // 解决根视图左滑页面卡死
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
    } else {
        if (viewController.backBarButtonHidden || viewController.interactivePopDisabled) {
            self.interactivePopGestureRecognizer.delegate = nil;
            self.interactivePopGestureRecognizer.enabled = NO;
        } else {
            self.interactivePopGestureRecognizer.delegate = self;
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
}

#pragma mark - UINavigationBarDelegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if(self.viewControllers.count < navigationBar.items.count) {
        return YES;
    }

    UIViewController *viewController = [self topViewController];
    if ([viewController respondsToSelector:@selector(backBarButtonAction)]) {
        return [viewController backBarButtonAction];
    }
    
    return YES;
}

@end
