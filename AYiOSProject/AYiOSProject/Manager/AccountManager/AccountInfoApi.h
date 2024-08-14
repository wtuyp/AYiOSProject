//   
//  AccountInfoApi.h
//   
//  Created by alpha yu on 2024/1/23 
//   
   

#import "NetworkBaseRequest.h"
#import "AccountInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 获取账户信息 请求
@interface AccountInfoApiRequest : NetworkBaseRequest

@end


@interface AccountInfoApiResponse : NSObject

@property (nonatomic, strong) AccountInfoModel *account;

@end

NS_ASSUME_NONNULL_END
