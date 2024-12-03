//   
//   AppNaviView.m
//   
//   Created by alpha yu on 2023/5/12 
//   
   

#import "AppNaviView.h"
#import <objc/runtime.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface AppNaviView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *naviBar;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, weak) UIViewController *targetController;


@end

@implementation AppNaviView

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
    [self addSubview:self.backgroundView];
    [self addSubview:self.naviBar];
    [self.naviBar addSubview:self.backBtn];
    [self.naviBar addSubview:self.titleLabel];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    [self.naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(NAVI_BAR_HEIGHT);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.mas_equalTo(12);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.left.greaterThanOrEqualTo(self.backBtn.mas_right).offset(10);
    }];
}

- (void)updateUI {

}

#pragma mark - override


#pragma mark - getter

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = NAVI_BAR_COLOR;
    }
    return _backgroundView;
}

- (UIView *)naviBar {
    if (!_naviBar) {
        _naviBar = [[UIView alloc] init];
    }
    return _naviBar;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:NAVI_BAR_BACK_IMAGE forState:UIControlStateNormal];
        _backBtn.adjustsImageWhenHighlighted = NO;
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.jk_touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = NAVI_BAR_TITLE_COLOR;
        _titleLabel.font = NAVI_BAR_TITLE_FONT;
    }
    return _titleLabel;
}

#pragma mark - setter

- (void)setBackBtnImage:(UIImage *)backBtnImage {
    _backBtnImage = backBtnImage;
    
    [self updateBackBtn];
}

- (void)setBackBtnColor:(UIColor *)backBtnColor {
    _backBtnColor = backBtnColor;
    
    [self updateBackBtn];
}

- (void)updateBackBtn {
    UIImage *image = self.backBtnImage ?: NAVI_BAR_BACK_IMAGE;
    
    if (self.backBtnColor) {
        [self.backBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.backBtn.tintColor = _backBtnColor;
    } else {
        [self.backBtn setImage:image forState:UIControlStateNormal];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = _titleColor;
}

#pragma mark - action

- (void)backBtnAction:(UIButton *)sender {
    BOOL needPop = YES;
    if (self.backBtnActionBlock) {
        needPop = self.backBtnActionBlock();
    }
    if (needPop) {
        [self.targetController.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - api


#pragma mark - notification


#pragma mark - public

- (void)addToController:(UIViewController *)controller {
    if (!controller) {
        return;
    }
    
    self.targetController = controller;
    self.targetController.fd_prefersNavigationBarHidden = YES;
    [self.targetController.view addSubview:self];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(STATUS_NAVI_BAR_HEIGHT);
    }];
}

#pragma mark - private



@end

@interface UIViewController ()

@property (nonatomic, strong) AppNaviView *naviView;

@end

@implementation UIViewController (AppNaviView)

+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(viewWillLayoutSubviews));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(app_viewWillLayoutSubviews));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)app_viewWillLayoutSubviews {
    [self app_viewWillLayoutSubviews];
    [self.view bringSubviewToFront:self.naviView];
    
    for (UIView *view in self.view.subviews) {
        if (view.viewLevel == AppViewLevelAlert) {
            [self.view bringSubviewToFront:view];
        }
    }
}

- (AppNaviView *)naviView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNaviView:(AppNaviView *)naviView {
    naviView.viewLevel = AppViewLevelNaviView;
    objc_setAssociatedObject(self, @selector(naviView), naviView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addNaviViewAndConfig:(void (^)(AppNaviView *naviView))configBlock {
    self.naviView = [[AppNaviView alloc] init];
    [self.naviView addToController:self];
    self.naviView.backBtn.hidden = self.navigationController.viewControllers.count > 1 ? NO : YES;
    if (configBlock) {
        configBlock(self.naviView);
    }
}

@end

const AppViewLevel AppViewLevelNaviView = 1000;
const AppViewLevel AppViewLevelAlert = 2000;

@implementation UIView (AppViewLevel)

- (AppViewLevel)viewLevel {
    NSNumber *level = objc_getAssociatedObject(self, _cmd);
    if (!level) {
        level = @0;
    }
    return [level integerValue];
}

- (void)setViewLevel:(AppViewLevel)viewLevel {
    objc_setAssociatedObject(self, @selector(viewLevel), @(viewLevel), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
