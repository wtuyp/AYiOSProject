//   
//   CALayer+AppCategory.h
//   
//   Created by alpha yu on 2023/6/25 
//   
   

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (AppCategory)

+ (CAShapeLayer *)dashLineLayerWithDashPattern:(NSArray<NSNumber *> *)dashPattern
                                     lineWidth:(CGFloat)lineWidth
                                     lineColor:(UIColor *)lineColor
                                  isHorizontal:(BOOL)isHorizontal;

@end

NS_ASSUME_NONNULL_END
