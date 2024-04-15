//   
//  AYDataStateConfig.h
//   
//  Created by alpha yu on 2024/1/2 
//   
   

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 数据状态视图配置
@interface AYDataStateConfig : NSObject

// 图片
@property (nonatomic, strong, nullable) UIImage *image; ///< 与 imageName 二选一，比 imageName 优先级高
@property (nonatomic, strong, nullable) NSString *imageName;
@property (nonatomic, assign) CGSize imageSize;         ///< 图片大小

// 标题（单行）
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) CGFloat titleTopGap;  /// 与上一项的垂直距离，没有上一项将忽略该值

// 详情（多行）
@property (nonatomic, copy, nullable) NSString *detail;
@property (nonatomic, strong) UIColor *detailColor;
@property (nonatomic, strong) UIFont *detailFont;
@property (nonatomic, assign) CGFloat detailWidth;  // 因为多行，要有一个宽度。没设置则用父视图的宽度
@property (nonatomic, assign) CGFloat detailTopGap;

// 按键
@property (nonatomic, copy, nullable) NSString *btnTitle;
@property (nonatomic, strong) UIColor *btnTitleColor;
@property (nonatomic, strong) UIFont *btnTitleFont;
@property (nonatomic, strong) UIColor *btnBackgroundColor;
@property (nonatomic, assign) CGFloat btnBorderWidth;
@property (nonatomic, strong) UIColor *btnBorderColor;
@property (nonatomic, assign) CGSize btnSize;
@property (nonatomic, assign) CGFloat btnCornerRadius;
@property (nonatomic, assign) CGFloat btnTopGap;
@property (nonatomic, copy, nullable) void (^btnActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
