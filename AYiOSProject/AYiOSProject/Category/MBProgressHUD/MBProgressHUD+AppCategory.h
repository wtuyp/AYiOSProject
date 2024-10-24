//
//  MBProgressHUD+AppCategory.h
//
//  Created by MMM on 2021/7/6.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

extern const NSInteger AppHUDAutomaticallyHideSeconds;

@interface MBProgressHUD (AppCategory)

/*
 hideAfterDelay 传参分三种情况如下:
 - AppHUDAutomaticallyHideSeconds: 根据文本长度显示相应时长 (参见 secondsToHideWithText:)
 - 0: 一直显示;
 - 大于 0: 根据实际数值显示。
 
 在 showLoading 中默认 0；
 在 showWithText 中默认 AppHUDAutomaticallyHideSeconds.
 */

#pragma mark - 加载

+ (MBProgressHUD *)showLoading;
+ (MBProgressHUD *)showLoadingInView:(UIView * _Nullable)view;
+ (MBProgressHUD *)showLoadingInView:(UIView * _Nullable)view hideAfterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showLoadingWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view;
+ (MBProgressHUD *)showLoadingWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view hideAfterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showLoadingWithText:(NSString * _Nullable)text 
                            detailText:(NSString * _Nullable)detailText
                                inView:(UIView * _Nullable)view;
+ (MBProgressHUD *)showLoadingWithText:(NSString * _Nullable)text 
                            detailText:(NSString * _Nullable)detailText
                                inView:(UIView * _Nullable)view
                        hideAfterDelay:(NSTimeInterval)delay;

#pragma mark - 文本

+ (MBProgressHUD *)showWithText:(NSString *)text;
+ (MBProgressHUD *)showWithText:(NSString *)text inView:(UIView * _Nullable)view;
+ (MBProgressHUD *)showWithText:(NSString *)text inView:(UIView * _Nullable)view hideAfterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showWithText:(NSString *)text detailText:(NSString * _Nullable)detailText;
+ (MBProgressHUD *)showWithText:(NSString *)text detailText:(NSString * _Nullable)detailText inView:(UIView * _Nullable)view;
+ (MBProgressHUD *)showWithText:(NSString *)text 
                     detailText:(NSString * _Nullable)detailText
                         inView:(UIView * _Nullable)view
                 hideAfterDelay:(NSTimeInterval)delay;

#pragma mark - 带图标的文本

+ (MBProgressHUD *)showWithText:(NSString * _Nullable)text icon:(NSString * _Nullable)icon;
+ (MBProgressHUD *)showWithText:(NSString * _Nullable)text icon:(NSString * _Nullable)icon inView:(UIView * _Nullable)view;
+ (MBProgressHUD *)showWithText:(NSString * _Nullable)text 
                           icon:(NSString * _Nullable)icon
                         inView:(UIView * _Nullable)view
                 hideAfterDelay:(NSTimeInterval)delay;

/// 隐藏 tips
+ (void)hideAllTipsInView:(UIView *)view;
+ (void)hideAllTips;

/// 根据文本长度返回隐藏秒数，20字 2.0s，40字 2.5s，50字 3.0s，以上 3.5s
+ (NSTimeInterval)secondsToHideWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
