//
//  AYPopupController.h
//
//  Created by alpha yu on 2020/9/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (AYPopup)

/// 弹出
- (void)popupView:(UIView *)view;

/// 收起
- (void)dismissView:(UIView *)view;

@end


typedef NS_ENUM(NSInteger, AYPopupAnimationType) {
    AYPopupAnimationTypeFade,
    AYPopupAnimationTypeSideFromBottom, ///< 从屏幕底部弹出
    AYPopupAnimationTypeSideFromLeft,   ///< 从屏幕左边弹出
    AYPopupAnimationTypeSideFromRight,  ///< 从屏幕右边弹出
};

typedef NS_ENUM(NSInteger, AYPopupAlign) {
    AYPopupAlignTopLeft = 0,  ///< 左上
    AYPopupAlignTopCenter,    ///< 中上
    AYPopupAlignTopRight,     ///< 右上
    
    AYPopupAlignCenterLeft,   ///< 中左
    AYPopupAlignCenter,       ///< 正中
    AYPopupAlignCenterRight,  ///< 中右
    
    AYPopupAlignBottomLeft,   ///< 左下
    AYPopupAlignBottomCenter, ///< 中下
    AYPopupAlignBottomRight,  ///< 右下
};

/// 被弹窗视图配置
@interface UIView (AYPopup)

@property (nonatomic, assign) AYPopupAnimationType animationType;

@property (nonatomic, assign) CGPoint popupPoint;           ///< 弹出锚点（仅 AYPopupAnimationTypeFade 有效）
@property (nonatomic, assign) AYPopupAlign popupAlign;      ///< 弹出对齐（仅 AYPopupAnimationTypeFade 有效）

// 强制设置宽高，用于没有自身宽高的视图
@property (nonatomic, assign) CGFloat popupFixedWidth;      ///< 固定宽度（为0时，忽略这个属性）
@property (nonatomic, assign) CGFloat popupFixedHeight;     ///< 固定高度（为0时，忽略这个属性）

@property (nonatomic, strong, readonly) UIView *dimView;    ///< 背景视图
@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapDimViewToDismissGesture; ///< 点击背景视图收起手势
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panToDismissGesture;        ///< 拖动收起手势(仅对从屏幕边缘弹出有效)

@property (nonatomic, copy, nullable) void (^popupCompletedBlock)(void);
@property (nonatomic, copy, nullable) void (^dismissCompletedBlock)(void);

@end

NS_ASSUME_NONNULL_END
