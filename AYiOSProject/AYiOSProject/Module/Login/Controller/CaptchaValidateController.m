//   
//  CaptchaValidateController.m
//   
//  Created by alpha yu on 2023/12/25 
//   
   

#import "CaptchaValidateController.h"
#import <CRBoxInputView/CRBoxInputView.h>
#import "CaptchaGetApi.h"
#import "LoginApi.h"

@interface CaptchaValidateController ()

@property (nonatomic, strong) CRBoxInputView *boxInputView; ///< 验证码输入框
@property (nonatomic, strong) UIButton *loginBtn;           ///< 登录按键
@property (nonatomic, strong) UIButton *acquireCodeBtn;     ///< 获取验证码按键

@property (nonatomic, strong) NSTimer *timer;               ///< 倒计时
@property (nonatomic, assign) NSInteger countdownSeconds;   ///< 倒数秒数

@property (nonatomic, assign) CGFloat boxInputViewMargin;       ///< 验证码输入框边距
@property (nonatomic, assign) CGFloat boxInputViewItemGap;      ///< 验证码输入框项间距
@property (nonatomic, assign) NSInteger boxInputViewItemCount;  ///< 验证码输入框项数量

@end

@implementation CaptchaValidateController

#pragma mark - life

- (void)dealloc {
    [self stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    self.fd_prefersNavigationBarHidden = YES;
    
    [self setupData];
    [self setupNavigationBarItems];
    [self setupSubviews];
    
    [self startTimer];
    [self.boxInputView loadAndPrepareViewWithBeginEdit:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];    
    [self.boxInputView loadAndPrepareViewWithBeginEdit:YES];
}

#pragma mark - override


#pragma mark - data

- (void)setupData {
    self.countdownSeconds = 60;
    
    self.boxInputViewMargin = SCALE(27);
    self.boxInputViewItemGap = 10.0;
    self.boxInputViewItemCount = 6;
}

#pragma mark - view

- (void)setupNavigationBarItems {
    [self addNaviViewAndConfig:^(AppNaviView * _Nonnull naviView) {
        naviView.backBtnColor = COLOR_HEX(#FFFFFF);
        naviView.backgroundView.backgroundColor = UIColor.clearColor;
    }];
}

- (void)setupSubviews {
    self.view.backgroundColor = COLOR_HEX(#FD6691);
    
    self.view.backgroundColor = [UIColor gradientColorWithColors:@[COLOR_HEX(#AC87F1), COLOR_HEX(#7E7AF5)] direction:GradientDirectionTopToBottom size:SCREEN_SIZE];
    
    UIImageView *imageView0 = [[UIImageView alloc] initWithImage:IMAGE(@"login_top_left")];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:IMAGE(@"login_bottom_right")];
    
    UIView *loginView = [self createLoginView];
    UIImageView *bottomBgImageView = [[UIImageView alloc] initWithImage:IMAGE(@"login_bg_multiple_line")];

    [self.view addSubview:imageView0];
    [self.view addSubview:imageView1];
    [self.view addSubview:loginView];
    [self.view addSubview:bottomBgImageView];

    [imageView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
    }];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_NAVI_BAR_HEIGHT + SCALE(60));
    }];
    [bottomBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark - getter

- (UIView *)createHeaderView {
    UIView *view = [[UIView alloc] init];
    
    UIButton *closeBtn = [UIButton buttonWithImage:IMAGE(@"icon_close_white_20")];
    closeBtn.jk_touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *textLabel = [UILabel labelWithColor:COLOR_HEX(#FFFFFF) font:FONT(22) text:STRING_FORMAT(@"您好，\n欢迎使用%@", APP_NAME)];
    textLabel.numberOfLines = 2;
    
    UIImageView *pregnantImageView = [[UIImageView alloc] initWithImage:IMAGE(@"login_header_pregnant_white")];
    
    [view addSubview:closeBtn];
    [view addSubview:textLabel];
    [view addSubview:pregnantImageView];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SCALE(20));
        make.left.mas_equalTo(SCALE(18));
        make.top.mas_equalTo(STATUS_BAR_HEIGHT + SCALE(38));
    }];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALE(21));
        make.top.mas_equalTo(STATUS_BAR_HEIGHT + SCALE(91));
    }];
    [pregnantImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCALE(140.5), SCALE(198.5)));
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
    }];
    
    return view;
}

- (UIView *)createLoginView {
    UIView *view = [[UIView alloc] init];
    
    UILabel *textLabel0 = [UILabel labelWithColor:COLOR_HEX(#FFFFFF) font:FONT_BOLD(24) text:@"输入短信验证码"];
    UILabel *textLabel1 = [UILabel labelWithColor:COLOR_HEX(FFFFFF) font:FONT_BOLD(13) text:STRING_FORMAT(@"短信已发送至%@", self.phone ?: @"")];
    
    [view addSubview:textLabel0];
    [view addSubview:textLabel1];
    [view addSubview:self.boxInputView];
    [view addSubview:self.loginBtn];
    [view addSubview:self.acquireCodeBtn];
    
    [textLabel0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    [textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(textLabel0.mas_bottom).offset(SCALE(19));
    }];
    [self.boxInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel1.mas_bottom).offset(SCALE(40));
        make.height.mas_equalTo(SCALE(48));
        make.left.right.inset(self.boxInputViewMargin);
    }];
    [self.acquireCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.boxInputView.mas_bottom).offset(SCALE(14));
        make.right.equalTo(self.boxInputView);
        make.height.mas_equalTo(SCALE(11));
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.boxInputView.mas_bottom).offset(SCALE(70));
        make.height.mas_equalTo(SCALE(42));
        make.left.right.inset(SCALE(36));
    }];
    
    return view;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setNormalWithTitle:@"下一步" color:COLOR_HEX(#8479F1) font:FONT_BOLD(18)];
        _loginBtn.backgroundColor = COLOR_HEX(#FFFFFF);
        [_loginBtn setCornerRadius:11];
        [_loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (CRBoxInputView *)boxInputView {
    if (!_boxInputView) {
        CRBoxInputCellProperty *property = [[CRBoxInputCellProperty alloc] init];
        property.borderWidth = 0;
        property.cellCursorHeight = 0;
        property.cellFont = FONT_NUMBER(42);
        property.cellTextColor = COLOR_HEX(#8479F1);
        property.cornerRadius = 12;
        
        CGFloat width = ((SCREEN_WIDTH - self.boxInputViewMargin * 2) - self.boxInputViewItemGap * (CGFloat)(self.boxInputViewItemCount - 1)) / (CGFloat)self.boxInputViewItemCount;
        _boxInputView = [[CRBoxInputView alloc] initWithCodeLength:6];
        _boxInputView.boxFlowLayout.itemSize = CGSizeMake(width, SCALE(48));
        _boxInputView.boxFlowLayout.minLineSpacing = self.boxInputViewItemGap;
        _boxInputView.customCellProperty = property;

        WEAK_SELF
        _boxInputView.textDidChangeblock = ^(NSString * _Nullable text, BOOL isFinished) {
            STRONG_SELF
            if (isFinished) {
                AccountManager.shared.accessToken = @"accessToken";
                [AppManager.shared accountLogin];
                
//                [self requestLogin];
            }
        };
    }
    return _boxInputView;
}

- (UIButton *)acquireCodeBtn {
    if (!_acquireCodeBtn) {
        _acquireCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_acquireCodeBtn setNormalWithTitle:@"重发验证码" color:COLOR_HEX(#FFFFFF) font:FONT(11)];
        [_acquireCodeBtn addTarget:self action:@selector(requestCaptchaGet) forControlEvents:UIControlEventTouchUpInside];
    }
    return _acquireCodeBtn;
}

#pragma mark - setter


#pragma mark - action

- (void)closeBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginBtnAction:(UIButton *)sender {
//    if (self.boxInputView.textValue.length < 6) {
//        [MBProgressHUD showWithText:@"请输入验证码" inView:self.view];
//        return;
//    }
//    
//    [self requestLogin];
    
    AccountManager.shared.accessToken = @"accessToken";
    [AppManager.shared accountLogin];
}

#pragma mark - notification


#pragma mark - api

/// 获取验证码
- (void)requestCaptchaGet {
    CaptchaGetApiRequest *request = [[CaptchaGetApiRequest alloc] init];
    request.phoneNumber = self.phone;
    [request startRequestWithSuccess:^(NSInteger statusCode, NSString * _Nullable message, id  _Nullable data) {        
        [self startTimer];
    } failure:^(NSInteger statusCode, NSString * _Nullable message, id  _Nullable data) {
        [MBProgressHUD showWithText:message];
    }];
}

- (void)requestLogin {
    [MBProgressHUD showLoadingInView:self.view];
    
    LoginApiRequest *request = [[LoginApiRequest alloc] init];
    request.account = self.phone;
    request.authCode = self.boxInputView.textValue;
    request.loginType = LoginTypeCaptcha;
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

#pragma mark - public


#pragma mark - private


#pragma mark - timer

- (void)startTimer {
    if (self.timer) {
        return;
    }
    
    self.countdownSeconds = 60;
    [self.acquireCodeBtn setTitle:@"重新获取 60S" forState:UIControlStateNormal];
    self.acquireCodeBtn.enabled = NO;

    WEAK_SELF
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
        STRONG_SELF
        [self timerAction];
    } repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (void)timerAction {
    self.countdownSeconds--;
    if (self.countdownSeconds > 0) {
        [self.acquireCodeBtn setTitle:STRING_FORMAT(@"重新获取 %liS", (long)self.countdownSeconds) forState:UIControlStateNormal];
    } else {
        [self stopTimer];
        [self.acquireCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.acquireCodeBtn.enabled = YES;
    }
}

@end
