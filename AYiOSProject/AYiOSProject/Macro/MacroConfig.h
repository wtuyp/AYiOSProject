//   
//  MacroConfig.h
//   
//  Created by alpha yu on 2023/12/20 
//   
   

#ifndef MacroConfig_h
#define MacroConfig_h

// 导航栏配置
#define NAVI_BAR_TITLE_COLOR            UIColor.blackColor
#define NAVI_BAR_TITLE_FONT             FONT_BOLD(19)
#define NAVI_BAR_BACK_IMAGE             IMAGE(@"icon_navi_back_black")
#define NAVI_BAR_COLOR                  UIColor.whiteColor

// Tab栏配置
#define TAB_BAR_TITLE_NORMAL_COLOR      COLOR_HEX(#717171)
#define TAB_BAR_TITLE_SELECTED_COLOR    COLOR_HEX(#837CF4)
#define TAB_BAR_TITLE_FONT              FONT_BOLD(9)
#define TAB_BAR_COLOR                   UIColor.whiteColor

// 默认背景色
#define DEFAULT_BG_COLOR                COLOR_HEX(#F7F7F7)
// 默认图片背景色
#define DEFAULT_IMAGE_BG_COLOR          COLOR_HEX(#ECECEC)
// 默认图片
#define DEFAULT_IMAGE                   IMAGE(@"icon_default_100")

/// 时间戳使用毫秒，1:使用，0:不使用
#define TIMESTAMP_MILLISECOND_ENABLE    1

// 用户协议
#define URL_USER_AGREEMENT              @"http://www.ay.com/user"
// 隐私政策
#define URL_PRIVACY_POLICY              @"http://www.ay.com/privacy"

// key 前缀
#define APP_KEY_PREFIX                  @"ay.app.key."

#endif /* MacroConfig_h */
