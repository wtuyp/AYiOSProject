//
//  MBProgressHUD+Tips.h
//
//  Created by MMM on 2021/7/6.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

extern const NSInteger TipsAutomaticallyHideToastSeconds;

@interface MBProgressHUD (Tips)

#pragma mark - Loading

+ (MBProgressHUD *)showLoadingInView:(UIView *)view;
+ (MBProgressHUD *)showLoadingInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showLoadingWithText:(NSString * _Nullable)text inView:(UIView *)view;
+ (MBProgressHUD *)showLoadingWithText:(NSString * _Nullable)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showLoadingWithText:(NSString * _Nullable)text detailText:(NSString * _Nullable)detailText inView:(UIView *)view;
+ (MBProgressHUD *)showLoadingWithText:(NSString * _Nullable)text detailText:(NSString * _Nullable)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

#pragma mark - Text

+ (MBProgressHUD *)showWithText:(NSString *)text;
+ (MBProgressHUD *)showWithText:(NSString *)text inView:(UIView *)view;
+ (MBProgressHUD *)showWithText:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showWithText:(NSString *)text detailText:(NSString * _Nullable)detailText;
+ (MBProgressHUD *)showWithText:(NSString *)text detailText:(NSString * _Nullable)detailText inView:(UIView *)view;
+ (MBProgressHUD *)showWithText:(NSString *)text detailText:(NSString * _Nullable)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

#pragma mark - 带图标的提示

+ (MBProgressHUD *)showWithText:(NSString * _Nullable)text icon:(NSString * _Nullable)icon;
+ (MBProgressHUD *)showWithText:(NSString * _Nullable)text icon:(NSString * _Nullable)icon inView:(UIView *)view;
+ (MBProgressHUD *)showWithText:(NSString * _Nullable)text icon:(NSString * _Nullable)icon inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

/// 隐藏 tips
+ (void)hideAllTipsInView:(UIView *)view;
+ (void)hideAllTips;

/// 自动隐藏 toast 可以使用这个方法自动计算秒数，20字 1.5s，40字 2.0s，50字 2.5s，以上 3s
+ (NSTimeInterval)smartDelaySecondsForTipsText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
