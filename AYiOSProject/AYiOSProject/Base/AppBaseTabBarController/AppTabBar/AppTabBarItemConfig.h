//   
//  AppTabBarItemConfig.h
//   
//  Created by alpha yu on 2024/4/1 
//   
   

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// TabBar item配置
@interface AppTabBarItemConfig : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly, nullable) UIImage *selectedImage;
@property (nonatomic, assign, readonly) NSInteger tag;

+ (instancetype)configWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage * _Nullable)selectedImage tag:(NSInteger)tag;

@end

@interface UIViewController (AppTabBarItemConfig)

@property (nonatomic, strong, nullable) AppTabBarItemConfig *app_tabBarItemConfig;

@end

NS_ASSUME_NONNULL_END
