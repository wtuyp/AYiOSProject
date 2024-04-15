//
//  AppRefreshHeader.m
//
//  Created by yxg on 2023/2/9.
//

#import "AppRefreshHeader.h"

@interface AppRefreshHeader ()

@end


@implementation AppRefreshHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark - 初始化UI

- (void)initUI {
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    self.automaticallyChangeAlpha = YES;
}

#pragma mark - 懒加载

#pragma mark - 更新UI

- (void)updateUI {

}

#pragma mark - Setter

#pragma mark - Delegate

#pragma mark - 事件处理

@end
