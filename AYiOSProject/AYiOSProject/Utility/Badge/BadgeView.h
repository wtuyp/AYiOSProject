//
//  BadgeView.h
//  IslandPost
//
//  Created by yxg on 2021/10/13.
//

#import "GradientView.h"

NS_ASSUME_NONNULL_BEGIN

/// 数字角标
@interface BadgeView : GradientView

@property (nonatomic, assign) CGFloat height; ///< 角标高度，默认 13
@property (nonatomic, strong) UIFont *numberFont; ///< 数字字体，默认 9
@property (nonatomic, strong) UIColor *numberTextColor; ///< 数字颜色，默认 white
@property (nonatomic, assign) NSInteger number; ///< 角标数字

@end

NS_ASSUME_NONNULL_END
