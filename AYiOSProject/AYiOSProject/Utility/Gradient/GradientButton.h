//
//  GradientButton.h
//
//  Created by yxg on 2022/10/20.
//

#import <UIKit/UIKit.h>
#import "GradientView.h"

NS_ASSUME_NONNULL_BEGIN

/// 渐变背景Button
@interface GradientButton : UIButton

@property (nonatomic, copy) NSArray<UIColor *> *colors;
@property (nonatomic, copy) NSArray<UIColor *> *disableColors;
@property (nonatomic, copy) NSArray<NSNumber *> *locations;
@property (nonatomic, assign) GradientDirection direction;

@property (nonatomic, strong, readonly) CAGradientLayer *gradientLayer;

@end

NS_ASSUME_NONNULL_END
