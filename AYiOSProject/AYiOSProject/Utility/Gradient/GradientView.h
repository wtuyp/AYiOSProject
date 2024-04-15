//
//  GradientView.h
//
//  Created by yxg on 2022/10/15.
//

#import <UIKit/UIKit.h>
#import "MacroUtils.h"

NS_ASSUME_NONNULL_BEGIN

/// 渐变背景View
@interface GradientView : UIView

@property (nonatomic, copy) NSArray<UIColor *> *colors;
@property (nonatomic, copy) NSArray<NSNumber *> *locations;
@property (nonatomic, assign) GradientDirection direction;

@end

NS_ASSUME_NONNULL_END
