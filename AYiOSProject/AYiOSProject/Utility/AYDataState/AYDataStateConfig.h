//   
//  AYDataStateConfig.h
//   
//  Created by alpha yu on 2024/1/2 
//   
   

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 视图数据状态配置
@interface AYDataStateConfig : NSObject

// 图片
@property (nonatomic, strong, nullable) UIImage *image;     ///< 图片。与 imageName 二选一，比 imageName 优先级高
@property (nonatomic, strong, nullable) NSString *imageName;
@property (nonatomic, assign) CGSize imageSize;             ///< 图片大小

// 标题（单行）
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, strong, nullable) UIColor *titleColor;
@property (nonatomic, strong, nullable) UIFont *titleFont;
@property (nonatomic, assign) CGFloat titleTopGap;          ///< 与图片的垂直距离

// 详情（多行）
@property (nonatomic, copy, nullable) NSString *detail;
@property (nonatomic, strong, nullable) UIColor *detailColor;
@property (nonatomic, strong, nullable) UIFont *detailFont;
@property (nonatomic, assign) CGFloat detailWidth;          ///< 详情宽度。因为多行，要有一个宽度。没设置则用父视图的宽度
@property (nonatomic, assign) CGFloat detailTopGap;         ///< 与标题的垂直距离

// 按键
@property (nonatomic, copy, nullable) NSString *btnTitle;
@property (nonatomic, strong, nullable) UIColor *btnTitleColor;
@property (nonatomic, strong, nullable) UIFont *btnTitleFont;
@property (nonatomic, strong, nullable) UIColor *btnBackgroundColor;
@property (nonatomic, assign) CGSize btnSize;
@property (nonatomic, assign) CGFloat btnCornerRadius;
@property (nonatomic, assign) CGFloat btnBorderWidth;
@property (nonatomic, strong, nullable) UIColor *btnBorderColor;
@property (nonatomic, copy, nullable) void (^btnActionBlock)(void);
@property (nonatomic, assign) CGFloat btnTopGap;            ///< 与详情的垂直距离

@end

NS_ASSUME_NONNULL_END
