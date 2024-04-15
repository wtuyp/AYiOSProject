//   
//   UILabel+AppCategory.h
//   
//   Created  by alpha yu on 2023/2/10 
//   
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (AppCategory)

/// 快捷创建label
+ (instancetype)labelWithColor:(UIColor *)color font:(UIFont *)font;
+ (instancetype)labelWithColor:(UIColor *)color font:(UIFont *)font text:(NSString *)text;

/// 快捷配置label
- (void)setColor:(UIColor *)color font:(UIFont *)font;
- (void)setColor:(UIColor *)color font:(UIFont *)font text:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
