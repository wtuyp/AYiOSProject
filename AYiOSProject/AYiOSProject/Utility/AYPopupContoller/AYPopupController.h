//
//  AYPopupController.h
//
//  Created by alpha yu on 2020/9/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AYPopupController : UIViewController

@property (nonatomic, strong, nullable) UIView *contentView;  ///< 需要显示的内容视图

@property (nonatomic, readonly) UIView *dimView;    ///< 背景视图

/// 拖动关闭手势，仅对屏幕边缘滑出的情况有效
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panToDismissGesture;


/// 弹出
- (void)popup;

/// 关闭
- (void)dismiss;
- (void)dismissWithCompletedBlock:(void (^ _Nullable)(void))block;

@end

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

typedef NS_ENUM(NSInteger, AYPopupAnimationType) {
    AYPopupAnimationTypeFade,
    AYPopupAnimationTypeSideFromBottom, ///< 从屏幕底部滑出，忽略 popupPoint / popupAlign 属性
    AYPopupAnimationTypeSideFromLeft,   ///< 从屏幕左边滑出，忽略 popupPoint / popupAlign 属性
    AYPopupAnimationTypeSideFromRight,  ///< 从屏幕右边滑出，忽略 popupPoint / popupAlign 属性
};

@interface UIView (AYPopupViewConfig)

@property (nonatomic, assign) AYPopupAnimationType animationType;

/**
 直接弹出锚点
 或者 使用下面方法 setPopupPointFromView:referenceAlign:offset: 间接设置
 */
@property (nonatomic, assign) CGPoint popupPoint;

/// 通过其他视图及相对位置，弹出锚点
- (void)setPopupPointFromView:(UIView *)view referenceAlign:(AYPopupAlign)align;
- (void)setPopupPointFromView:(UIView *)view referenceAlign:(AYPopupAlign)align offset:(CGPoint)offset;

@property (nonatomic, assign) AYPopupAlign popupAlign; ///< 对齐位置

// 强制设置宽高，特别用于没有自身宽高的视图
@property (nonatomic, assign) CGFloat popupFixedWidth;  ///< 固定宽度。设置为0时，忽略这个属性
@property (nonatomic, assign) CGFloat popupFixedHeight; ///< 固定高度。设置为0时，忽略这个属性

@property (nonatomic, strong, nullable) UIColor *popupBackgroundDimColor;   ///< 背景色
@property (nonatomic, assign) BOOL disableTouchOutToDismiss;    ///< 禁用点击视图外收起，YES 为禁用，默认为 NO

@property (nonatomic, copy, nullable) void (^popupCompletedBlock)(void);
@property (nonatomic, copy, nullable) void (^dismissCompletedBlock)(void);

/// 将视图显示在这个目标控制器上，比较少用(在 popupPoint 前设置。)
@property (nonatomic, weak, nullable) UIViewController *targetController;
//@property (nonatomic, weak, nullable) UIViewController *myController;       ///< 视图自己的控制器，是控制器的根视图一定要设置!!!

//@property (nonatomic, assign) BOOL panGestureEnable;    ///< 拖动手势，仅对屏幕边缘滑出的效果有效

@end

NS_ASSUME_NONNULL_END
