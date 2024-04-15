//
//  NoticeBarView.h
//
//  Created by alpha yu on 2023/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 应用内推送通知栏
@interface NoticeBarView : UIView

@property (nonatomic, assign) NSTimeInterval autoDismissInterval;   ///< 自动收起时间（秒），默认 5秒
@property (nonatomic, copy) void (^tapActionBlock)(void);

- (void)setIcon:(NSString * _Nullable)icon
          title:(NSString * _Nullable)title
        content:(NSString * _Nullable)content
           time:(NSString * _Nullable)time;

- (void)show;

@end

NS_ASSUME_NONNULL_END
