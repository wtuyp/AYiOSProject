//   
//  AYDataStateView.h
//   
//  Created by alpha yu on 2024/1/2 
//   
   

#import <UIKit/UIKit.h>
#import "AYDataStateConfig.h"

NS_ASSUME_NONNULL_BEGIN

/// 数据状态 视图
@interface AYDataStateView : UIView

@property (nonatomic, copy, readonly, nullable) NSString *state;    ///< 当前状态
@property (nonatomic, weak) UIView *attachedView;   ///< 需要依附的视图
@property (nonatomic, assign) CGPoint centerOffset; ///< 中心偏移

/// 根据状态设置自定义视图，自定义情况返回YES
@property (nonatomic, copy) BOOL (^customSubviewBlock)(AYDataStateView *selfView, NSString *state);

- (instancetype)initWithAttachedView:(UIView *)view;

/// 设置状态配置
- (void)setConfig:(AYDataStateConfig * _Nullable)config forState:(NSString *)state;
/// 获取状态配置
- (AYDataStateConfig * _Nullable)configForState:(NSString *)state;

/// 根据状态显示
- (void)showWithState:(NSString *)state;
/// 隐藏
- (void)hidden;

@end

NS_ASSUME_NONNULL_END
