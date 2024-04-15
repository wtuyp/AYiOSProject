//
//  UIColor+AppCategory.h
//
//  Created by MMM on 2021/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (AppCategory)

+ (UIColor * _Nullable)gradientColorWithColors:(NSArray<UIColor *> *)colors
                                     direction:(GradientDirection)direction
                                          size:(CGSize)size;

+ (UIColor * _Nullable)gradientColorWithColors:(NSArray<UIColor *> *)colors
                                    startPoint:(CGPoint)startPoint
                                      endPoint:(CGPoint)endPoint
                                          size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
