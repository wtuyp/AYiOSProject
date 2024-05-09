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
@property (nonatomic, assign) CGRect reactionBounds;
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
    self.itemTextFont = FONT(10);
    
    self.itemSpace = 8;
    self.itemSize = 16;
    
    self.itemSelectedTextColor = COLOR_HEX(#000000);
    self.itemSelectedBgColor = UIColor.clearColor;
    self.itemBgCornerRadius = 3;

    [self updateUI];
}

- (void)updateUI {
    self.backgroundColor = self.trackBarBackgroundColor;
    [self setCornerRadius:self.trackBarRadius];
}

#pragma mark - override

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.trackBarWidth, (self.stringArray.count + 1) * self.itemSize);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return;
    }
    
    __block NSInteger index = -1;
    __block UILabel *selectedLabel = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint([self extentedFrameWithView:obj], point)) {
            index = idx;
            selectedLabel = obj;
            obj.textColor = self.itemSelectedTextColor;
            obj.backgroundColor = self.itemSelectedBgColor;
        } else {
            obj.textColor = self.itemTextColor;
            obj.backgroundColor = UIColor.clearColor;
        }
    }];
        
    if (index != -1) {
        [self.generator impactOccurred];
        
        NSString *letter = self.stringArray[index];
        self.selectedString = letter;
        self.touchPoint = selectedLabel.center;

        if (self.indicatorView.superview) {
            [self.indicatorView showIndicatorWithText:letter];
        }
        
        if ([self.delegate respondsToSelector:@selector(appTableIndexView:text:index:)]) {
            [self.delegate appTableIndexView:self text:letter index:index];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return;
    }

    __block NSInteger index = -1;
    __block UILabel *selectedLabel = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint([self extentedFrameWithView:obj], point)) {
            index = idx;
            selectedLabel = obj;
            obj.textColor = self.itemSelectedTextColor;
            obj.backgroundColor = self.itemSelectedBgColor;
        } else {
            obj.textColor = self.itemTextColor;
            obj.backgroundColor = UIColor.clearColor;
        }
    }];

    if (index != -1) {
        NSString *letter = self.stringArray[index];
        if ([self.selectedString isEqualToString:letter]) {
            return;
        }
        
        [self.generator impactOccurred];
        
        self.selectedString = letter;
        self.touchPoint = selectedLabel.center;

        if (self.indicatorView.superview) {
            [self.indicatorView showIndicatorWithText:letter];
        }
        
        if ([self.delegate respondsToSelector:@selector(appTableIndexView:text:index:)]) {
            [self.delegate appTableIndexView:self text:letter index:index];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.indicatorView.superview) {
        [self.indicatorView dismissIndicator];
    }
    
    if ([self.delegate respondsToSelector:@selector(appTableIndexViewEndAction)]) {
        [self.delegate appTableIndexViewEndAction];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
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
        UILabel *textLabel = [UILabel labelWithColor:self.itemTextColor font:self.itemTextFont text:string];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [textLabel setCornerRadius:self.itemBgCornerRadius clip:YES];
        [self addSubview:textLabel];
    }
    
    [self verticalLayoutCenterAlignSubviewsWithItemWidth:self.itemSize itemHeight:self.itemSize itemSpacing:self.itemSpace topSpacing:self.itemSpace / 2.0 bottomSpacing:self.itemSpace / 2.0];
}

- (void)itemSelectedWithIndexText:(NSString *)indexText {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.text isEqualToString:indexText]) {
            obj.textColor = self.itemSelectedTextColor;
            obj.backgroundColor = self.itemSelectedBgColor;
        } else {
            obj.textColor = self.itemTextColor;
            obj.backgroundColor = UIColor.clearColor;
        }
    }];
}


#pragma mark - private

- (CGRect)extentedFrameWithView:(UIView *)view {
    UIEdgeInsets touchAreaInsets = UIEdgeInsetsMake(self.itemSpace / 2.0, 20, self.itemSpace / 2.0, 10);
    CGRect frame = view.frame;
    frame = CGRectMake(frame.origin.x - touchAreaInsets.left,
                       frame.origin.y - touchAreaInsets.top,
                       frame.size.width + touchAreaInsets.left + touchAreaInsets.right,
                       frame.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return frame;
}

@end

@interface AppTableIndexIndicatorView ()

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
    
    self.textColor = COLOR_HEX(#000000);
    self.textFont = FONT(32);

    self.backgroundColor = UIColor.whiteColor;
    [self setCornerRadius:SCALE(24)];
    [self setShadowWithColor:[COLOR_HEX(#30353B) colorWithAlphaComponent:0.1] opacity:1 offset:CGSizeMake(0, 4) radius:10];
    
    [self.textLabel setColor:self.textColor font:self.textFont];
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
    }
    return _textLabel;
}

- (NSString *)indicatorText {
    return self.textLabel.text;
}

#pragma mark - setter

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    self.textLabel.textColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    
    self.textLabel.font = textFont;
}

#pragma mark - action


#pragma mark - api


#pragma mark - notification


#pragma mark - public


#pragma mark - private


#pragma mark - AppTableIndexIndicatorViewProtocol

- (void)showIndicatorWithText:(NSString *)text {
    self.textLabel.text = text;
    self.hidden = NO;
}

- (void)dismissIndicator {
    self.hidden = YES;
}

@end
