//
//  UIUtils.m
//
//  Created by linxj on 2022/11/11.
//

#import "UIUtils.h"

@implementation UIViewController (UIUtils)

- (nullable UIViewController *)visibleViewControllerIfExist {
    if (self.presentedViewController) {
        return [self.presentedViewController visibleViewControllerIfExist];
    }

    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).visibleViewController visibleViewControllerIfExist];
    }

    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController visibleViewControllerIfExist];
    }
    
//    if (self.childViewControllers.count > 0) {
//        return [self.childViewControllers.lastObject visibleViewControllerIfExist];
//    }

//    if ([self isViewLoadedAndVisible]) {
//        return self;
//    } else {
//        return nil;
//    }
    
    return self;
}

- (BOOL)isViewLoadedAndVisible {
    if (!self.isViewLoaded) {
        return NO;
    }
    
    if (self.view.hidden || self.view.alpha <= 0.01) {
        return NO;
    }
    
    if (self.view.window) {
        return YES;
    }
    
    if ([self isKindOfClass:UIWindow.class]) {
        if (@available(iOS 13.0, *)) {
            return !!((UIWindow *)self).windowScene;
        } else {
            return YES;
        }
    }
    
    return NO;
}

@end


@implementation UIUtils

+ (UINavigationController *)getNavigationController {
    UINavigationController *navi = self.visibleViewController.navigationController;
    if (!navi) {
        UIWindow *window = [self keywindow];
        if ([window.rootViewController isKindOfClass:UINavigationController.class]) {
            navi = (UINavigationController *)window.rootViewController;
        } else if ([window.rootViewController isKindOfClass:UITabBarController.class]) {
            UIViewController *selected = ((UITabBarController *)window.rootViewController).selectedViewController;
            if ([selected isKindOfClass:UINavigationController.class]) {
                navi = (UINavigationController *)selected;
            }
        }
    }
    return navi;
}

+ (UIViewController *)visibleViewController {
    UIViewController *rootViewController = [self rootViewController];
    UIViewController *visibleViewController = [rootViewController visibleViewControllerIfExist];
    return visibleViewController;
}

+ (UIViewController *)rootViewController {
    return [self keywindow].rootViewController;
}

+ (UIWindow *)keywindow {
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) { // 运行时检查系统版本（兼容不同版本的系统，防止运行报错）
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
        }
    }
        
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].windows.firstObject;
        if (!keyWindow.isKeyWindow) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            if (CGRectEqualToRect(window.bounds, UIScreen.mainScreen.bounds)) {
                keyWindow = window;
            }
        }
    }
    
    return keyWindow;
}



@end
