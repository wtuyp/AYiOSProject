//   
//  LoginController.m
//   
//  Created by alpha yu on 2023/12/25 
//   
   

#import "LoginController.h"
#import <JXCategoryView/JXCategoryView.h>

#import "CaptchaValidateController.h"
#import "AppWebViewController.h"
#import "AppAgreementPopupView.h"
#import "CaptchaGetApi.h"
#import "LoginApi.h"

@interface LoginController () <JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UITextField *phoneTF;         ///< 手机号输入
@property (nonatomic, strong) UITextField *passwordTF;      ///< 密码输入

@property (nonatomic, strong) UIView *passwordInputView;    ///< 密码输入容器视图
@property (nonatomic, strong) UIButton *passwordVisibleBtn; ///< 密码可见按键

@property (nonatomic, strong) UIButton *loginBtn;           ///< 登录按键
@property (nonatomic, strong) UIButton *loginTypeBtn;       ///< 登录类型按键，密码登录、验证码登录
@property (nonatomic, strong) UIButton *agreeBtn;           ///< 同意按键

@property (nonatomic, assign) LoginType loginType;          ///< 登录类型

@end

@implementation LoginController

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    self.fd_prefersNavigationBarHidden = YES;
    
    [self setupData];
    [self setupNavigationBarItems];
    [self setupSubviews];
    
    WEAK_SELF
    if (![AppAgreementPopupView isShowed]) {
        AppAgreementPopupView *view = [[AppAgreementPopupView alloc] init];
        view.targetController = self;
        view.resultBlock = ^(BOOL isAgree) {
            STRONG_SELF
            
            self.agreeBtn.selected = isAgree;
        };
        [view popupAtCenter];
    }
    
    self.phoneTF.text = @"15900000000";
    self.passwordTF.text = @"000000";
}

#pragma mark - override


#pragma mark - data

- (void)setupData {
    self.loginType = LoginTypeCaptcha;
}

#pragma mark - view

- (void)setupNavigationBarItems {
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:<#view#>];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor gradientColorWithColors:@[COLOR_HEX(#AC87F1), COLOR_HEX(#7E7AF5)] direction:GradientDirectionTopToBottom size:SCREEN_SIZE];
    
    UIView *loginView = [self createLoginView];
    [self.view addSubview:loginView];
    
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT + SCALE(130));
    }];
}

#pragma mark - getter

- (UIView *)createLoginView {
    UIView *view = [[UIView alloc] init];

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [COLOR_HEX(#FFFFFF) colorWithAlphaComponent:0.58];
    [bgView setCornerRadius:18];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:IMAGE(@"icon_logo_78")];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = UIColor.whiteColor;
    [containerView setCornerRadius:18];

    UIView *phoneInputView = [self createPhoneInputView];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setNormalWithTitle:@"找回密码" color:COLOR_HEX(#7F7F7F) font:FONT_BOLD(11)];
    [forgetBtn addTarget:self action:@selector(forgetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *ruleView = [self createRuleView];

    [view addSubview:bgView];
    [view addSubview:containerView];
    [view addSubview:logoView];
    
    [containerView addSubview:self.categoryView];
    [containerView addSubview:phoneInputView];
    [containerView addSubview:self.passwordInputView];
    [containerView addSubview:self.loginBtn];
    [containerView addSubview:forgetBtn];
    [containerView addSubview:ruleView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SCALE(277));
        make.left.right.inset(SCALE(10));
        make.top.equalTo(containerView).offset(SCALE(23));
    }];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(SCALE(19));
        make.bottom.mas_equalTo(0);
    }];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SCALE(78));
        make.centerX.mas_equalTo(0);
        make.centerY.equalTo(containerView.mas_top);
        make.top.mas_equalTo(0);
    }];

    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALE(70));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SCALE(36));
    }];
    [phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom).offset(SCALE(14));
        make.left.right.inset(SCALE(17));
        make.height.mas_equalTo(SCALE(47));
    }];
    [self.passwordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneInputView.mas_bottom).offset(SCALE(14));
        make.left.right.inset(SCALE(17));
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(SCALE(303));
        
        make.top.mas_equalTo(SCALE(195));
        make.height.mas_equalTo(SCALE(42));
        make.bottom.mas_equalTo(-SCALE(80));
    }];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginBtn).offset(-SCALE(8));
        make.bottom.equalTo(self.loginBtn.mas_top).offset(-SCALE(7));
        make.height.mas_equalTo(SCALE(12));
    }];
    [ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(SCALE(27));
    }];
    

    
//    self.loginTypeBtn.hidden = YES;
//    forgetBtn.hidden = YES;

    return view;
}

- (UIView *)createPhoneInputView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = COLOR_HEX(#ECEBFD);
    [view setCornerRadius:11];
    
    [view addSubview:self.phoneTF];
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(SCALE(16));
        make.top.bottom.mas_equalTo(0);
    }];

    return view;
}

- (UIView *)createRuleView {
    UIView *view = [[UIView alloc] init];
    
    UILabel *textLabel = [UILabel labelWithColor:COLOR_HEX(#7F7F7F) font:FONT(11) text:@"我已阅读并同意"];
    
    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreementBtn setNormalWithTitle:@"《用户协议》" color:COLOR_HEX(#FD86A6) font:FONT(11)];
    [agreementBtn addTarget:self action:@selector(agreementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *policyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [policyBtn setNormalWithTitle:@"《隐私政策》" color:COLOR_HEX(#FD86A6) font:FONT(11)];
    [policyBtn addTarget:self action:@selector(policyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:self.agreeBtn];
    [view addSubview:textLabel];
    [view addSubview:agreementBtn];
    [view addSubview:policyBtn];
    
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.size.mas_equalTo(SCALE(16));
    }];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(self.agreeBtn.mas_right).offset(SCALE(5));
    }];
    [agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(textLabel.mas_right).offset(SCALE(2));
    }];
    [policyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(agreementBtn.mas_right);
        make.right.mas_equalTo(0);
    }];
    
    return view;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        NSArray *titles = @[@"验证码登录", @"密码登录"];
        
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.backgroundColor = UIColor.whiteColor;
        _categoryView.delegate = self;
        _categoryView.defaultSelectedIndex = 0;
        
        _categoryView.titles = titles;
        _categoryView.titleColor = COLOR_HEX(#8A8A8A);
        _categoryView.titleSelectedColor = COLOR_HEX(#000000);
        _categoryView.titleFont = FONT_BOLD(16);
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.selectedAnimationEnabled = YES;
        
        UIImage *indicatorImage = [UIImage gradientImageWithColors:@[COLOR_HEX(#A184F2), COLOR_HEX(#A184F2)] direction:GradientDirectionLeftToRight size:CGSizeMake(36, 6) attributesText:nil cornerRadius:3 borderWidth:0 borderColor:nil];
        
        JXCategoryIndicatorImageView *imageIndicator = [[JXCategoryIndicatorImageView alloc] init];
        imageIndicator.indicatorImageView.image = indicatorImage;
        imageIndicator.indicatorImageViewSize = CGSizeMake(36, 6);
        
        _categoryView.indicators = @[imageIndicator];
    }
    return _categoryView;
}

- (UITextField *)phoneTF {
    if (!_phoneTF) {
        _phoneTF = [[UITextField alloc] init];
        _phoneTF.textColor = COLOR_HEX(#7F7F7F);
        _phoneTF.font = FONT(13);
        _phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{
            NSFontAttributeName: FONT(13), NSForegroundColorAttributeName: COLOR_HEX(#7F7F7F)
        }];
        [_phoneTF setPhoneConfig];
    }
    
    return _phoneTF;
}

- (UITextField *)passwordTF {
    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc] init];
        _passwordTF.textColor = COLOR_HEX(#7F7F7F);
        _passwordTF.font = FONT(13);
        _passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{
            NSFontAttributeName: FONT(13), NSForegroundColorAttributeName: COLOR_HEX(#7F7F7F)
        }];
        [_passwordTF setPasswordConfig];
    }
    
    return _passwordTF;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setNormalWithTitle:@"获取短信验证码" color:COLOR_HEX(#FFFFFF) font:FONT(16)];
        UIImage *image = [UIImage gradientImageWithColors:@[COLOR_HEX(#7F77F1), COLOR_HEX(#9881F0)] direction:GradientDirectionLeftToRight size:CGSizeMake(SCALE(303), SCALE(42)) attributesText:nil cornerRadius:11 borderWidth:0 borderColor:nil];
        [_loginBtn setBackgroundImage:image forState:UIControlStateNormal];
        _loginBtn.adjustsImageWhenHighlighted = NO;
        [_loginBtn setCornerRadius:11];
        [_loginBtn setShadowWithColor:COLOR_HEX(#A787F0) opacity:0.38 offset:CGSizeMake(3, 7) radius:6];
        [_loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)loginTypeBtn {
    if (!_loginTypeBtn) {
        _loginTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginTypeBtn setNormalWithTitle:@"密码登录" color:COLOR_HEX(#FD86A6) font:FONT(10)];
        [_loginTypeBtn setTitle:@"验证码登录" forState:UIControlStateSelected];
        [_loginTypeBtn addTarget:self action:@selector(loginTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginTypeBtn;
}

- (UIButton *)agreeBtn {
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithImage:IMAGE(@"login_cleck_no") selectedImage:IMAGE(@"login_cleck_yes")];
        [_agreeBtn addTarget:self action:@selector(agreeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _agreeBtn.jk_touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _agreeBtn;
}

- (UIView *)passwordInputView {
    if (!_passwordInputView) {
        _passwordInputView = [[UIView alloc] init];
        _passwordInputView.alpha = 0.0;
        
        UIView *borderView = [[UIView alloc] init];
        borderView.backgroundColor = COLOR_HEX(#ECEBFD);
        [borderView setCornerRadius:11];
        
        [_passwordInputView addSubview:borderView];
        [_passwordInputView addSubview:self.passwordTF];
        [_passwordInputView addSubview:self.passwordVisibleBtn];
        
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(0);
            make.height.mas_equalTo(SCALE(47));
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(borderView);
            make.left.equalTo(borderView).offset(SCALE(14));
            make.right.equalTo(self.passwordVisibleBtn.mas_left).offset(-10);
            make.bottom.mas_equalTo(0);
        }];
        [self.passwordVisibleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCALE(27.5), SCALE(18)));
            make.centerY.equalTo(borderView);
            make.right.equalTo(borderView).offset(-SCALE(17));
        }];
    }
    return _passwordInputView;
}

- (UIButton *)passwordVisibleBtn {
    if (!_passwordVisibleBtn) {
        _passwordVisibleBtn = [UIButton buttonWithImage:IMAGE(@"icon_visible_no_gray_28_18") selectedImage:IMAGE(@"icon_visible_yes_gray_28_18")];
        [_passwordVisibleBtn addTarget:self action:@selector(passwordVisibleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordVisibleBtn;
}

#pragma mark - setter


#pragma mark - action

- (void)loginTypeBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (self.loginType == LoginTypeCaptcha) {
        self.loginType = LoginTypePassword;
        
        [self.loginBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALE(285));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.passwordInputView.alpha = 1.0;
            [self.view layoutIfNeeded];
        }];
        
        self.phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号/账号" attributes:@{
            NSFontAttributeName: FONT(13), NSForegroundColorAttributeName: COLOR_HEX(#7F7F7F)
        }];
        [self.loginBtn setNormalWithTitle:@"登录" color:COLOR_HEX(#FFFFFF) font:FONT(16)];
    } else if (self.loginType == LoginTypePassword) {
        self.loginType = LoginTypeCaptcha;
        
        [self.loginBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALE(216));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.passwordInputView.alpha = 0.0;
            [self.view layoutIfNeeded];
        }];
        
        self.phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{
            NSFontAttributeName: FONT(13), NSForegroundColorAttributeName: COLOR_HEX(#7F7F7F)
        }];
        [self.loginBtn setNormalWithTitle:@"获取短信验证码" color:COLOR_HEX(#FFFFFF) font:FONT(16)];
    }
}

- (void)forgetBtnAction:(UIButton *)sender {
    
}

- (void)loginBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (self.phoneTF.text.length == 0) {
        [MBProgressHUD showWithText:self.phoneTF.attributedPlaceholder.string inView:self.view];
        return;
    }
    
    if (self.loginType == LoginTypeCaptcha) {
        if (!self.agreeBtn.isSelected) {
            [MBProgressHUD showWithText:@"请先阅读并同意《用户协议》《隐私政策》" inView:self.view];
            return;
        }
//        [self requestGetCode];
        
        // FIXME: requestGetCode
        CaptchaValidateController *vc = [[CaptchaValidateController alloc] init];
        vc.phone = self.phoneTF.text;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.loginType == LoginTypePassword) {
        if (self.passwordTF.text == 0) {
            [MBProgressHUD showWithText:@"请输入密码" inView:self.view];
            return;
        }
        if (!self.agreeBtn.isSelected) {
            [MBProgressHUD showWithText:@"请先阅读并同意《用户协议》《隐私政策》" inView:self.view];
            return;
        }
        
        // FIXME: requestLogin
        AccountManager.shared.accessToken = @"accessToken";
        [AppManager.shared accountLogin];
        
//        [self requestLogin];
    }
}

- (void)agreeBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

- (void)agreementBtnAction:(UIButton *)sender {
    [AppManager.shared showUserAgreementController];
}

- (void)policyBtnAction:(UIButton *)sender {
    [AppManager.shared showPrivacyPolicyController];
}

- (void)passwordVisibleBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.passwordTF.secureTextEntry = sender.isSelected ? NO : YES;
}

#pragma mark - notification


#pragma mark - api

- (void)requestLogin {
    [MBProgressHUD showLoadingInView:self.view];
    
    LoginApiRequest *request = [[LoginApiRequest alloc] init];
    request.account = self.phoneTF.text;
    request.password = self.passwordTF.text;
    request.loginType = LoginTypePassword;
    [request startRequestWithSuccess:^(NSInteger statusCode, NSString * _Nullable message, id  _Nullable data) {
        [MBProgressHUD hideAllTipsInView:self.view];
        
        LoginApiResponse *response = (LoginApiResponse *)data;

        AccountManager.shared.accessToken = response.accessToken;
        AccountManager.shared.refreshToken = response.refreshToken;
        [AccountManager.shared updateAccount:response.accountInfo];
        [AppManager.shared accountLogin];
    } failure:^(NSInteger statusCode, NSString * _Nullable message, id  _Nullable data) {
        [MBProgressHUD hideAllTipsInView:self.view];
        [MBProgressHUD showWithText:message inView:self.view];
    }];
}


// 获取验证码
- (void)requestGetCode {
    [MBProgressHUD showLoadingInView:self.view];
    CaptchaGetApiRequest *request = [[CaptchaGetApiRequest alloc] init];
    request.phoneNumber = self.phoneTF.text;
    [request startRequestWithSuccess:^(NSInteger statusCode, NSString * _Nullable message, id  _Nullable data) {
        [MBProgressHUD hideAllTipsInView:self.view];

        CaptchaValidateController *vc = [[CaptchaValidateController alloc] init];
        vc.phone = self.phoneTF.text;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSInteger statusCode, NSString * _Nullable message, id  _Nullable data) {
        [MBProgressHUD hideAllTipsInView:self.view];
        [MBProgressHUD showWithText:message inView:self.view];
    }];
}

#pragma mark - public


#pragma mark - private


#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    if (index == 1) {
        self.loginType = LoginTypePassword;
        
        [self.loginBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALE(255));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.passwordInputView.alpha = 1.0;
            [self.view layoutIfNeeded];
        }];
        
        self.phoneTF.zg_isNumber = NO;
        self.phoneTF.zg_maxLength = 50;
        self.phoneTF.keyboardType = UIKeyboardTypeASCIICapable;
        self.phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号/账号" attributes:@{
            NSFontAttributeName: FONT(13), NSForegroundColorAttributeName: COLOR_HEX(#7F7F7F)
        }];
        [self.loginBtn setNormalWithTitle:@"登录" color:COLOR_HEX(#FFFFFF) font:FONT(16)];
    } else if (index == 0) {
        self.loginType = LoginTypeCaptcha;
        
        [self.loginBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALE(195));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.passwordInputView.alpha = 0.0;
            [self.view layoutIfNeeded];
        }];
        
        self.phoneTF.zg_isNumber = YES;
        self.phoneTF.zg_maxLength = 11;
        self.phoneTF.keyboardType = UIKeyboardTypePhonePad;
        self.phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{
            NSFontAttributeName: FONT(13), NSForegroundColorAttributeName: COLOR_HEX(#7F7F7F)
        }];
        [self.loginBtn setNormalWithTitle:@"获取短信验证码" color:COLOR_HEX(#FFFFFF) font:FONT(16)];
    }
}

@end
