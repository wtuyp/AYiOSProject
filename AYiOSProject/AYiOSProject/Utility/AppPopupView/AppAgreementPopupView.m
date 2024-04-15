//   
//  AppAgreementPopupView.m
//   
//  Created by alpha yu on 2024/1/22 
//   
   

#import "AppAgreementPopupView.h"

static NSString *const AppAgreementPopupViewShowedKey = APP_KEY_PREFIX@"agreement.popup.view.show";

@interface AppAgreementPopupView ()

@end

@implementation AppAgreementPopupView

#pragma mark - life

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (void)setupInit {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = UIColor.whiteColor;
    [containerView setCornerRadius:12];
    
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
        make.width.mas_equalTo(SCALE(311));
    }];

    UILabel *titleLabel = [UILabel labelWithColor:COLOR_HEX(#000000) font:FONT_BOLD(17) text:@"用户协议和隐私政策提示"];
    
    NSString *appName = APP_NAME;
    NSString *agreement0 = @"《用户协议》";
    NSString *agreement1 = @"《隐私政策》";
    NSString *content = STRING_FORMAT(@"欢迎使用%@！在您使用之前，请您认真阅读并了解%@和%@帮助您了解我们如何收集处理个人信息。点击“同意”即表示您已阅读并同意前述协议和政策。", appName, agreement0, agreement1);
    
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.lineSpacing = 6;
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:content attributes:@{
        NSForegroundColorAttributeName: COLOR_HEX(#A1A1A1), 
        NSFontAttributeName: FONT_BOLD(13),
        NSParagraphStyleAttributeName: pStyle
    }];
    
    [aString addAttributes:@{
            NSForegroundColorAttributeName: COLOR_HEX(#867DFA),
            NSFontAttributeName: FONT_BOLD(13),
            NSLinkAttributeName: [NSURL URLWithString:URL_USER_AGREEMENT]
    } range:[aString.string rangeOfString:agreement0]];
    [aString addAttributes:@{
            NSForegroundColorAttributeName: COLOR_HEX(#867DFA),
            NSFontAttributeName: FONT_BOLD(13),
            NSLinkAttributeName: [NSURL URLWithString:URL_PRIVACY_POLICY]
    } range:[aString.string rangeOfString:agreement1]];
    
    UITextView *contentTextView = [[UITextView alloc] init];
    contentTextView.attributedText = aString;
    contentTextView.textAlignment = NSTextAlignmentLeft;
    contentTextView.delegate = (id<UITextViewDelegate>)self;
    contentTextView.editable = NO;
    contentTextView.linkTextAttributes = @{NSForegroundColorAttributeName: COLOR_HEX(#867DFA),
                                           NSFontAttributeName: FONT_BOLD(13)};
//    contentTextView.scrollEnabled = NO;
    
    UIButton *refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refuseBtn setNormalWithTitle:@"拒绝" color:COLOR_HEX(#FFFFFF) font:FONT_BOLD(16)];
    refuseBtn.backgroundColor = COLOR_HEX(#DCDCDC);
    [refuseBtn setCornerRadius:7];
    [refuseBtn setShadowWithColor:COLOR_HEX(#000000) opacity:0.16 offset:CGSizeMake(0, 3) radius:6];
    [refuseBtn addTarget:self action:@selector(refuseBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setNormalWithTitle:@"同意" color:COLOR_HEX(#FFFFFF) font:FONT_BOLD(16)];
    agreeBtn.backgroundColor = COLOR_HEX(#867DFA);
    [agreeBtn setCornerRadius:7];
    [agreeBtn setShadowWithColor:COLOR_HEX(#867DFA) opacity:1.0 offset:CGSizeMake(0, 3) radius:6];
    [agreeBtn addTarget:self action:@selector(agreeBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    [containerView addSubview:titleLabel];
    [containerView addSubview:contentTextView];
    [containerView addSubview:refuseBtn];
    [containerView addSubview:agreeBtn];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(SCALE(24));
    }];
    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(SCALE(20));
        make.left.right.inset(SCALE(24));
        make.height.mas_equalTo(SCALE(120));
        make.bottom.equalTo(refuseBtn.mas_top).offset(-SCALE(20));
    }];
    [refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-SCALE(22));
        make.size.mas_equalTo(CGSizeMake(SCALE(112), SCALE(40)));
        make.right.equalTo(self.mas_centerX).offset(-16);
    }];
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(refuseBtn);
        make.size.equalTo(refuseBtn);
        make.left.equalTo(self.mas_centerX).offset(16);
    }];
}

- (void)updateUI {

}

#pragma mark - override


#pragma mark - getter


#pragma mark - setter


#pragma mark - action

- (void)refuseBtnAction:(UIButton *)sender {
    [[MMKV defaultMMKV] setBool:YES forKey:AppAgreementPopupViewShowedKey];
    [self dismissPopup];
    if (self.resultBlock) {
        self.resultBlock(NO);
    }
}

- (void)agreeBtnAction:(UIButton *)sender {
    [[MMKV defaultMMKV] setBool:YES forKey:AppAgreementPopupViewShowedKey];
    [self dismissPopup];
    if (self.resultBlock) {
        self.resultBlock(YES);
    }
}

#pragma mark - api


#pragma mark - notification


#pragma mark - public

+ (BOOL)isShowed {
    return [[MMKV defaultMMKV] getBoolForKey:AppAgreementPopupViewShowedKey defaultValue:NO];
}

#pragma mark - private



#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([URL.absoluteString isEqualToString:URL_USER_AGREEMENT]) {
        [AppManager.shared showUserAgreementController];
        return NO;
    } else if ([URL.absoluteString isEqualToString:URL_PRIVACY_POLICY]) {
        [AppManager.shared showPrivacyPolicyController];
        return NO;
    }

    return YES;
}

@end
