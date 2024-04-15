//
//  MBProgressHUD+Tips.m
//
//  Created by MMM on 2021/7/6.
//

#import "MBProgressHUD+Tips.h"

const NSInteger TipsAutomaticallyHideToastSeconds = -1;

@implementation MBProgressHUD (Tips)

#pragma mark - Loading

+ (MBProgressHUD *)showLoadingInView:(UIView *)view {
    return [self showLoadingWithText:nil detailText:nil inView:view hideAfterDelay:0];
}

+ (MBProgressHUD *)showLoadingInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showLoadingWithText:nil detailText:nil inView:view hideAfterDelay:delay];
}

+ (MBProgressHUD *)showLoadingWithText:(NSString * _Nullable)text inView:(UIView *)view {
    return [self showLoadingWithText:text detailText:nil inView:view hideAfterDelay:0];
}

+ (MBProgressHUD *)showLoadingWithText:(NSString * _Nullable)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showLoadingWithText:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (MBProgressHUD *)showLoadingWithText:(NSString * _Nullable)text detailText:(NSString * _Nullable)detailText inView:(UIView *)view {
    return [self showLoadingWithText:text detailText:detailText inView:view hideAfterDelay:0];
}

+ (MBProgressHUD *)showLoadingWithText:(NSString * _Nullable)text detailText:(NSString * _Nullable)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [self MBProgressHUDToView:view];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = text;
    hud.detailsLabel.text = detailText;
    [hud showAnimated:YES];
    if (delay == TipsAutomaticallyHideToastSeconds) {
        CGFloat delay = [self smartDelaySecondsForTipsText:text];
        [hud hideAnimated:YES afterDelay:delay];
    } else if (delay > 0) {
        [hud hideAnimated:YES afterDelay:delay];
    }
    return hud;
}

#pragma mark - Text

+ (MBProgressHUD *)showWithText:(NSString *)text {
    return [self showWithText:text detailText:nil inView:WINDOW hideAfterDelay:TipsAutomaticallyHideToastSeconds];
}

+ (MBProgressHUD *)showWithText:(NSString *)text inView:(UIView *)view {
    return [self showWithText:text detailText:nil inView:view hideAfterDelay:TipsAutomaticallyHideToastSeconds];
}

+ (MBProgressHUD *)showWithText:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showWithText:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (MBProgressHUD *)showWithText:(NSString *)text detailText:(NSString * _Nullable)detailText {
    return [self showWithText:text detailText:detailText inView:WINDOW hideAfterDelay:TipsAutomaticallyHideToastSeconds];
}

+ (MBProgressHUD *)showWithText:(NSString *)text detailText:(NSString * _Nullable)detailText inView:(UIView *)view {
    return [self showWithText:text detailText:detailText inView:view hideAfterDelay:TipsAutomaticallyHideToastSeconds];
}

+ (MBProgressHUD *)showWithText:(NSString *)text detailText:(NSString * _Nullable)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    if (text.length == 0) {
        return nil;
    }
    
    MBProgressHUD *hud = [self MBProgressHUDToView:view];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.detailsLabel.text = detailText;
    [hud showAnimated:YES];
    if (delay == TipsAutomaticallyHideToastSeconds) {
        CGFloat delay = [self smartDelaySecondsForTipsText:text];
        [hud hideAnimated:YES afterDelay:delay];
    } else if (delay > 0) {
        [hud hideAnimated:YES afterDelay:delay];
    }
    return hud;
    
//    return [self showInfo:text detailText:detailText inView:view hideAfterDelay:delay];
}

#pragma mark - 带图标的提示

+ (MBProgressHUD *)showWithText:(NSString * _Nullable)text icon:(NSString * _Nullable)icon {
    return [self showWithText:text icon:icon inView:WINDOW hideAfterDelay:TipsAutomaticallyHideToastSeconds];
}

+ (MBProgressHUD *)showWithText:(NSString * _Nullable)text icon:(NSString * _Nullable)icon inView:(UIView *)view {
    return [self showWithText:text icon:icon inView:view hideAfterDelay:TipsAutomaticallyHideToastSeconds];
}

+ (MBProgressHUD *)showWithText:(NSString * _Nullable)text icon:(NSString * _Nullable)icon inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [self MBProgressHUDToView:view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self createCustomViewWithImageName:icon
                                               labelText:text];
    [hud showAnimated:YES];
    if (delay == TipsAutomaticallyHideToastSeconds) {
        CGFloat delay = [self smartDelaySecondsForTipsText:text];
        [hud hideAnimated:YES afterDelay:delay];
    } else if (delay > 0) {
        [hud hideAnimated:YES afterDelay:delay];
    }
    return hud;
}

+ (void)hideAllTipsInView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:NO];
}

+ (void)hideAllTips {
    [self hideAllTipsInView:WINDOW];
}

+ (MBProgressHUD *)MBProgressHUDToView:(UIView *)view {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view ?: WINDOW];
    hud.removeFromSuperViewOnHide = YES;
    hud.contentColor = UIColor.whiteColor;
    hud.margin = 10;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor.blackColor colorWithAlphaComponent:0.8f];
    [hud.bezelView setCornerRadius:8];
    hud.label.font = FONT(13);
    hud.label.numberOfLines = 0;
    hud.label.preferredMaxLayoutWidth = SCREEN_WIDTH - 140;
    hud.detailsLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 140;
    [view addSubview:hud];
    return hud;
}

+ (NSTimeInterval)smartDelaySecondsForTipsText:(NSString *)text {
    NSUInteger length = 0;
    for (NSUInteger i = 0, l = text.length; i < l; i++) {
        unichar character = [text characterAtIndex:i];
        if (isascii(character)) {
            length += 1;
        } else {
            length += 2;
        }
    }
    if (length <= 20) {
        return 1.5;
    } else if (length <= 40) {
        return 2.0;
    } else if (length <= 50) {
        return 2.5;
    } else {
        return 3.0;
    }
}

#pragma mark - 自定义View

+ (UIView *)createCustomViewWithImageName:(NSString *)imageName
                                labelText:(NSString *)labelText {
    UIView *view = [[UIView alloc] init];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:IMAGE(imageName)];
    UILabel *label = [[UILabel alloc] init];
    label.font = FONT(13);
    label.text = labelText;
    label.textColor = UIColor.whiteColor;
    label.numberOfLines = 0;
    
    [view addSubview:icon];
    [view addSubview:label];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(8);
        make.right.mas_equalTo(-10);
        make.top.bottom.inset(3);
    }];

    return view;
}

@end
