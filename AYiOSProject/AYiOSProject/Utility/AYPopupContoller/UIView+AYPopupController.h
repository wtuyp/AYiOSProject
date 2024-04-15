//
//  UIView+AYPopupController.h
//
//  Created by alpha yu on 2021/2/4.
//

#import <UIKit/UIKit.h>
#import "AYPopupController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AYPopupController)

@property (nonatomic, readonly, nullable) AYPopupController *popupController;

/// 弹出自己
/// @param align 自己哪个位置对应view
/// @param view 从哪个视图弹出
/// @param referenceAlign 从view的哪个位置弹出
/// @param dismissCompletedBlock 消失回调
- (void)popupWithAlign:(AYPopupAlign)align
              fromView:(UIView *)view
        referenceAlign:(AYPopupAlign)referenceAlign
 dismissCompletedBlock:(void (^ _Nullable)(void))dismissCompletedBlock;

// 多了 offset
- (void)popupWithAlign:(AYPopupAlign)align
              fromView:(UIView *)view
        referenceAlign:(AYPopupAlign)referenceAlign
                offset:(CGPoint)offset
 dismissCompletedBlock:(void (^ _Nullable)(void))dismissCompletedBlock;

- (void)popupWithAlign:(AYPopupAlign)align
               atPoint:(CGPoint)point 
 dismissCompletedBlock:(void (^ _Nullable)(void))dismissCompletedBlock;

/// 从底部弹出
- (void)slideFromBottom;
/// 从底部弹出，height 为 0 时，自适应高度
- (void)slideFromBottomWithHeight:(CGFloat)height;

/// 从左边滑出
- (void)slideFromLeftWithWidth:(CGFloat)width;
/// 从右边滑出
- (void)slideFromRightWithWidth:(CGFloat)width;

/// 从中间弹出
- (void)popupAtCenter;

/// 收起
- (void)dismissPopup;
- (void)dismissPopupWithCompletedBlock:(void (^ _Nullable)(void))block;

@end

NS_ASSUME_NONNULL_END
