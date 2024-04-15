//
//  UIColor+AppCategory.m
//
//  Created by MMM on 2021/7/8.
//

#import "UIColor+AppCategory.h"

@implementation UIColor (AppCategory)

+ (UIColor *)gradientColorWithColors:(NSArray<UIColor *> *)colors
                           direction:(GradientDirection)direction
                                size:(CGSize)size {
    if (!colors || colors.count < 2 || CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }

    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case GradientDirectionLeftToRight: // 从左到右
            startPoint = CGPointMake(0, 0);
            endPoint = CGPointMake(1, 0);
            break;
        case GradientDirectionRightToLeft: // 从右到左
            startPoint = CGPointMake(1, 0);
            endPoint = CGPointMake(0, 0);
            break;
        case GradientDirectionTopToBottom: // 从上到下
            startPoint = CGPointMake(0, 0);
            endPoint = CGPointMake(0, 1);
            break;
        case GradientDirectionBottomToTop: // 从下到上
            startPoint = CGPointMake(0, 1);
            endPoint = CGPointMake(0, 0);
            break;
        case GradientDirectionTopLeftToBottomRight: // 从左上到右下
            startPoint = CGPointMake(0, 0);
            endPoint = CGPointMake(1, 1);
            break;
        case GradientDirectionBottomLeftToTopRight: // 从左下到右上
            startPoint = CGPointMake(0, 1);
            endPoint = CGPointMake(1, 0);
            break;
        case GradientDirectionTopRightToBottomLeft: // 从右上到左下
            startPoint = CGPointMake(1, 0);
            endPoint = CGPointMake(0, 1);
            break;
        case GradientDirectionBottomRightToTopLeft: // 从右下到左上
            startPoint = CGPointMake(1, 1);
            endPoint = CGPointMake(0, 0);
            break;
        default:
            break;
    }
    
    return [self gradientColorWithColors:colors startPoint:startPoint endPoint:endPoint size:size];
}

+ (UIColor *)gradientColorWithColors:(NSArray<UIColor *> *)colors
                          startPoint:(CGPoint)startPoint
                            endPoint:(CGPoint)endPoint
                                size:(CGSize)size {
    if (!colors || colors.count < 2 || CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [array appendObject:(__bridge id)color.CGColor];
    }
    gradientLayer.colors = array;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

@end
