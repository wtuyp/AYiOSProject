//
//  AppRefreshFooterView.m
//
//  Created by MMM on 2021/7/1.
//

#import "AppRefreshFooterView.h"

@interface AppRefreshFooterView ()

@property (nonatomic, strong) UIView *noMoreDataView;

@end


@implementation AppRefreshFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark - 初始化UI

- (void)initUI {
    self.hidden = YES;
    
    self.triggerAutomaticallyRefreshPercent = -10.f; // 提前刷新数据用
    
    [self addSubview:self.noMoreDataView];
    [self.noMoreDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UIView *)createNoMoreDataView {
    UIView *view = [[UIView alloc] init];
    
    UIView *left = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = COLOR_HEX(#BEBEBE);
        view;
    });
    UILabel *title = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = FONT(13);
        label.text = (@"暂无更多");
        label.textColor = COLOR_HEX(#BEBEBE);
        label;
    });
    UIView *right = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = COLOR_HEX(#BEBEBE);
        view;
    });
    
    [view addSubview:left];
    [view addSubview:title];
    [view addSubview:right];
    
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.centerY.equalTo(view);
        make.height.mas_equalTo(0.5);
    }];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(left.mas_right).offset(10);
        make.centerY.equalTo(view);
    }];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right).offset(10);
        make.right.equalTo(view).offset(-10).priorityHigh();
        make.centerY.equalTo(view);
        make.width.equalTo(left);
        make.height.mas_equalTo(0.5);
    }];
    
    left.hidden = YES;
    right.hidden = YES;
    
    return view;
}

#pragma mark - 懒加载

- (UIView *)noMoreDataView {
    if (!_noMoreDataView) {
        _noMoreDataView = [self createNoMoreDataView];
        _noMoreDataView.hidden = YES;
    }
    return _noMoreDataView;
}

#pragma mark - Setter

- (void)setState:(MJRefreshState)state {
    [super setState:state];
    
    self.stateLabel.hidden = state == MJRefreshStateNoMoreData;
    self.noMoreDataView.hidden = state != MJRefreshStateNoMoreData;
}

@end
