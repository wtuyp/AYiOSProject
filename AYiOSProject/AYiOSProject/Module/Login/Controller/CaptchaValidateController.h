//   
//  CaptchaValidateController.h
//   
//  Created by alpha yu on 2023/12/25 
//   
   

#import "AppBaseController.h"

NS_ASSUME_NONNULL_BEGIN

/// 输入验证码
@interface CaptchaValidateController : AppBaseController

@property (nonatomic, copy) NSString *phone;    ///< 电话号码

@end

NS_ASSUME_NONNULL_END
