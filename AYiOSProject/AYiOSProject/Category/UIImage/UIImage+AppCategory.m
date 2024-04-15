//
//  UIImage+AppCategory.m
//
//  Created by linxj on 2022/11/11.
//

#import "UIImage+AppCategory.h"
#import "UIColor+AppCategory.h"

@implementation UIImage (AppCategory)

+ (UIImage *)gradientImageWithColors:(NSArray<UIColor *> *)colors
                           direction:(GradientDirection)direction
                                size:(CGSize)size
                      attributesText:(NSAttributedString *)attributesText
                        cornerRadius:(CGFloat)cornerRadius
                         borderWidth:(CGFloat)borderWidth
                         borderColor:(nullable UIColor *)borderColor {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    
    UIColor *backgroundColor = [UIColor gradientColorWithColors:colors direction:direction size:size];
    if (!backgroundColor) { backgroundColor = UIColor.clearColor; }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 4);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    maskPath.lineWidth = borderWidth;
    [backgroundColor set];
    [maskPath fill];
    [maskPath closePath];
    
    // 添加边框
    if (borderColor) {
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderWidth, borderWidth, size.width - 2 * borderWidth, size.height - 2 * borderWidth) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        maskPath.lineWidth = borderWidth;
        [borderColor setStroke];
        [borderColor set];
        [borderColor setStroke];
        [maskPath stroke];
        [maskPath addClip];
        CGContextAddPath(context, maskPath.CGPath);
        [maskPath closePath];
    } else {
        // 设置圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        CGContextAddPath(context, maskPath.CGPath);
        CGContextClip(context);
        [maskPath closePath];
    }
    
    CGSize textSize = [attributesText size];
    rect = CGRectMake((size.width - textSize.width) / 2.f,
                      (size.height - textSize.height) / 2.f,
                      textSize.width, textSize.height);
    [attributesText drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)gradientImageWithColors:(NSArray<UIColor *> *)colors
                           direction:(GradientDirection)direction
                                size:(CGSize)size
                        cornerRadius:(CGFloat)cornerRadius {
    return [self gradientImageWithColors:colors direction:direction size:size attributesText:nil cornerRadius:cornerRadius borderWidth:0 borderColor:nil];
}

- (UIImage *)scaleImage {
    CGSize newSize = CGSizeMake(SCALE(self.size.width), SCALE(self.size.height));
    UIGraphicsBeginImageContextWithOptions(newSize, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
