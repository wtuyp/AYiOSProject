//   
//  AppAgreementPopupView.h
//   
//  Created by alpha yu on 2024/1/22 
//   
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 用户协议弹窗
@interface AppAgreementPopupView : UIView

@property (nonatomic, copy) void (^resultBlock)(BOOL isAgree);

+ (BOOL)isShowed;

@end

NS_ASSUME_NONNULL_END
