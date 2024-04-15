//
//  BadgeView.m
//  IslandPost
//
//  Created by yxg on 2021/10/13.
//

#import "BadgeView.h"

@interface BadgeView ()

@property (nonatomic, strong) UILabel *numberLabel;

@end


@implementation BadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _height = SCALE(13);
        _numberFont = FONT(9);
        _numberTextColor = UIColor.whiteColor;
        _number = 0;
        [self initUI];
    }
    return self;
}

#pragma mark - 初始化UI

- (void)initUI {
    self.colors = @[COLOR_HEX(#FF0000), COLOR_HEX(#FF0000)];
    
    self.hidden = YES;
    self.layer.cornerRadius = self.height / 2.f;
    self.layer.masksToBounds = YES;

    [self addSubview:self.numberLabel];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(self.height/4.f);
        make.right.equalTo(self).offset(-self.height/4.f);
        make.top.bottom.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(self.height/2.f);
        make.height.mas_equalTo(self.height);
    }];
}

#pragma mark - 懒加载

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = self.numberFont;
            label.text = @"0";
            label.textColor = self.numberTextColor;
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _numberLabel;
}

#pragma mark - 更新UI

- (void)updateUI {
    self.hidden = self.number == 0;
    
    NSString *string;
    if (self.number > 0) {
        if (self.number > 99) {
            string = @"99+";
        } else {
            string = [NSString stringWithFormat:@"%ld", self.number];
        }
    }
    self.numberLabel.text = string;
}

#pragma mark - Setter

- (void)setHeight:(CGFloat)height {
    _height = height;
    
    self.layer.cornerRadius = height / 2.f;
    
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(height/4.f);
        make.right.equalTo(self).offset(-height/4.f);
        make.top.bottom.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(height/2.f);
        make.height.mas_equalTo(height);
    }];
}

- (void)setNumberFont:(UIFont *)numberFont {
    _numberFont = numberFont;
    self.numberLabel.font = numberFont;
}

- (void)setNumberTextColor:(UIColor *)numberTextColor {
    _numberTextColor = numberTextColor;
    self.numberLabel.textColor = numberTextColor;
}

- (void)setNumber:(NSInteger)number {
    _number = number;
    [self updateUI];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    self.colors = @[backgroundColor, backgroundColor];
}

@end
