//
//  PersonModel.h
//
//  Created by alpha yu on 2023/12/15
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 人物信息
@interface PersonModel : NSObject

@property (nonatomic, strong) NSNumber *id;     ///< 编号
@property (nonatomic, copy) NSString *name;     ///< 姓名
@property (nonatomic, copy) NSString *nickname; ///< 昵称
@property (nonatomic, copy) NSString *phoneNumber;  ///< 电话
@property (nonatomic, copy) NSString *avatar;   ///< 头像
@property (nonatomic, copy) NSString *gender;   ///< 性别
@property (nonatomic, copy) NSString *weight;   ///< 体重
@property (nonatomic, copy) NSString *height;   ///< 身高
@property (nonatomic, copy) NSString *birthday; ///< 生日
@property (nonatomic, copy) NSString *age;      ///< 年龄
@property (nonatomic, copy) NSString *idNumber; ///< 身份证号
@property (nonatomic, copy) NSString *remark;   ///< 备注
@property (nonatomic, copy) NSString *chatId;   ///< 聊天id

@end

NS_ASSUME_NONNULL_END
