//   
//   UIButton+AppCategory.h
//   
//   Created  by alpha yu on 2023/2/15 
//   
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (AppCategory)

/// 快捷配置
- (void)setNormalWithTitle:(NSString *)title color:(UIColor * _Nullable)color font:(UIFont * _Nullable)font;
- (void)setState:(UIControlState)state title:(NSString *)title color:(UIColor * _Nullable)color font:(UIFont * _Nullable)font;

+ (instancetype)buttonWithImage:(UIImage *)image;
+ (instancetype)buttonWithImage:(UIImage *)image selectedImage:(UIImage * _Nullable)selectedImage;
- (void)setImage:(UIImage *)image selectedImage:(UIImage * _Nullable)selectedImage;

+ (instancetype)buttonWithTitle:(NSString *)title color:(UIColor * _Nullable)color font:(UIFont * _Nullable)font;
+ (instancetype)buttonWithTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
