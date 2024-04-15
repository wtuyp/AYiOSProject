//   
//   CALayer+AppCategory.m
//
//   Created by alpha yu on 2023/6/25 
//   
   

#import "CALayer+AppCategory.h"

@implementation CALayer (AppCategory)

+ (CAShapeLayer *)dashLineLayerWithDashPattern:(NSArray<NSNumber *> *)dashPattern
                                     lineWidth:(CGFloat)lineWidth
                                     lineColor:(UIColor *)lineColor
                                  isHorizontal:(BOOL)isHorizontal {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = lineColor.CGColor;
    layer.lineWidth = lineWidth;
    layer.lineDashPattern = dashPattern;
    layer.lineCap = kCALineCapRound;
    layer.cornerRadius = lineWidth / 2.0;
    layer.masksToBounds = YES;
    
    CGMutablePathRef path = CGPathCreateMutable();
    if (isHorizontal) {
        CGPathMoveToPoint(path, NULL, 0, lineWidth / 2);
        CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH, lineWidth / 2);
    } else {
        CGPathMoveToPoint(path, NULL, lineWidth / 2, 0);
        CGPathAddLineToPoint(path, NULL, lineWidth / 2, SCREEN_HEIGHT);
    }
    layer.path = path;
    CGPathRelease(path);
    
    return layer;
}

@end
