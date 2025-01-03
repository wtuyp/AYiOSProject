//   
//  AYDataStateView.h
//   
//  Created by alpha yu on 2024/1/2 
//   
   

#import <UIKit/UIKit.h>
#import "AYDataStateConfig.h"

typedef NSString * AYViewDataState NS_TYPED_EXTENSIBLE_ENUM;

NS_ASSUME_NONNULL_BEGIN

/// 数据状态 视图
@interface AYDataStateView : UIView

@property (nonatomic, copy, readonly) AYViewDataState state;    ///< 当前状态
@property (nonatomic, weak) UIView *attachedView;               ///< 需要依附的视图
@property (nonatomic, assign) CGPoint centerOffset;             ///< 中心偏移

/// 根据状态设置自定义视图，自定义情况返回YES
@property (nonatomic, copy) BOOL (^customSubviewBlock)(AYDataStateView *dataStateView, AYViewDataState state);

- (instancetype)initWithAttachedView:(UIView *)view;

/// 设置状态配置
- (void)setConfig:(AYDataStateConfig * _Nullable)config forState:(AYViewDataState)state;

/// 获取状态配置
- (AYDataStateConfig * _Nullable)configForState:(AYViewDataState)state;

/// 更新状态配置
- (void)updateConfig:(void (^)(AYDataStateConfig * _Nullable config))configBlock forState:(AYViewDataState)state;

/// 根据状态显示，没有配置的状态会隐藏
- (void)showWithState:(AYViewDataState)state;

@end

NS_ASSUME_NONNULL_END
