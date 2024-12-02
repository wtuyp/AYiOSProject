//   
//  MacroUrl.h
//   
//  Created by alpha yu on 2024/8/28 
//   
   

#ifndef MacroUrl_h
#define MacroUrl_h

#if DEBUG

/// 开发环境
#define URL_NETWORK_REQUEST         @"https://www.ay.com"
//#define URL_IM                      @"https://"
//#define URL_SOCKET                  @"https://"

#else

// 正式环境
#define URL_NETWORK_REQUEST         @"https://www.ay.com"
//#define URL_IM                      @"https://"
//#define URL_SOCKET                  @"https://"

#endif

// 用户协议
#define URL_USER_AGREEMENT          @"http://www.ay.com/user"
// 隐私政策
#define URL_PRIVACY_POLICY          @"http://www.ay.com/privacy"

#endif /* MacroUrl_h */
