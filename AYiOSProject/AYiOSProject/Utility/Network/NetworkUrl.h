//   
//  NetworkUrl.h
//
//  Created by alpha yu on 2023/12/15 
//   
   

#ifndef NetworkUrl_h
#define NetworkUrl_h

#if DEBUG

/// 开发环境
#define BASE_URL    @"https://www.ay.com"
//#define IM_BASE_URL @"https://"
//#define SOCKET_URL  @"https://"

#else

// 正式环境
#define BASE_URL    @"https://www.ay.com"
//#define IM_BASE_URL @"https://"
//#define SOCKET_URL  @"https://"

#endif

#endif /* NetworkUrl_h */
