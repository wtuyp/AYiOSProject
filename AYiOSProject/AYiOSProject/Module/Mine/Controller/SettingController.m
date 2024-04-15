//   
//  SettingController.m
//   
//  Created by alpha yu on 2024/1/4 
//   
   

#import "SettingController.h"
#import "CheckNewVersionApi.h"

@interface SettingController ()

@property (nonatomic, strong) UILabel *cacheSizeLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UISwitch *noticeSwitch;

@end

@implementation SettingController

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";

    [self setupData];
    [self setupNavigationBarItems];
    [self setupSubviews];
    
    self.cacheSizeLabel.text = @"0.00M";
    self.versionLabel.text = STRING_FORMAT(@"V %@", self.jk_version);
    self.noticeSwitch.on = YES;
}

#pragma mark - override


#pragma mark - data

- (void)setupData {

}

#pragma mark - view

- (void)setupNavigationBarItems {
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:<#view#>];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setupSubviews {
    self.view.backgroundColor = COLOR_HEX(#F7F7F7);

    UIView *containerView = [[UIView alloc] init];
    
    UIView *itemView0 = [self createItemViewWithTitle:@"缓存清理" valueView:self.cacheSizeLabel showArrow:YES showBottomLine:NO action:@selector(clearCacheAction)];
    UIView *itemView1 = [self createItemViewWithTitle:@"当前版本" valueView:self.versionLabel showArrow:YES showBottomLine:NO action:@selector(checkVersionAction)];
    UIView *itemView2 = [self createItemViewWithTitle:@"允许消息通知" valueView:self.noticeSwitch showArrow:NO showBottomLine:NO action:nil];

    [self.view addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.mas_equalTo(0);
    }];
  
    [containerView addSubview:itemView0];
    [containerView addSubview:itemView1];
    [containerView addSubview:itemView2];
    
    [containerView verticalLayoutSubviewsWithItemHeight:SCALE(52) itemSpacing:SCALE(11) topSpacing:SCALE(13) bottomSpacing:0 leadSpacing:SCALE(12) tailSpacing:SCALE(12)];

}

#pragma mark - getter

- (UILabel *)cacheSizeLabel {
    if (!_cacheSizeLabel) {
        _cacheSizeLabel = [UILabel labelWithColor:COLOR_HEX(#545454) font:FONT_BOLD(14)];
    }
    return _cacheSizeLabel;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [UILabel labelWithColor:COLOR_HEX(#545454) font:FONT_BOLD(14)];
    }
    return _versionLabel;
}

- (UISwitch *)noticeSwitch {
    if (!_noticeSwitch) {
        _noticeSwitch = [[UISwitch alloc] init];
        _noticeSwitch.onTintColor = COLOR_HEX(#FF75A9);
        [_noticeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _noticeSwitch;
}

- (UIView *)createItemViewWithTitle:(NSString *)title valueView:(UIView * _Nullable)valueView showArrow:(BOOL)showArrow showBottomLine:(BOOL)showBottomLine action:(SEL _Nullable)action {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.whiteColor;
    [view setCornerRadius:12];
    
    UILabel *titleLabel = [UILabel labelWithColor:COLOR_HEX(#545454) font:FONT_BOLD(14) text:title];
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:IMAGE(@"icon_arrow_right_black_7_13")];
    arrowView.hidden = !showArrow;
    
    [view addSubview:titleLabel];
    [view addSubview:arrowView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALE(14));
        make.centerY.mas_equalTo(0);
    }];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCALE(7), SCALE(13)));
        make.centerY.equalTo(titleLabel);
        make.right.mas_equalTo(-SCALE(10));
    }];
    
    if (valueView) {
        [view addSubview:valueView];
        [valueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-SCALE(26));
        }];
    }
    
    if (showBottomLine) {
        UIView *lineView = [UIView viewWithColor:COLOR_HEX(#D2D2D2)];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(SCALE(5));
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    if (action) {
        UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [actionBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

        [view addSubview:actionBtn];
        [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.inset(0);
        }];
    }
    
    return view;
}

#pragma mark - setter


#pragma mark - action

- (void)clearCacheAction {
//    [AppAlert showAlertWithTitle:@"温馨提示" content:@"是否清除本地缓存？" cancelTitle:@"取消" actionTitle:@"确认" actionBlock:^{
//        [MBProgressHUD showWithText:@"缓存清理成功" inView:self.view];
//    }];
}

- (void)checkVersionAction {
    [self requestNewVersion];
}

- (void)switchAction:(UISwitch *)sender {
    // TODO:
}

#pragma mark - notification


#pragma mark - api

- (void)requestNewVersion {
    [MBProgressHUD showLoadingInView:self.view];
    CheckNewVersionApiRequest *request = [[CheckNewVersionApiRequest alloc] init];
    [request startRequestWithSuccess:^(NSInteger statusCode, NSString * _Nullable message, id  _Nullable data) {
        [MBProgressHUD hideAllTipsInView:self.view];
//        CheckNewVersionApiResponse *response = (CheckNewVersionApiResponse *)data;
    } failure:^(NSInteger statusCode, NSString * _Nullable message, id  _Nullable data) {
        [MBProgressHUD hideAllTipsInView:self.view];
        [MBProgressHUD showWithText:message inView:self.view];
    }];
}

#pragma mark - public


#pragma mark - private



@end
