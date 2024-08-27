//   
//  NSTimer+AppCategory.m
//   
//  Created by alpha yu on 2024/8/14 
//   
   

#import "NSTimer+AppCategory.h"
#import "MacroObjc.h"

@implementation NSTimer (AppCategory)

@end

@implementation NSTimer (AppCountdown)

AppSynthesizeDoubleProperty(timerTotal, setTimerTotal)
AppSynthesizeDoubleProperty(timerInterval, setTimerInterval)
AppSynthesizeIdCopyProperty(timerActionBlock, setTimerActionBlock)
AppSynthesizeIdCopyProperty(timerEndActionBlock, setTimerEndActionBlock)

#pragma mark - public

+ (NSTimer *)startCountdownTimerWithTotalSeconds:(NSTimeInterval)totalSeconds
                                        interval:(NSTimeInterval)interval
                               beforeActionBlock:(void (^ _Nullable)(void))beforeActionBlock
                                     actionBlock:(void (^)(NSTimeInterval timeLeftInterval))actionBlock
                                  endActionBlock:(void (^ _Nullable)(void))endActionBlock {
    if (beforeActionBlock) {
        beforeActionBlock();
    }
    
    NSTimer *timer = [NSTimer app_scheduledTimerWithTimeInterval:interval block:^(NSTimer *timer) {
        [timer _app_timerAction];
    } repeats:YES];
    timer.timerTotal = totalSeconds;
    timer.timerInterval = interval;
    timer.timerActionBlock = actionBlock;
    timer.timerEndActionBlock = endActionBlock;
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    return timer;
}

- (void)stopCountdownTimer {
    if ([self isValid]) {
        [self invalidate];
    }
}

#pragma mark - private

- (void)_app_timerAction {
    self.timerTotal = self.timerTotal - self.timerInterval;
    if (self.timerTotal > 0) {
        // 倒计时进行
        self.timerActionBlock(self.timerTotal);
    } else {
        [self stopCountdownTimer];
        // 倒计时结束
        if (self.timerEndActionBlock) {
            self.timerEndActionBlock();
        }
    }
}

+ (void)_app_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)app_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_app_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

@end
