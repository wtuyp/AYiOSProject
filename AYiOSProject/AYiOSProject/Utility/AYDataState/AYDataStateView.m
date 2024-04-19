//   
//  AYDataStateView.m
//   
//  Created by alpha yu on 2024/1/2 
//   
   

#import "AYDataStateView.h"

@interface AYDataStateView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *actionBtn;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, AYDataStateConfig *> *stateConfigDic;
@property (nonatomic, assign) AYViewDataState state;

@end

@implementation AYDataStateView

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

- (instancetype)initWithAttachedView:(UIView *)view {
    self = [super init];
    if (self) {
        _attachedView = view;
    }
    return self;
}

- (void)setupInit {
    self.stateConfigDic = [[NSMutableDictionary alloc] init];
}

- (void)updateUI {

}

#pragma mark - override


#pragma mark - getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionBtn addTarget:self action:@selector(actionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}

#pragma mark - setter



#pragma mark - action

- (void)actionBtnAction:(UIButton *)sender {
    AYDataStateConfig *config = [self configForState:self.state];
    if (config.btnActionBlock) {
        config.btnActionBlock();
    }
}

#pragma mark - api


#pragma mark - notification


#pragma mark - public

- (void)setConfig:(AYDataStateConfig *)config forState:(AYViewDataState)state {
    if (config) {
        [self.stateConfigDic setObject:config forKey:@(state)];
    } else {
        [self.stateConfigDic removeObjectForKey:@(state)];
    }
}

- (AYDataStateConfig *)configForState:(AYViewDataState)state {
    return [self.stateConfigDic objectForKey:@(state)];
}

- (void)updateConfig:(void (^)(AYDataStateConfig * _Nullable config))configBlock forState:(AYViewDataState)state {
    AYDataStateConfig *config = [self configForState:state];
    !configBlock ?: configBlock(config);
}

- (void)showWithState:(AYViewDataState)state {
    self.state = state;
    if (!self.attachedView) {
        [self removeFromSuperview];
        return;
    }
    
    BOOL isCustomSubview = NO;
    if (self.customSubviewBlock) {
        isCustomSubview = self.customSubviewBlock(self, state);
    }
    
    if (!isCustomSubview) {
        AYDataStateConfig *config = [self configForState:state];
        if (!config) {
            [self removeFromSuperview];
            return;
        }
        
        [self updateSubviewsLayoutWithConfig:config];
    }
    
    [self.attachedView addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_offset(self.centerOffset);
    }];
}

#pragma mark - private

- (void)updateSubviewsDefaultLayoutWithConfig:(AYDataStateConfig *)config {
    UIView *preView = nil;  // 上一个视图
    if (config.image || config.imageName) {
        [self addSubview:self.imageView];
        
        if (config.image) {
            self.imageView.image = config.image;
        } else if (config.imageName) {
            self.imageView.image = [UIImage imageNamed:config.imageName];
        }
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.left.mas_greaterThanOrEqualTo(0);
            make.right.mas_lessThanOrEqualTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
            
            if (!CGSizeEqualToSize(config.imageSize, CGSizeZero) ) {
                make.size.mas_equalTo(config.imageSize);
            }
        }];
        
        preView = self.imageView;
    }
    
    if (config.title) {
        [self addSubview:self.titleLabel];
        
        self.titleLabel.text = config.title;
        self.titleLabel.textColor = config.titleColor;
        self.titleLabel.font = config.titleFont;
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            preView ? make.top.equalTo(preView.mas_bottom).offset(config.titleTopGap) :  make.top.mas_equalTo(0);
            make.left.mas_greaterThanOrEqualTo(0);
            make.right.mas_lessThanOrEqualTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
        }];
        
        preView = self.titleLabel;
    }
    
    if (config.detail) {
        [self addSubview:self.detailLabel];
        
        self.detailLabel.text = config.detail;
        self.detailLabel.textColor = config.detailColor;
        self.detailLabel.font = config.detailFont;
        
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            preView ? make.top.equalTo(preView.mas_bottom).offset(config.detailTopGap) :  make.top.mas_equalTo(0);
            make.left.mas_greaterThanOrEqualTo(0);
            make.right.mas_lessThanOrEqualTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);

            if (config.detailWidth) {
                make.width.mas_equalTo(config.detailWidth);
            }
        }];
        
        preView = self.detailLabel;
    }
    
    if (config.btnTitle) {
        [self addSubview:self.actionBtn];
        
        [self.actionBtn setTitle:config.btnTitle forState:UIControlStateNormal];
        [self.actionBtn setTitleColor:config.btnTitleColor forState:UIControlStateNormal];
        self.actionBtn.titleLabel.font = config.btnTitleFont;
        self.actionBtn.backgroundColor = config.btnBackgroundColor;
                
        if (config.btnCornerRadius > 0) {
//            self.actionBtn.layer.masksToBounds = YES;
            self.actionBtn.layer.cornerRadius = config.btnCornerRadius;
        }
        
        if (config.btnBorderWidth > 0) {
            self.actionBtn.layer.borderWidth = config.btnBorderWidth;
            self.actionBtn.layer.borderColor = config.btnBorderColor.CGColor;
        }

        [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            preView ? make.top.equalTo(preView.mas_bottom).offset(config.btnTopGap) :  make.top.mas_equalTo(0);
            make.left.mas_greaterThanOrEqualTo(0);
            make.right.mas_lessThanOrEqualTo(0);
            make.bottom.mas_equalTo(0); // 正常情况为最后一项
            
            if (!CGSizeEqualToSize(config.btnSize, CGSizeZero) ) {
                make.size.mas_equalTo(config.btnSize);
            }
        }];
        
//        preView = self.actionBtn;
    }
}

- (void)updateSubviewsLayoutWithConfig:(AYDataStateConfig *)config {
    [self removeAllSubviews];
    
    if (!config) {
        return;
    }
    
    [self updateSubviewsDefaultLayoutWithConfig:config];
}

@end
