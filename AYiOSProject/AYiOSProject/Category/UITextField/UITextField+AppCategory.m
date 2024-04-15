//   
//   UITextField+AppCategory.m
//
//   Created by alpha yu on 2024/3/13
//
   

#import "UITextField+AppCategory.h"
#import "UITextField+ZGExtand.h"

@implementation UITextField (AppCategory)

- (void)setSearchConfig {
    self.returnKeyType = UIReturnKeySearch;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)setPasswordConfig {
    self.keyboardType = UIKeyboardTypeASCIICapable;
    self.secureTextEntry = YES;
    self.zg_isPassword = YES;
}

- (void)setPhoneConfig {
    self.keyboardType = UIKeyboardTypePhonePad;
    self.zg_isNumber = YES;
    self.zg_maxLength = 11;
}

- (void)setCaptchaConfig {
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.zg_isNumber = YES;
    self.zg_maxLength = 6;
}

- (void)setMoneyConfig {
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.zg_isPrice = YES;
    self.zg_priceIntLength = 9;
}

- (void)setSnConfig {
    self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
}

- (void)setNumberConfig {
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.zg_isNumber = YES;
}

- (void)setIdNumberConfig {
    self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.zg_maxLength = 18;
}

- (void)setEmailConfig {
    self.keyboardType = UIKeyboardTypeEmailAddress;
}

@end
