//   
//  DatePickerPopupView.m
//   
//  Created by alpha yu on 2024/1/4 
//   
   

#import "DatePickerPopupView.h"
#import <BRPickerView/BRPickerView.h>

@interface DatePickerPopupView ()

@property (nonatomic, strong) UILabel *headerTitleLabel;

@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) BRDatePickerView *pickerView;

@end

@implementation DatePickerPopupView

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
    self.backgroundColor = UIColor.whiteColor;
    [self setCornerRadius:SCALE(20) rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    // 头部
    UIView *headerView = [[UIView alloc] init];
        
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setNormalWithTitle:@"确定" color:COLOR_HEX(#8177FC) font:FONT_BOLD(15)];
    [confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setNormalWithTitle:@"取消" color:COLOR_HEX(#D2D2D2) font:FONT_BOLD(15)];
    [cancelBtn addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:headerView];
    [headerView addSubview:self.headerTitleLabel];
    [headerView addSubview:confirmBtn];
    [headerView addSubview:cancelBtn];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SCALE(46));
    }];
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-SCALE(20));
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(SCALE(20));
    }];
    
    // 容器
    [self addSubview:self.pickerContainerView];
    [self.pickerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(SCALE(180));
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
//        make.bottom.mas_equalTo(0);
    }];
}

- (void)updateUI {

}

#pragma mark - override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.pickerView addPickerToView:self.pickerContainerView];
}


#pragma mark - getter

- (UILabel *)headerTitleLabel {
    if (!_headerTitleLabel) {
        _headerTitleLabel = [UILabel labelWithColor:COLOR_HEX(#000000) font:FONT_BOLD(16) text:@"选择日期"];
    }
    return _headerTitleLabel;
}

- (UIView *)pickerContainerView {
    if (!_pickerContainerView) {
        _pickerContainerView = [[UIView alloc] init];
    }
    return _pickerContainerView;
}

- (BRDatePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[BRDatePickerView alloc] init];
        
        _pickerView.pickerMode = BRDatePickerModeYMD;
        _pickerView.minDate = [NSDate jk_dateWithYear:1920 month:1 day:1];
        _pickerView.maxDate = [NSDate date];
//        view.selectDate = self.selectedDate;
        _pickerView.showUnitType = BRShowUnitTypeAll;
        _pickerView.numberFullName = YES;
        
        WEAK_SELF
        _pickerView.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            STRONG_SELF
            self.selectDate = selectDate;
            if (self.dateSelectedBlock) {
                self.dateSelectedBlock(selectDate);
            }
        };
        
        BRPickerStyle *style = [[BRPickerStyle alloc] init];
        style.separatorColor = UIColor.whiteColor;
        style.separatorHeight = 1;
        style.pickerTextColor = COLOR_HEX(#000000);
        style.pickerTextFont = FONT(16);
        style.rowHeight = 40;
        
        _pickerView.pickerStyle = style;
    }
    return _pickerView;
}

#pragma mark - setter

- (void)setHeaderTitle:(NSString *)headerTitle {
    _headerTitle = headerTitle;
    self.headerTitleLabel.text = headerTitle;
}

- (void)setSelectDate:(NSDate *)selectDate {
    _selectDate = selectDate;
    self.pickerView.selectDate = selectDate;
}

- (void)setMaxDate:(NSDate *)maxDate {
    _maxDate = maxDate;
    self.pickerView.maxDate = maxDate;
}

- (void)setMinDate:(NSDate *)minDate {
    _minDate = minDate;
    self.pickerView.minDate = minDate;
}

#pragma mark - action

- (void)confirmBtnAction:(UIButton *)sender {
    // TODO:
    
    self.pickerView.doneBlock();
    [self dismissPopup];
}

#pragma mark - api


#pragma mark - notification


#pragma mark - public


#pragma mark - private



@end
