//   
//   AppTableIndexView.m
//   
//   Created by alpha yu on 2023/5/19 
//   
   

#import "AppTableIndexView.h"
#import "UIView+AppLayout.h"

@interface AppTableIndexView ()

@property (nonatomic, copy) NSArray<NSString *> *stringArray;
@property (nonatomic, copy) NSString *selectedString;

@property (nonatomic, assign) CGPoint touchPoint;
@property (nonatomic, strong) UIImpactFeedbackGenerator *generator; ///< 触感反馈

@end

@implementation AppTableIndexView

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
    self.hidden = YES;
    
    self.trackBarBackgroundColor = COLOR_HEX(#F4F4F4);
    self.trackBarWidth = 16;
    self.trackBarRadius = 8;
    
    self.itemTextColor = COLOR_HEX(#323232);
    self.itemFont = FONT(10);
    self.itemSpace = 8;

    [self updateUI];
}

- (void)updateUI {
    self.backgroundColor = self.trackBarBackgroundColor;
    [self setCornerRadius:self.trackBarRadius];
}

#pragma mark - override

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    
    __block NSInteger index = -1;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint([self extentedFrameWithView:obj], point)) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index != -1) {
        
        NSString *letter = self.stringArray[index];
        self.selectedString = letter;
        [self.generator impactOccurred];
        self.touchPoint = point;
        
        if ([self.delegate respondsToSelector:@selector(appTableIndexView:text:index:)]) {
            [self.delegate appTableIndexView:self text:letter index:index];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];

    __block NSInteger index = -1;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint([self extentedFrameWithView:obj], point)) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index != -1) {
        NSString *letter = self.stringArray[index];
        if ([self.selectedString isEqualToString:letter]) {
            return;
        }
        
        self.selectedString = letter;
        [self.generator impactOccurred];
        self.touchPoint = point;
        
        if ([self.delegate respondsToSelector:@selector(appTableIndexView:text:index:)]) {
            [self.delegate appTableIndexView:self text:letter index:index];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(appTableIndexViewEndAction)]) {
        [self.delegate appTableIndexViewEndAction];
    }
}

#pragma mark - getter


- (UIImpactFeedbackGenerator *)generator {
    if (!_generator) {
        _generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [_generator prepare];
    }
    return _generator;
}

- (UIView<AppTableIndexIndicatorViewProtocol> *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[AppTableIndexIndicatorView alloc] init];
    }
    return _indicatorView;
}

#pragma mark - setter

- (void)setTrackBarBackgroundColor:(UIColor *)trackBarBackgroundColor {
    _trackBarBackgroundColor = trackBarBackgroundColor;
    
    [self updateUI];
}

#pragma mark - action


#pragma mark - api


#pragma mark - notification


#pragma mark - public

- (void)updateIndexTextArray:(NSArray<NSString *> *)textArray {
    self.hidden = textArray.count == 0 ? YES : NO;

    self.stringArray = textArray;
    
    [self removeAllSubviews];
    
    for (NSString *string in self.stringArray) {
        UILabel *textLabel = [UILabel labelWithColor:self.itemTextColor font:self.itemFont text:string];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textLabel];
    }
    
    [self verticalLayoutSubviewsWithItemWidth:self.trackBarWidth itemHeight:14 itemSpacing:self.itemSpace topSpacing:self.itemSpace / 2.0 bottomSpacing:self.itemSpace / 2.0 leadSpacing:0 tailSpacing:0];
}

#pragma mark - private

- (CGRect)extentedFrameWithView:(UIView *)view {
    UIEdgeInsets touchAreaInsets = UIEdgeInsetsMake(0, 20, 0, 10);
    CGRect frame = view.frame;
    frame = CGRectMake(frame.origin.x - touchAreaInsets.left,
                       frame.origin.y - touchAreaInsets.top,
                       frame.size.width + touchAreaInsets.left + touchAreaInsets.right,
                       frame.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return frame;
}

@end

@interface AppTableIndexIndicatorView ()

@property (nonatomic, copy) NSString *indicatorText;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation AppTableIndexIndicatorView

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
    self.hidden = YES;

    self.backgroundColor = UIColor.whiteColor;
    [self setCornerRadius:SCALE(24)];
    [self setShadowWithColor:[COLOR_HEX(#30353B) colorWithAlphaComponent:0.1] opacity:1 offset:CGSizeMake(0, 4) radius:10];
    
    [self addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)updateUI {
    
}

#pragma mark - override

- (CGSize)intrinsicContentSize {
    return CGSizeMake(SCALE(48), SCALE(48));
}

#pragma mark - getter

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        [_textLabel setColor:COLOR_HEX(#000000) font:FONT(32)];
    }
    return _textLabel;
}

#pragma mark - setter

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    self.textLabel.textColor = textColor;
}

#pragma mark - action


#pragma mark - api


#pragma mark - notification


#pragma mark - public

- (void)showIndicatorWithText:(NSString *)text {
    self.indicatorText = text;
    self.textLabel.text = text;
    self.hidden = NO;
}

- (void)dismissIndicator {
    self.hidden = YES;
}

#pragma mark - private


@end
