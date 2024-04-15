//
//  TitleImageButton.h
//
//  Created by tens on 2022/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 图片相对文字的位置，默认 左边
typedef NS_ENUM(NSUInteger, TitleImageButtonImagePosition) {
    TitleImageButtonImagePositionLeft = 0,
    TitleImageButtonImagePositionRight,
    TitleImageButtonImagePositionTop,
    TitleImageButtonImagePositionBottom
};

/// 显示标题和图片的按键
@interface TitleImageButton : UIButton

@property (nonatomic, assign) BOOL adjustsButtonWhenHighlighted;    // 默认 YES
@property (nonatomic, assign) BOOL adjustsButtonWhenDisabled;       // 默认 YES

@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
@property (nonatomic, strong) UIColor *disabledBackgroundColor;

@property (nonatomic, strong) UIColor *highlightedBorderColor;
@property (nonatomic, strong) UIColor *disabledBorderColor;

+ (instancetype)buttonWithTitle:(NSString *)title
                          color:(UIColor *)color
                           font:(UIFont *)font
                          image:(UIImage *)image
                  selectedImage:(UIImage * _Nullable)selectedImage
                  imagePosition:(TitleImageButtonImagePosition)imagePosition
                            gap:(CGFloat)gap;

+ (instancetype)buttonWithTitle:(NSString *)title
                  selectedTitle:(NSString *)selectedTitle
                          color:(UIColor *)color
                           font:(UIFont *)font
                          image:(UIImage *)image
                  imagePosition:(TitleImageButtonImagePosition)imagePosition
                            gap:(CGFloat)gap;

+ (instancetype)buttonWithTitle:(NSString *)title
                          color:(UIColor *)color
                  selectedColor:(UIColor *)selectedColor
                           font:(UIFont *)font
                          image:(UIImage *)image
                  selectedImage:(UIImage *)selectedImage
                  imagePosition:(TitleImageButtonImagePosition)imagePosition
                            gap:(CGFloat)gap;

- (void)setImagePosition:(TitleImageButtonImagePosition)imagePosition gapToTitle:(CGFloat)gap;

@end

NS_ASSUME_NONNULL_END
