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
        
        AYDataStateConfig *emptyDataConfig = [AYDataStateConfig defaultEmptyDataConfig];
        AYDataStateConfig *errorDataConfig = [AYDataStateConfig defaultErrorDataConfig];
        
        [view setConfig:emptyDataConfig forState:[self stateStringWithState:AYDataStateEmptyData]];
        [view setConfig:errorDataConfig forState:[self stateStringWithState:AYDataStateErrorData]];
        
        view.centerOffset = CGPointMake(0, -50);
        
        self.dataStateView = view;
    }
    return view;
}

- (void)setDataStateView:(AYDataStateView *)dataStateView {
    objc_setAssociatedObject(self, @selector(dataStateView), dataStateView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AYDataState)viewDataState {
    return (AYDataState)self.dataStateView.state.integerValue;
}

- (void)setViewDataState:(AYDataState)viewDataState {
    if (viewDataState != AYDataStateHidden) {
        [self.dataStateView showWithState:[self stateStringWithState:viewDataState]];
    } else {
        [self.dataStateView hidden];
    }
}

#pragma mark - public

- (void)setViewDataStateConfig:(AYDataStateConfig * _Nullable)config forState:(AYDataState)state {
    [self.dataStateView setConfig:config forState:[self stateStringWithState:state]];
}

- (AYDataStateConfig * _Nullable)viewDataStateConfigForState:(AYDataState)state {
    return [self.dataStateView configForState:[self stateStringWithState:state]];
}

- (void)updateViewDataStateConfig:(void (^)(AYDataStateConfig * _Nullable config))configBlock forState:(AYDataState)state {
    [self.dataStateView updateConfig:configBlock forState:[self stateStringWithState:state]];
}

#pragma mark - private

- (NSString *)stateStringWithState:(AYDataState)state {
    return [@(state) stringValue];
}

@end
