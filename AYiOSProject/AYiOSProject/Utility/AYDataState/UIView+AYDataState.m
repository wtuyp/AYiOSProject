//
//  UIView+AYDataState.m
//
//  Created by alpha yu on 2024/1/2
//   
   

#import "UIView+AYDataState.h"
#import <objc/runtime.h>

@implementation AYDataStateConfig (AYDataState)

/// 默认空数据配置
+ (AYDataStateConfig *)defaultEmptyDataConfig {
    AYDataStateConfig *config = [[AYDataStateConfig alloc] init];
    
    config.imageName = @"icon_empty";
    
    config.title = @"暂无数据";
    config.titleColor = COLOR_HEX(#000000);
    config.titleFont = FONT(17);
    config.titleTopGap = 50;
    
    return config;
}

/// 默认错误数据配置
+ (AYDataStateConfig *)defaultErrorDataConfig {
    AYDataStateConfig *config = [[AYDataStateConfig alloc] init];
    
    return config;
}

@end

@interface UIView ()

@property (nonatomic, strong) AYDataStateView *dataStateView;

@end

@implementation UIView (AYDataState)

- (AYDataStateView *)dataStateView {
    AYDataStateView *view = objc_getAssociatedObject(self, _cmd);
    if (!view) {
        view = [[AYDataStateView alloc] initWithAttachedView:self];
        view.centerOffset = CGPointMake(0, -(SAFE_BOTTOM + 50));

        AYDataStateConfig *emptyDataConfig = [AYDataStateConfig defaultEmptyDataConfig];
        AYDataStateConfig *errorDataConfig = [AYDataStateConfig defaultErrorDataConfig];
        
        [view setConfig:emptyDataConfig forState:AYViewDataStateEmptyData];
        [view setConfig:errorDataConfig forState:AYViewDataStateErrorData];
                
        self.dataStateView = view;
    }
    return view;
}

- (void)setDataStateView:(AYDataStateView *)dataStateView {
    objc_setAssociatedObject(self, @selector(dataStateView), dataStateView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AYViewDataState)viewDataState {
    return self.dataStateView.state;
}

- (void)setViewDataState:(AYViewDataState)viewDataState {
    [self.dataStateView showWithState:viewDataState];
}

@end
