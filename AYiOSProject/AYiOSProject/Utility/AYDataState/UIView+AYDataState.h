//
//  UIView+AYDataState.h
//
//  Created by alpha yu on 2024/1/2
//   
   

#import <UIKit/UIKit.h>
#import "AYDataStateView.h"

NS_ASSUME_NONNULL_BEGIN

extern AYViewDataState const AYViewDataStateHidden;     ///< 隐藏状态
extern AYViewDataState const AYViewDataStateEmpty;      ///< 空数据状态
extern AYViewDataState const AYViewDataStateError;      ///< 错误数据状态（网络异常等引起）

/// 数据状态 分类
@interface UIView (AYDataState)

@property (nonatomic, copy) AYViewDataState viewDataState;              ///< 状态，设置为 AYViewDataStateHidden 则隐藏
@property (nonatomic, strong, readonly) AYDataStateView *dataStateView; ///< 数据状态视图

@end

NS_ASSUME_NONNULL_END
