//   
//  HomeListCell.m
//   
//  Created by alpha yu on 2024/4/26 
//   
   

#import "HomeListCell.h"

@interface HomeListCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HomeListCell

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

//    // Configure the view for the selected state
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        [self setupInit];
    }

    return self;
}

- (void)setupInit {
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(13, 26, 13, 13));
    }];
}

- (void)updateUI {

}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithColor:COLOR_HEX(#232323) font:FONT(13)];
    }
    return _titleLabel;
}

#pragma mark - setter


#pragma mark - action


#pragma mark - public

- (void)updateTitle:(NSString *)title {
    self.titleLabel.text = title;
}

#pragma mark - private


@end
