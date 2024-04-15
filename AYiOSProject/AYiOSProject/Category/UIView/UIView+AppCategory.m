//
//  UIView+AppCategory.m
//
//  Created by alpha yu on 2023/1/26
//

#import "UIView+AppCategory.h"

@implementation UIView (AppCategory)

+ (UIView *)viewWithColor:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    return view;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self setCornerRadius:cornerRadius clip:NO];
}

- (void)setCornerRadius:(CGFloat)cornerRadius clip:(BOOL)clip {
    self.layer.masksToBounds = clip;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
             rectCorner:(UIRectCorner)rectCorner {    
    [self setCornerRadius:cornerRadius rectCorner:rectCorner clip:NO];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
             rectCorner:(UIRectCorner)rectCorner
                   clip:(BOOL)clip {
    [self setCornerRadius:cornerRadius clip:clip];
    self.layer.maskedCorners = (CACornerMask)rectCorner;
}

- (void)setBorderWidth:(CGFloat)borderWidth
           borderColor:(nullable UIColor *)borderColor {
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
            borderWidth:(CGFloat)borderWidth
            borderColor:(nullable UIColor *)borderColor {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setShadowWithColor:(UIColor *)color
                   opacity:(CGFloat)opacity
                    offset:(CGSize)offset
                    radius:(CGFloat)radius {
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
}

@end

@implementation UIView (AppAddLine)

- (void)addBottomLineWithColor:(UIColor *)color {
    [self addBottomLineWithColor:color inset:0];
}

- (void)addBottomLineWithColor:(UIColor *)color inset:(CGFloat)inset {
    [self addBottomLineWithColor:color leftPadding:inset rightPadding:inset];
}

- (void)addBottomLineWithColor:(UIColor *)color
                   leftPadding:(CGFloat)leftPadding
                  rightPadding:(CGFloat)rightPadding {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = color;
    
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(leftPadding);
        make.right.mas_equalTo(-rightPadding);
    }];
}

- (void)addTopLineWithColor:(UIColor *)color {
    [self addTopLineWithColor:color inset:0];
}

- (void)addTopLineWithColor:(UIColor *)color inset:(CGFloat)inset {
    [self addTopLineWithColor:color leftPadding:inset rightPadding:inset];
}

- (void)addTopLineWithColor:(UIColor *)color
                leftPadding:(CGFloat)leftPadding
               rightPadding:(CGFloat)rightPadding {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = color;
    
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(leftPadding);
        make.right.mas_equalTo(-rightPadding);
    }];
}

@end
