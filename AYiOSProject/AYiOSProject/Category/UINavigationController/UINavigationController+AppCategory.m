//
//  UINavigationController+AppCategory.m
//
//  Created by alpha yu on 2019/8/13.
//

#import "UINavigationController+AppCategory.h"

@implementation UINavigationController (AppCategory)

- (void)removeController:(UIViewController *)controller {
    if (!controller) {
        return;
    }
    
    NSMutableArray *controllers = [self.viewControllers mutableCopy];
    [controllers removeObject:controller];
    self.viewControllers = controllers;
}

- (nullable NSArray<__kindof UIViewController *> *)popToControllerWithClass:(Class)controllerClass animated:(BOOL)animated {
    __block UIViewController *vc = nil;
    [self.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:controllerClass]) {
            vc = obj;
            *stop = YES;
        }
    }];
    
    return [self popToViewController:vc animated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)popViewControllersWithCount:(NSInteger)popCount animated:(BOOL)animated {
    NSInteger count = self.viewControllers.count;
    if (count > popCount) {
        NSInteger idx = count - popCount - 1;
        UIViewController *viewController = self.viewControllers[idx];
        return [self popToViewController:viewController animated:animated];
    } else {
        return [self popToRootViewControllerAnimated:animated];
    }
}

- (void)removeMiddleTopViewControllersWithCount:(NSUInteger)count {
    if (count == 0) {
        return;
    }
    
    NSMutableArray *viewControllers = [self.viewControllers mutableCopy];
    NSUInteger controllersCount = viewControllers.count;
    
    if (count > (controllersCount - 2)) {   // 移除数量大于中间的控制器数量时，设置最大移除数量
        count = controllersCount - 2;
    }
    
    [viewControllers removeObjectsInRange:NSMakeRange(controllersCount - count - 1, count)];
    self.viewControllers = viewControllers;
}

@end
