//   
//   UITextField+AppCategory.h
//
//   Created by alpha yu on 2024/3/13
//
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (AppCategory)

/// 搜索配置
- (void)setSearchConfig;

/// 密码配置
- (void)setPasswordConfig;

/// 电话号码配置
- (void)setPhoneConfig;

/// 验证码配置
- (void)setCaptchaConfig;

/// 金额配置
- (void)setMoneyConfig;

/// 数字配置
- (void)setNumberConfig;

/// 身份证号码配置
- (void)setIdNumberConfig;

/// 编号配置, 英文和数字(纯数字编号, 请使用setNumberConfig)
- (void)setSnConfig;

/// 邮箱配置
- (void)setEmailConfig;

@end

NS_ASSUME_NONNULL_END
