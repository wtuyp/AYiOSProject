//   
//   UILabel+AppCategory.m
//   
//   Created  by alpha yu on 2023/2/10 
//   
   

#import "UILabel+AppCategory.h"

@interface UILabel ()

@end

@implementation UILabel (AppCategory)

+ (instancetype)labelWithColor:(UIColor *)color font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = font;
    
    return label;
}

+ (instancetype)labelWithColor:(UIColor *)color font:(UIFont *)font text:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = color;
    label.font = font;
    
    return label;
}

- (void)setColor:(UIColor *)color font:(UIFont *)font text:(NSString *)text {
    self.text = text;
    self.textColor = color;
    self.font = font;
}

- (void)setColor:(UIColor *)color font:(UIFont *)font {
    self.textColor = color;
    self.font = font;
}

@end
