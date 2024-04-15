//   
//  AccountInfoModel.h
//   
//  Created by alpha yu on 2023/12/15 
//   
   

#import <Foundation/Foundation.h>
#import "PersonModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 账号信息
@interface AccountInfoModel : PersonModel

@property (nonatomic, assign) BOOL hasSetPassword;  ///< 是否已设置密码

@end

NS_ASSUME_NONNULL_END
