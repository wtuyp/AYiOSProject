//   
//  AYLabelView.m
//   
//  Created by alpha yu on 2024/2/18 
//   
   

#import "AYLabelView.h"

@interface AYLabelView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) CGFloat horizontalInset;

@end

@implementation AYLabelView

#pragma mark - life

- (instancetype)initWithHorizontalInset:(CGFloat)horizontalInset {
    self = [super init];
    if (self) {
        _horizontalInset = horizontalInset;
        
        [self setupInit];
    }
    return self;
}

- (void)setupInit {
    [self addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(self.horizontalInset);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)updateUI {

}

#pragma mark - override

- (CGSize)intrinsicContentSize {
    return CGSizeMake(40, 20);
}

#pragma mark - getter

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
    }
    return _textLabel;
}

#pragma mark - setter


#pragma mark - action


#pragma mark - api


#pragma mark - notification


#pragma mark - public


#pragma mark - private



@end
