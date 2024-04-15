//   
//  AppTabBarItemConfig.m
//   
//  Created by alpha yu on 2024/4/1 
//   
   

#import "AppTabBarItemConfig.h"
#import "MMMLab.h"

@interface AppTabBarItemConfig ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong, nullable) UIImage *selectedImage;
@property (nonatomic, assign) NSInteger tag;

@end

@implementation AppTabBarItemConfig

+ (instancetype)configWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage * _Nullable)selectedImage tag:(NSInteger)tag {
    AppTabBarItemConfig *config = [[AppTabBarItemConfig alloc] init];
    config.title = title;
    config.image = image;
    config.selectedImage = selectedImage;
    config.tag = tag;
    
    return config;
}

@end

@implementation UIViewController (AppTabBarItemConfig)

MMMSynthesizeIdStrongProperty(app_tabBarItemConfig, setApp_tabBarItemConfig)

@end
