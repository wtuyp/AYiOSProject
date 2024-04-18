//
//  UIView+AYDataState.h
//
//  Created by alpha yu on 2024/1/2
//   
   

#import <UIKit/UIKit.h>
#import "AYDataStateView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AYDataState) {
    AYDataStateHidden = 0,  ///< 隐藏状态
    AYDataStateEmptyData,   ///< 空数据状态
    AYDataStateErrorData,   ///< 错误数据状态（网络异常等引起）
};

/// 数据状态 分类
@interface UIView (AYDataState)

@property (nonatomic, assign) AYDataState viewDataState;    ///< 状态，设置为 AYDataStateHidden 则隐藏

/// 设置状态配置
- (void)setViewDataStateConfig:(AYDataStateConfig * _Nullable)config forState:(AYDataState)state;

/// 获取状态配置
- (AYDataStateConfig * _Nullable)viewDataStateConfigForState:(AYDataState)state;

/// 更新状态配置
- (void)updateViewDataStateConfig:(void (^)(AYDataStateConfig * _Nullable config))configBlock forState:(AYDataState)state;

@end

NS_ASSUME_NONNULL_END
