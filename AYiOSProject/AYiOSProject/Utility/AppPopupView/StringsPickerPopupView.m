//   
//  StringsPickerPopupView.m
//   
//  Created by alpha yu on 2024/1/4 
//   
   

#import "StringsPickerPopupView.h"

@interface StringsPickerPopupView ()

@property (nonatomic, strong) UILabel *headerTitleLabel;

@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) BRStringPickerView *pickerView;

@property (nonatomic, copy) NSArray<NSString *> *dataArray;
@property (nonatomic, copy) NSString *defaultString;
@property (nonatomic, copy) NSString *title;

@end

@implementation StringsPickerPopupView

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

- (instancetype)initWithTitle:(NSString *)title
                    dataArray:(NSArray<NSString *> *)dataArray
                defaultString:(NSString *)defaultString {
    self = [super init];
    if (self) {
        _title = title;
        _dataArray = [dataArray copy];
        _defaultString = defaultString;
        
        [self updateUI];
    };
    
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
        make.height.mas_equalTo(SCALE(150));
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
    }];
}

- (void)updateUI {
    self.headerTitleLabel.text = self.title;
    self.pickerView.dataSourceArr = self.dataArray;
    self.pickerView.selectValue = self.defaultString;
}

#pragma mark - override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.pickerView addPickerToView:self.pickerContainerView];
}

#pragma mark - getter

- (UILabel *)headerTitleLabel {
    if (!_headerTitleLabel) {
        _headerTitleLabel = [UILabel labelWithColor:COLOR_HEX(#000000) font:FONT_BOLD(16)];
    }
    return _headerTitleLabel;
}

- (UIView *)pickerContainerView {
    if (!_pickerContainerView) {
        _pickerContainerView = [[UIView alloc] init];
    }
    return _pickerContainerView;
}

- (BRStringPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        
        BRPickerStyle *customStyle = [[BRPickerStyle alloc] init];
        customStyle.separatorColor = COLOR_HEX(#FFFFFF);
        customStyle.separatorHeight = 1;
        customStyle.pickerTextFont = FONT_BOLD(16);
//        customStyle.pickerTextColor = COLOR_HEX(#D2D2D2);
        customStyle.selectRowTextColor = COLOR_HEX(#000000);
        customStyle.selectRowTextFont = FONT_BOLD(16);
        customStyle.rowHeight = 40;
        _pickerView.pickerStyle = customStyle;
        
        WEAK_SELF
        _pickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            STRONG_SELF
            NSString *value = resultModel.value;
            if (self.resultBlock) {
                self.resultBlock(value, resultModel.index);
            }
        };
    }
    return _pickerView;
}

#pragma mark - setter

- (void)setSelectedString:(NSString *)selectedString {
    _selectedString = selectedString;
    
    if (!selectedString) {
        return;
    }
    self.pickerView.selectValue = selectedString;
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
