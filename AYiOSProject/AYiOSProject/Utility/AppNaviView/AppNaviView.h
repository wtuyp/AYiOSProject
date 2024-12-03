//   
//   AppNaviView.h
//   
//   Created by alpha yu on 2023/5/12 
//   
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 自定义导航栏
@interface AppNaviView : UIView

@property (nonatomic, strong, readonly) UIView *backgroundView; ///< 导航栏背景视图，用于调整颜色、透明度等
@property (nonatomic, strong, readonly) UIView *naviBar;        ///< 导航栏内容视图，用于增加功能按键等

@property (nonatomic, strong, readonly) UIButton *backBtn;      ///< 返回按键。默认动作 popController
@property (nonatomic, strong, nullable) UIImage *backBtnImage;  ///< 返回按键图片
@property (nonatomic, strong, nullable) UIColor *backBtnColor;  ///< 返回按键颜色
@property (nonatomic, copy, nullable) BOOL (^backBtnActionBlock)(void); ///< 自定义返回动作。返回YES时，可自动调用 popController

@property (nonatomic, strong, readonly) UILabel *titleLabel;    ///< 标题
@property (nonatomic, copy, nullable) NSString *title;          ///< 标题内容
@property (nonatomic, strong, nullable) UIColor *titleColor;    ///< 标题颜色

@property (nonatomic, weak, readonly) UIViewController *targetController;   /// 目标控制器
- (void)addToController:(UIViewController *)controller;

@end

@interface UIViewController (AppNaviView)

@property (nonatomic, strong, readonly) AppNaviView *naviView;

- (void)addNaviViewAndConfig:(void (^ _Nullable)(AppNaviView *naviView))configBlock;

@end


typedef NSInteger AppViewLevel NS_TYPED_EXTENSIBLE_ENUM;

UIKIT_EXTERN const AppViewLevel AppViewLevelNaviView;   ///< 1000，自定义导航栏层级
UIKIT_EXTERN const AppViewLevel AppViewLevelAlert;      ///< 2000，用于显示在自定义导航栏之上的视图

@interface UIView (AppViewLevel)

@property (nonatomic, assign) AppViewLevel viewLevel;    ///< 视图层级，默认 0

@end

NS_ASSUME_NONNULL_END
