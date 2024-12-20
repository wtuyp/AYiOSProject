//   
//  UIView+AppPopup.h
//   
//  Created by alpha yu on 2024/12/17 
//   
   

#import "AYPopupController.h"

NS_ASSUME_NONNULL_BEGIN

/// 弹窗分类，根据业务需求调整代码
@interface UIView (AppPopup)

@property (nonatomic, weak, nullable) UIViewController *targetController;   ///< 目标控制器（在这个控制器上弹出，默认 rootViewController）

/// 根据位置弹出
- (void)popupWithAlign:(AYPopupAlign)align
               atPoint:(CGPoint)point;

/// 根据目标视图位置弹出
/// @param align 自己的对齐位置
/// @param view 从这个视图弹出
/// @param viewAlign fromView 的对齐位置
- (void)popupWithAlign:(AYPopupAlign)align
              fromView:(UIView *)view
             viewAlign:(AYPopupAlign)viewAlign;

/// 根据目标视图位置弹出
/// @param align 自己的对齐位置
/// @param view 从这个视图弹出
/// @param viewAlign fromView 的对齐位置
/// @param offset 偏移量
- (void)popupWithAlign:(AYPopupAlign)align
              fromView:(UIView *)view
             viewAlign:(AYPopupAlign)viewAlign
                offset:(CGPoint)offset;

/// 从中间弹出
- (void)popupAtCenter;

/// 从底部弹出
- (void)slideFromBottom;

/// 从底部弹出（height 传 0 时，自适应高度）
- (void)slideFromBottomWithHeight:(CGFloat)height;

/// 从左边弹出
- (void)slideFromLeftWithWidth:(CGFloat)width;

/// 从右边弹出
- (void)slideFromRightWithWidth:(CGFloat)width;

/// 收起
- (void)dismissPopup;

/*
 有时候弹窗有文本输入且会被键盘遮挡，
 如果在使用第三方键盘监听时，背后的视图会出现了偏移。
 先考虑弹窗内是否要加个 ScrollView 容器，
 再考虑是否监听键盘去调整弹窗布局。
 */
/// 注册键盘监听（调用前先禁用第三方键盘控制）
- (void)registerKeyboardObserverWithWillShowBlock:(void (^)(NSTimeInterval animationDuration,
                                                            UIViewAnimationOptions animationOptions,
                                                            CGRect keyboardFrame))willShowBlock
                                    willHideBlock:(void (^)(NSTimeInterval animationDuration,
                                                            UIViewAnimationOptions animationOptions,
                                                            CGRect keyboardFrame))willHideBlock;

/// 注册键盘监听，令弹窗底部始终在键盘顶部之上（调用前先禁用第三方键盘控制）
- (void)alwaysKeepViewBottomAboveKeyboardTop;

@end

NS_ASSUME_NONNULL_END
