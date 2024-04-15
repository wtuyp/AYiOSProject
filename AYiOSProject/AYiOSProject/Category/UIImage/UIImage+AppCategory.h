//
//  UIImage+AppCategory.h
//
//  Created by linxj on 2022/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (AppCategory)

/// 渐变图片，attributesText 居中显示，可配置边框
+ (UIImage * _Nullable)gradientImageWithColors:(NSArray<UIColor *> *)colors
                                     direction:(GradientDirection)direction
                                          size:(CGSize)size
                                attributesText:(NSAttributedString * _Nullable)attributesText
                                  cornerRadius:(CGFloat)cornerRadius
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(nullable UIColor *)borderColor;

/// 渐变图片
+ (UIImage * _Nullable)gradientImageWithColors:(NSArray<UIColor *> *)colors
                                     direction:(GradientDirection)direction
                                          size:(CGSize)size
                                  cornerRadius:(CGFloat)cornerRadius;

/// 自适应尺寸图片
- (UIImage *)scaleImage;

@end

NS_ASSUME_NONNULL_END
