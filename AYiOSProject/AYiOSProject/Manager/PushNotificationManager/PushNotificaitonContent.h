//   
//  PushNotificaitonContent.h
//   
//  Created by alpha yu on 2024/1/16 
//   
   

#import <Foundation/Foundation.h>

/// 推送消息类型
typedef NS_ENUM(NSInteger, PushNotificaitonContentType) {
    PushNotificaitonContentTypeChat = 1,    ///< 聊天
};

NS_ASSUME_NONNULL_BEGIN

@interface PushNotificaitonContent : NSObject

@property (nonatomic, assign) PushNotificaitonContentType type;

@end

NS_ASSUME_NONNULL_END
