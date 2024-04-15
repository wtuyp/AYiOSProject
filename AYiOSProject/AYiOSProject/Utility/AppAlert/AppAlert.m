//   
//  AppAlert.m
//
//  Created by alpha yu on 2023/2/16
//   

#import "AppAlert.h"
#import "LEEAlert.h"

@interface AppAlert ()

@end

@implementation AppAlert

+ (void)showAlertWithTitle:(NSString *)title
                   content:(NSString *)content
               cancelTitle:(NSString * _Nullable)cancelTitle
               actionTitle:(NSString * _Nullable)actionTitle
               actionBlock:(void (^ _Nullable)(void))actionBlock {
    [self showAlertWithTitle:title
                     content:content
                 cancelTitle:cancelTitle
                 actionTitle:actionTitle
                 cancelBlock:nil
                 actionBlock:actionBlock];
}

+ (void)showAlertWithTitle:(NSString *)title
                   content:(NSString *)content
               cancelTitle:(NSString * _Nullable)cancelTitle
               actionTitle:(NSString * _Nullable)actionTitle
               cancelBlock:(void (^ _Nullable)(void))cancelBlock
               actionBlock:(void (^ _Nullable)(void))actionBlock {
    // warning: 不能合并起来写，像这样 LEEBaseConfigModel *config = [LEEAlert alert].config 会无法显示。
    LEEAlertConfig *alert = [LEEAlert alert];
    LEEBaseConfigModel *config = alert.config;
    config
    .LeeAddTitle(^(UILabel * _Nonnull label) {
        label.text = title;
        label.textColor = COLOR_HEX(#000000);
        label.font = FONT_BOLD(16);
    })
    .LeeAddContent(^(UILabel * _Nonnull label) {
        NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
        pStyle.lineSpacing = 6;
        pStyle.alignment = NSTextAlignmentCenter;
        
        label.attributedText = [[NSAttributedString alloc] initWithString:content attributes:@{
            NSForegroundColorAttributeName: COLOR_HEX(#636363),
            NSFontAttributeName: FONT_BOLD(13),
            NSParagraphStyleAttributeName: pStyle
        }];
    });
    if (cancelTitle) {
        config.LeeAddAction(^(LEEAction * _Nonnull action) {
            action.type = LEEActionTypeDefault;
            action.title = cancelTitle;
            action.titleColor = COLOR_HEX(#B8B8B8);
            action.font = FONT_BOLD(15);
            action.backgroundHighlightColor = [UIColor whiteColor];
            action.borderColor = COLOR_HEX(#E6E6E6);
            if (cancelBlock) {
                action.clickBlock = cancelBlock;
            }
        });
    }
    if (actionTitle) {
        config.LeeAddAction(^(LEEAction * _Nonnull action) {
            action.type = LEEActionTypeDefault;
            action.title = actionTitle;
            action.titleColor = COLOR_HEX(#8177FC);
            action.font = FONT_BOLD(15);
            action.backgroundHighlightColor = [UIColor whiteColor];
            action.borderColor = COLOR_HEX(#E6E6E6);
            if (actionBlock) {
                action.clickBlock = actionBlock;
            }
        });
    }
    
    config
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 10, 10, 10))
    .LeeCornerRadius(10)
    .LeeMaxWidth(SCALE(266))
    .LeeBackGroundColor(COLOR_HEX(#8A8A8A))
    .LeeBackgroundStyleTranslucent(0.5)
    .LeeShadowOpacity(0)
    .LeeShadowColor(UIColor.clearColor)
    .LeeOpenAnimationDuration(0.25)
    .LeeOpenAnimationStyle(LEEAnimationStyleFade)
    .LeeCloseAnimationDuration(0.25)
    .LeeCloseAnimationStyle(LEEAnimationStyleFade)
    .LeeShow();
}

+ (void)dimissAlert {
    [LEEAlert closeWithCompletionBlock:nil];
}

@end
