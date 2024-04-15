//
//  UIViewController+BaseNavi.h
//
//  Created by alpha yu on 2023/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (BaseNavi)

@property (nonatomic, assign) BOOL backBarButtonHidden;     ///< 隐藏返回键
@property (nonatomic, assign) BOOL interactivePopDisabled;  ///< 禁用边缘拉动返回

/// 自定义返回动作。返回YES时，可执行pop
- (BOOL)backBarButtonAction;

@end

NS_ASSUME_NONNULL_END
