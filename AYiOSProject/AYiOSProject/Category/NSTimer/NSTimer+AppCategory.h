//   
//  NSTimer+AppCategory.h
//   
//  Created by alpha yu on 2024/8/14 
//   
   

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (AppCategory)

@end

@interface NSTimer (AppCountdown)

@property (nonatomic, assign) NSTimeInterval timerTotal;
@property (nonatomic, assign) NSTimeInterval timerInterval;
@property (nonatomic, copy) void (^timerActionBlock)(NSTimeInterval timeLeftInterval);
@property (nonatomic, copy, nullable) void (^timerEndActionBlock)(void);

/// 开始倒计时定时器
+ (NSTimer *)startCountdownTimerWithTotalSeconds:(NSTimeInterval)totalSeconds
                                        interval:(NSTimeInterval)interval
                               beforeActionBlock:(void (^ _Nullable)(void))beforeActionBlock
                                     actionBlock:(void (^)(NSTimeInterval timeLeftInterval))actionBlock
                                  endActionBlock:(void (^ _Nullable)(void))endActionBlock;

/// 结束倒计时定时器
- (void)stopCountdownTimer;

@end

NS_ASSUME_NONNULL_END
