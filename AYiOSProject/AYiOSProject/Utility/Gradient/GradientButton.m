//
//  GradientButton.m
//
//  Created by yxg on 2022/10/20.
//

#import "GradientButton.h"
#import "UIView+AppCategory.h"

@interface GradientButton ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end


@implementation GradientButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _colors = @[COLOR_HEX(#1B78FF), COLOR_HEX(#2AA5FF)];
        _locations = @[@(0.0f), @(1.0f)];
        _direction = GradientDirectionLeftToRight;
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

#pragma mark - 初始化UI

- (void)initUI {

}

#pragma mark - 懒加载

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = ({
            CAGradientLayer *layer = [CAGradientLayer layer];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.colors.count];
            for (UIColor *color in self.colors) {
                [array appendObject:(__bridge id)color.CGColor];
            }
            layer.colors = array;
            layer.locations = self.locations;
            layer.startPoint = CGPointMake(0, 0);
            layer.endPoint = CGPointMake(1, 0);
            layer.frame = self.bounds;
            layer;
        });
    }
    return _gradientLayer;
}

#pragma mark - 更新UI

- (void)updateUI {

}

#pragma mark - Setter

- (void)setColors:(NSArray<UIColor *> *)colors {
    _colors = colors;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [array appendObject:(__bridge id)color.CGColor];
    }
    self.gradientLayer.colors = array;
}

- (void)setLocations:(NSArray<NSNumber *> *)locations {
    _locations = locations;
    self.gradientLayer.locations = locations;
}

- (void)setDirection:(GradientDirection)direction {
    _direction = direction;
    switch (direction) {
        case GradientDirectionLeftToRight: // 从左到右
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(1, 0);
            break;
        case GradientDirectionRightToLeft: // 从右到左
            self.gradientLayer.startPoint = CGPointMake(1, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 0);
            break;
        case GradientDirectionTopToBottom: // 从上到下
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            break;
        case GradientDirectionBottomToTop: // 从下到上
            self.gradientLayer.startPoint = CGPointMake(0, 1);
            self.gradientLayer.endPoint = CGPointMake(0, 0);
            break;
        case GradientDirectionTopLeftToBottomRight: // 从左上到右下
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(1, 1);
            break;
        case GradientDirectionBottomLeftToTopRight: // 从左下到右上
            self.gradientLayer.startPoint = CGPointMake(0, 1);
            self.gradientLayer.endPoint = CGPointMake(1, 0);
            break;
        case GradientDirectionTopRightToBottomLeft: // 从右上到左下
            self.gradientLayer.startPoint = CGPointMake(1, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            break;
        case GradientDirectionBottomRightToTopLeft: // 从右下到左上
            self.gradientLayer.startPoint = CGPointMake(1, 1);
            self.gradientLayer.endPoint = CGPointMake(0, 0);
            break;
        default:
            break;
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (self.disableColors) {
        NSArray *colors = enabled ? self.colors : self.disableColors;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:colors.count];
        for (UIColor *color in colors) {
            [array appendObject:(__bridge id)color.CGColor];
        }
        self.gradientLayer.colors = array;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [super setCornerRadius:cornerRadius];
    
    self.gradientLayer.masksToBounds = YES;
    self.gradientLayer.cornerRadius = cornerRadius;
}

@end
