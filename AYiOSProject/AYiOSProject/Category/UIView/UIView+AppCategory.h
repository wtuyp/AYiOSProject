//
//  UIView+AppCategory.h
//
//  Created by alpha yu on 2023/1/26
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AppCategory)

+ (UIView *)viewWithColor:(UIColor *)color;

/// 圆角，不切边
- (void)setCornerRadius:(CGFloat)cornerRadius;
/// 圆角，clip: 是否切边
- (void)setCornerRadius:(CGFloat)cornerRadius clip:(BOOL)clip;

/// 圆角，可选方位，不切边
- (void)setCornerRadius:(CGFloat)cornerRadius
             rectCorner:(UIRectCorner)rectCorner;
/// 圆角，可选方位，clip: 是否切边
- (void)setCornerRadius:(CGFloat)cornerRadius
             rectCorner:(UIRectCorner)rectCorner
                   clip:(BOOL)clip;

/// 边框
- (void)setBorderWidth:(CGFloat)borderWidth
           borderColor:(nullable UIColor *)borderColor;
/// 圆角 加 边框
- (void)setCornerRadius:(CGFloat)cornerRadius
            borderWidth:(CGFloat)borderWidth
           borderColor:(nullable UIColor *)borderColor;

/// 阴影
- (void)setShadowWithColor:(UIColor *)color
                   opacity:(CGFloat)opacity
                    offset:(CGSize)offset
                    radius:(CGFloat)radius;

@end

@interface UIView (AppAddLine)

/// 增加底部分隔线
- (void)addBottomLineWithColor:(UIColor *)color;
- (void)addBottomLineWithColor:(UIColor *)color inset:(CGFloat)inset;
- (void)addBottomLineWithColor:(UIColor *)color
                   leftPadding:(CGFloat)leftPadding
                  rightPadding:(CGFloat)rightPadding;

/// 增加顶部部分隔线
- (void)addTopLineWithColor:(UIColor *)color;
- (void)addTopLineWithColor:(UIColor *)color inset:(CGFloat)inset;
- (void)addTopLineWithColor:(UIColor *)color
                leftPadding:(CGFloat)leftPadding
               rightPadding:(CGFloat)rightPadding;

@end


NS_ASSUME_NONNULL_END
