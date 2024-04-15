//
//  NoticeBarView.m
//
//  Created by alpha yu on 2023/1/17.
//

#import "NoticeBarView.h"
#import "UIView+AppCategory.h"
#import "UILabel+AppCategory.h"

@interface NoticeBarViewManager : NSObject

@property (nonatomic, strong, readonly) UIWindow *window;
@property (nonatomic, strong) NSMutableArray<NoticeBarView *> *barViews;

+ (instancetype)shareInstance;
- (void)showNoticeBarView:(NoticeBarView *)view;
- (void)dismissNoticeBarView:(NoticeBarView *)view;

@end

@interface NoticeBarView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong, nullable) NSTimer *dismissTimer;

- (void)stopTimer;

@end

@implementation NoticeBarView

#pragma mark - life

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (void)setupInit {
    self.layer.cornerRadius = 6;
    self.layer.shadowColor = COLOR_HEX(#0A0E5129).CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 10;
    
    self.autoDismissInterval = 5.0;

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualView.layer.cornerRadius = SCALE(6);
    visualView.layer.masksToBounds = YES;
    visualView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.45];
    [self addSubview:visualView];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.timeLabel];
    
    [visualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALE(10));
        make.left.mas_equalTo(SCALE(12));
        make.size.mas_equalTo(SCALE(20));
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(SCALE(6));
        make.right.mas_equalTo(-SCALE(12));
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.right.mas_equalTo(-SCALE(12));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(SCALE(6));
        make.left.right.inset(SCALE(12));
        make.bottom.mas_equalTo(-SCALE(10));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

#pragma mark - override

- (CGSize)intrinsicContentSize {
    return CGSizeMake(SCREEN_WIDTH - SCALE(24), SCALE(83));
}

#pragma mark - getter

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [_iconImageView setCornerRadius:SCALE(10)];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithColor:UIColor.blackColor font:FONT_BOLD(14)];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel labelWithColor:UIColor.blackColor font:FONT(13)];
        _contentLabel.numberOfLines = 2;
    }
    return _contentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithColor:COLOR_HEX(#969696) font:FONT(12)];
    }
    return _timeLabel;
}

#pragma mark - setter


#pragma mark - action

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (self.tapActionBlock) {
        self.tapActionBlock();
    }
    [self stopTimer];
    [self removeFromSuperview];
}

#pragma mark - api


#pragma mark - notification


#pragma mark - public

- (void)setIcon:(NSString * _Nullable)icon title:(NSString * _Nullable)title content:(NSString * _Nullable)content time:(NSString * _Nullable)time {
    if ([icon containsString:@"http"]) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:IMAGE_DEFAULT];
    } else {
        self.iconImageView.image = IMAGE(icon);
    }
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    self.timeLabel.text = time;
}

- (void)show {
    [[NoticeBarViewManager shareInstance] showNoticeBarView:self];
}

- (void)dismiss {
    [[NoticeBarViewManager shareInstance] dismissNoticeBarView:self];
}

- (void)stopTimer {
    if (self.dismissTimer.valid) {
        [self.dismissTimer invalidate];
    }
    self.dismissTimer = nil;
}

#pragma mark - private


#pragma mark - other


@end




@implementation NoticeBarViewManager

+ (instancetype)shareInstance {
    static NoticeBarViewManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NoticeBarViewManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.barViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)showNoticeBarView:(NoticeBarView *)view {
    UIWindow *window = self.window;
    [window addSubview:view];
    [self.barViews addObject:view];

    CGSize size = [view.contentLabel.text sizeForFont:FONT(13) size:CGSizeMake(SCREEN_WIDTH - SCALE(48), 40) mode:NSLineBreakByWordWrapping];
    
    view.width = SCREEN_WIDTH - SCALE(24);
    view.height = SCALE(46) + ceil(size.height);
    view.bottom = window.top;
    view.centerX = SCREEN_WIDTH / 2.0;

    [UIView animateWithDuration:0.25 animations:^{
        view.top = STATUS_BAR_HEIGHT;
    } completion:^(BOOL finished) {
        if (view != self.barViews.lastObject) {
            return;
        }
        
        for (NSInteger i = self.barViews.count - 1; i >= 0; i--) {
            NoticeBarView *barView = self.barViews[i];
            if (barView != self.barViews.lastObject) {
                [barView stopTimer];
                [barView removeFromSuperview];
                [self.barViews removeObject:barView];
            }
        }

        [view stopTimer];
        
        WEAK_SELF
        WEAK_OBJ(view)
        view.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:view.autoDismissInterval block:^(NSTimer * _Nonnull timer) {
            STRONG_SELF
            STRONG_OBJ(view)
            [self dismissNoticeBarView:view];
        } repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:view.dismissTimer forMode:NSRunLoopCommonModes];
    }];
}

- (void)dismissNoticeBarView:(NoticeBarView *)view {
    if (view == self.barViews.lastObject) {
        UIWindow *window = self.window;
        [UIView animateWithDuration:0.25 animations:^{
            view.bottom = window.top;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    } else {
        [view stopTimer];
        [view removeFromSuperview];
    }
}

- (UIWindow *)window {
    return [UIApplication sharedApplication].keyWindow;
}

@end
