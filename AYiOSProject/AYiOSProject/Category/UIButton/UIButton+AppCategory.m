//   
//   UIButton+AppCategory.m
//
//   Created  by alpha yu on 2023/2/15 
//   
   

#import "UIButton+AppCategory.h"

@implementation UIButton (AppCategory)

- (void)setNormalWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font {
    [self setState:UIControlStateNormal title:title color:color font:font];
}

- (void)setState:(UIControlState)state title:(NSString *)title color:(UIColor *)color font:(UIFont *)font {
    [self setTitle:title forState:state];
    if (color) {
        [self setTitleColor:color forState:state];
    }
    if (font) {
        self.titleLabel.font = font;
    }
}

+ (instancetype)buttonWithImage:(UIImage *)image {
    return [self buttonWithImage:image selectedImage:nil];
}

+ (instancetype)buttonWithImage:(UIImage *)image selectedImage:(UIImage * _Nullable)selectedImage {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image selectedImage:selectedImage];
    return btn;
}

- (void)setImage:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    [self setImage:image forState:UIControlStateNormal];
    if (selectedImage) {
        [self setImage:selectedImage forState:UIControlStateSelected];
        [self setImage:selectedImage forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    self.adjustsImageWhenHighlighted = NO;
}

+ (instancetype)buttonWithTitle:(NSString *)title color:(UIColor * _Nullable)color font:(UIFont * _Nullable)font {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setNormalWithTitle:title color:color font:font];
    return btn;
}

+ (instancetype)buttonWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
