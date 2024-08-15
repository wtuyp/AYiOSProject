//   
//  MineController.m
//   
//  Created by alpha yu on 2023/12/27 
//   
   

#import "MineController.h"
#import "AccountInfoController.h"
#import "SettingController.h"
#import "AccountInfoApi.h"

@interface MineController ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIImageView *genderView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation MineController

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.fd_prefersNavigationBarHidden = YES;
    
    [self setupData];
    [self setupNavigationBarItems];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AccountInfoModel *model = AccountManager.shared.account;
    self.nameLabel.text = model.name;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:IMAGE(@"mine_avatar_55")];
    if ([model.gender isEqualToString:@"男"]) {
        self.genderView.hidden = NO;
        self.genderView.image = IMAGE(@"icon_gender_male_17");
    } else if ([model.gender isEqualToString:@"女"]) {
        self.genderView.hidden = NO;
        self.genderView.image = IMAGE(@"icon_gender_remale_17");
    } else {
        self.genderView.hidden = YES;
    }
    
    [self requestAccountInfo];
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
    self.view.backgroundColor = COLOR_HEX(#F6F6F6);
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, TAB_BAR_HEIGHT, 0);
    scrollView.delegate = (id<UIScrollViewDelegate>)self;

    [self.view addSubview:self.headerView];
    [self.view addSubview:scrollView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(STATUS_BAR_HEIGHT + SCALE(160));
    }];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.left.right.bottom.inset(0);
    }];
    
    UIView *infoView = [self createInfoView];
    UIView *functionView = [self createFunctionView];
    
    [scrollView.vContainerView addSubview:infoView];
    [scrollView.vContainerView addSubview:functionView];

    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALE(19));
        make.top.mas_equalTo(SCALE(53));
    }];
    [functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(SCALE(160));
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - getter

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [self createHeaderView];
        _headerView.clipsToBounds = YES;
    }
    return _headerView;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithImage:IMAGE(@"mine_avatar_55")];
        [_avatarView setCornerRadius:SCALE(27.5) clip:YES];
    }
    return _avatarView;
}

- (UIImageView *)genderView {
    if (!_genderView) {
        _genderView = [[UIImageView alloc] initWithImage:IMAGE(@"icon_gender_remale_17")];
    }
    return _genderView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithColor:COLOR_HEX(#FFFFFF) font:FONT_BOLD(14)];
    }
    return _nameLabel;
}

- (UIView *)createHeaderView {
    UIView *view = [[UIView alloc] init];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:IMAGE(@"home_header_bg")];
    UIImageView *bubbleView = [[UIImageView alloc] initWithImage:IMAGE(@"home_header_bubble")];
    
    [view addSubview:bgImageView];
    [view addSubview:bubbleView];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];

    [bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(SCALE(230));
        make.height.mas_equalTo(SCALE(183));
    }];

    return view;
}


- (UIView *)createInfoView {
    UIView *view = [[UIView alloc] init];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[IMAGE(@"icon_arrow_right_gray_7_11") imageByTintColor:UIColor.whiteColor]];
    UILabel *infolabel = [UILabel labelWithColor:COLOR_HEX(#FFFFFF) font:FONT(9) text:@"个人信息"];
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn addTarget:self action:@selector(showAccountInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:self.avatarView];
    [view addSubview:self.genderView];
    [view addSubview:self.nameLabel];
    [view addSubview:infolabel];
    [view addSubview:arrowView];
    [view addSubview:infoBtn];

    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SCALE(55));
        make.left.top.bottom.mas_equalTo(0);
    }];
    [self.genderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SCALE(17));
        make.bottom.equalTo(self.avatarView).offset(SCALE(2));
        make.right.equalTo(self.avatarView).offset(SCALE(3));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).offset(SCALE(16));
        make.top.equalTo(self.avatarView).offset(SCALE(12));
        make.height.mas_equalTo(SCALE(14));
    }];
    [infolabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(SCALE(8));
    }];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(infolabel);
        make.left.equalTo(infolabel.mas_right).offset(SCALE(35));
        make.size.mas_equalTo(CGSizeMake(SCALE(7), SCALE(11)));
        make.right.mas_equalTo(0);
    }];
    [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];

    return view;
}

- (UIView *)createFunctionView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = COLOR_HEX(#F6F6F6);

    UIView *itemView0 = [self createFunctionItemViewWithIcon:IMAGE(@"mine_setting_22") title:@"更多设置" action:@selector(showMoreSetting)];
    UIView *itemView1 = [self createFunctionItemViewWithIcon:IMAGE(@"mine_agreement_22") title:@"用户协议" action:@selector(showAgreement)];
    UIView *itemView2 = [self createFunctionItemViewWithIcon:IMAGE(@"mine_privacy_22") title:@"隐私政策" action:@selector(showPrivacyPolicy)];
    
    [view addSubview:itemView0];
    [view addSubview:itemView1];
    [view addSubview:itemView2];
    
    [view verticalLayoutSubviewsWithItemHeight:SCALE(39) itemSpacing:SCALE(14) topSpacing:SCALE(22) bottomSpacing:0 leadSpacing:SCALE(22) tailSpacing:SCALE(22)];
    
    return view;
}

- (UIView *)createFunctionItemViewWithIcon:(UIImage *)icon title:(NSString *)title action:(SEL)action {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.whiteColor;
    [view setCornerRadius:5];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
    UILabel *titleLabel = [UILabel labelWithColor:COLOR_HEX(#000000) font:FONT_BOLD(13) text:title];
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:IMAGE(@"icon_arrow_right_black_9_18")];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:iconView];
    [view addSubview:titleLabel];
    [view addSubview:arrowView];
    [view addSubview:actionBtn];

    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SCALE(22));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(SCALE(12));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(SCALE(14));
        make.centerY.mas_equalTo(0);
    }];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCALE(5), SCALE(10)));
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-SCALE(19));
    }];
    [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];

    return view;
}

#pragma mark - setter


#pragma mark - action

// 个人信息
- (void)showAccountInfo {
    AccountInfoController *vc = [[AccountInfoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 设置
- (void)showSetting {
    SettingController *vc = [[SettingController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 协议
- (void)showAgreement {
    [AppManager.shared showUserAgreementController];
}

// 隐私政策
- (void)showPrivacyPolicy {
    [AppManager.shared showPrivacyPolicyController];
}

// 更多设置
- (void)showMoreSetting {
    SettingController *vc = [[SettingController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - notification


#pragma mark - api

- (void)requestAccountInfo {
//    [MBProgressHUD showLoadingInView:self.view];
    AccountInfoApiRequest *request = [[AccountInfoApiRequest alloc] init];
    [request startRequestWithSuccess:^(NSInteger statusCode, NSString * _Nullable message, id  _Nullable data) {
//        [MBProgressHUD hideAllTipsInView:self.view];
        AccountInfoApiResponse *response = (AccountInfoApiResponse *)data;
        [AccountManager.shared updateAccount:response.account];
        AccountInfoModel *model = AccountManager.shared.account;
        self.nameLabel.text = model.name;
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:IMAGE(@"mine_avatar_55")];
        if ([model.gender isEqualToString:@"男"]) {
            self.genderView.hidden = NO;
            self.genderView.image = IMAGE(@"icon_gender_male_17");
        } else if ([model.gender isEqualToString:@"女"]) {
            self.genderView.hidden = NO;
            self.genderView.image = IMAGE(@"icon_gender_remale_17");
        } else {
            self.genderView.hidden = YES;
        }
    } failure:^(NSInteger statusCode, NSString * _Nullable message, id  _Nullable data) {
//        [MBProgressHUD hideAllTipsInView:self.view];
//        [MBProgressHUD showWithText:message inView:self.view];
    }];
}

#pragma mark - public


#pragma mark - private


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    CGFloat height = MAX(STATUS_BAR_HEIGHT + SCALE(160) - yOffset, 0);
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

@end
