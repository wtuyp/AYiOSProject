//
//  ModelTypeDefine.h
//
//  Created by MMM on 2021/7/27.
//

#ifndef ModelTypeDefine_h
#define ModelTypeDefine_h

/// 数据类型定义


/// 登录类型
typedef NS_ENUM(NSUInteger, LoginType) {
    LoginTypeCaptcha = 0,       ///< 验证码
    LoginTypePassword,          ///< 密码
};

/// 短信类型:1为登录,2为注册,3为找回密码
typedef NS_ENUM(NSUInteger, CaptchaType) {
    CaptchaTypeLogin = 1,       // 登录
    CaptchaTypeRegister = 2,    // 注册
    CaptchaTypeRetrieve = 3,    // 找回密码
};

/// 身份验证类型
typedef NS_ENUM(NSInteger, AuthenticationType) {
    AuthenticationTypePhone = 1,    ///< 电话号
    AuthenticationTypeMail = 2,     ///< 邮箱
};

/// 账号绑定类型
typedef NS_ENUM(NSInteger, AccountBindType) {
    AccountBindTypePhone = 1,   ///< 绑定手机号
    AccountBindTypeMail = 2,    ///< 绑定邮箱
};

/// 性别类型
typedef NS_ENUM(NSInteger, Gender) {
    GenderUnknown = 0,  ///< 保密
    GenderMale = 1,     ///< 男
    GenderFemale = 2,   ///< 女
};



#endif /* ModelTypeDefine_h */
