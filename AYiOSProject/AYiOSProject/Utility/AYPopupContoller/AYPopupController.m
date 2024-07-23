//
//  AYPopupController.m
//
//  Created by alpha yu on 2020/9/9.
//

#import "AYPopupController.h"
#import "MMMLab.h"
#import "UIUtils.h"

@interface AYPopupController ()

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong, nullable) UIColor *backgroundColor;  ///< 背景色，实际是设置dimView的颜色

@property (nonatomic, strong) UITapGestureRecognizer *dimViewTapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panToDismissGesture;
@property (nonatomic, assign) CGFloat panOriginOffset;

@end

@implementation AYPopupController

#pragma mark - life

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

#pragma mark - view
- (void)setupSubviews {
    [self.view addSubview:self.dimView];
    [self.dimView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
}

#pragma mark - public

- (void)popup {
    AYPopupAnimationType animationType = self.contentView.animationType;
    self.backgroundColor = self.contentView.popupBackgroundDimColor ?: [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.dimViewTapGesture.enabled = !self.contentView.disableTouchOutToDismiss;
    
    __weak typeof(self) weakSelf = self;
    
    void (^animationBlock)(void) = nil;
    if (animationType == AYPopupAnimationTypeFade) {
        self.dimView.alpha = 0.0;
        self.contentView.alpha = 0.0;
        
        CGPoint popupPoint = self.contentView.popupPoint;
        AYPopupAlign align = self.contentView.popupAlign;
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (align == AYPopupAlignTopLeft) {
                make.left.mas_equalTo(popupPoint.x);
                make.top.mas_equalTo(popupPoint.y);
            } else if (align == AYPopupAlignTopRight) {
                make.right.equalTo(self.view.mas_left).offset(popupPoint.x);
                make.top.mas_equalTo(popupPoint.y);
            } else if (align == AYPopupAlignBottomLeft) {
                make.left.mas_equalTo(popupPoint.x);
                make.bottom.equalTo(self.view.mas_top).offset(popupPoint.y);
            } else if (align == AYPopupAlignBottomRight) {
                make.right.equalTo(self.view.mas_left).offset(popupPoint.x);
                make.bottom.equalTo(self.view.mas_top).offset(popupPoint.y);
            } else if (align == AYPopupAlignCenter) {
                make.centerX.equalTo(self.view.mas_left).offset(popupPoint.x);
                make.centerY.equalTo(self.view.mas_top).offset(popupPoint.y);
            } else if (align == AYPopupAlignCenterLeft) {
                make.left.mas_equalTo(popupPoint.x);
                make.centerY.equalTo(self.view.mas_top).offset(popupPoint.y);
            } else if (align == AYPopupAlignCenterRight) {
                make.right.equalTo(self.view.mas_left).offset(popupPoint.x);
                make.centerY.equalTo(self.view.mas_top).offset(popupPoint.y);
            } else if (align == AYPopupAlignTopCenter) {
                make.centerX.equalTo(self.view.mas_left).offset(popupPoint.x);
                make.top.mas_equalTo(popupPoint.y);
            } else if (align == AYPopupAlignBottomCenter) {
                make.centerX.equalTo(self.view.mas_left).offset(popupPoint.x);
                make.bottom.equalTo(self.view.mas_top).offset(popupPoint.y);
            }
            
            if (self.contentView.popupFixedWidth > 0) {
                make.width.mas_equalTo(self.contentView.popupFixedWidth);
            }
            
            if (self.contentView.popupFixedHeight > 0) {
                make.height.mas_equalTo(self.contentView.popupFixedHeight);
            }
        }];
        
        animationBlock = ^{
            __strong typeof(self) self = weakSelf;
            [UIView animateWithDuration:0.25 animations:^{
                self.dimView.alpha = 1.0;
                self.contentView.alpha = 1.0;
            } completion:^(BOOL finished) {
                if (finished && self.contentView.popupCompletedBlock) {
                    self.contentView.popupCompletedBlock();
                }
            }];
        };
    } else if (animationType == AYPopupAnimationTypeSideFromBottom) {
        self.dimView.alpha = 0.0;
        [self.contentView addGestureRecognizer:self.panToDismissGesture];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.contentView.popupFixedWidth > 0) {
                make.width.mas_equalTo(self.contentView.popupFixedWidth);
            } else {
                make.left.right.mas_equalTo(0);
            }
            
            if (self.contentView.popupFixedHeight > 0) {
                make.height.mas_equalTo(self.contentView.popupFixedHeight);
            }
            
            make.centerX.mas_equalTo(0);
            make.top.equalTo(self.view.mas_bottom);
        }];
        
        [self.view setNeedsLayout];
        
        animationBlock = ^{
            __strong typeof(self) self = weakSelf;
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (self.contentView.popupFixedWidth > 0) {
                    make.width.mas_equalTo(self.contentView.popupFixedWidth);
                } else {
                    make.left.right.mas_equalTo(0);
                }
                
                if (self.contentView.popupFixedHeight > 0) {
                    make.height.mas_equalTo(self.contentView.popupFixedHeight);
                }
                
                make.centerX.mas_equalTo(0);
                make.bottom.equalTo(self.view);
            }];
            
            [UIView animateWithDuration:0.25 animations:^{
                self.dimView.alpha = 1.0;
                
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                if (finished && self.contentView.popupCompletedBlock) {
                    self.contentView.popupCompletedBlock();
                }
            }];
        };
    } else if (animationType == AYPopupAnimationTypeSideFromLeft) {
        self.dimView.alpha = 0.0;
        [self.contentView addGestureRecognizer:self.panToDismissGesture];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.contentView.popupFixedWidth > 0) {
                make.width.mas_equalTo(self.contentView.popupFixedWidth);
            }
            
            if (self.contentView.popupFixedHeight > 0) {
                make.height.mas_equalTo(self.contentView.popupFixedHeight);
                make.centerY.mas_equalTo(0);
            } else {
                make.top.bottom.mas_equalTo(0);
            }
            
            make.right.equalTo(self.view.mas_left);
        }];
        
        [self.view setNeedsLayout];
        
        animationBlock = ^{
            __strong typeof(self) self = weakSelf;
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (self.contentView.popupFixedWidth > 0) {
                    make.width.mas_equalTo(self.contentView.popupFixedWidth);
                }
                
                if (self.contentView.popupFixedHeight > 0) {
                    make.height.mas_equalTo(self.contentView.popupFixedHeight);
                    make.centerY.mas_equalTo(0);
                } else {
                    make.top.bottom.mas_equalTo(0);
                }
                
                make.left.equalTo(self.view);
            }];
            
            [UIView animateWithDuration:0.25 animations:^{
                self.dimView.alpha = 1.0;
                
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                if (finished && self.contentView.popupCompletedBlock) {
                    self.contentView.popupCompletedBlock();
                }
            }];
        };
        
    } else if (animationType == AYPopupAnimationTypeSideFromRight) {
        self.dimView.alpha = 0.0;
        [self.contentView addGestureRecognizer:self.panToDismissGesture];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.contentView.popupFixedWidth > 0) {
                make.width.mas_equalTo(self.contentView.popupFixedWidth);
            }
            
            if (self.contentView.popupFixedHeight > 0) {
                make.height.mas_equalTo(self.contentView.popupFixedHeight);
                make.centerY.mas_equalTo(0);
            } else {
                make.top.bottom.mas_equalTo(0);
            }
            
            make.left.equalTo(self.view.mas_right);
        }];
        
        [self.view setNeedsLayout];
        
        animationBlock = ^{
            __strong typeof(self) self = weakSelf;
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (self.contentView.popupFixedWidth > 0) {
                    make.width.mas_equalTo(self.contentView.popupFixedWidth);
                }
                
                if (self.contentView.popupFixedHeight > 0) {
                    make.height.mas_equalTo(self.contentView.popupFixedHeight);
                    make.centerY.mas_equalTo(0);
                } else {
                    make.top.bottom.mas_equalTo(0);
                }
                
                make.right.equalTo(self.view);
            }];
            
            [UIView animateWithDuration:0.25 animations:^{
                self.dimView.alpha = 1.0;
                
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                if (finished && self.contentView.popupCompletedBlock) {
                    self.contentView.popupCompletedBlock();
                }
            }];
        };
        
    }
    
    if (self.contentView.targetController) {
        [self.contentView.targetController.view addSubview:self.view];
        [self.contentView.targetController addChildViewController:self];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.inset(0);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            animationBlock();
        });
    } else {
        UIViewController *vc = [UIUtils visibleViewController];
        [vc presentViewController:self animated:NO completion:^{
            animationBlock();
        }];
    }
}

- (void)dismiss {
    [self dismissWithCompletedBlock:nil];
}

- (void)dismissWithCompletedBlock:(void (^)(void))block {
    AYPopupAnimationType animationType = self.contentView.animationType;

    if (animationType == AYPopupAnimationTypeSideFromBottom) {
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.contentView.popupFixedWidth > 0) {
                make.width.mas_equalTo(self.contentView.popupFixedWidth);
            } else {
                make.left.right.mas_equalTo(0);
            }
            
            if (self.contentView.popupFixedHeight > 0) {
                make.height.mas_equalTo(self.contentView.popupFixedHeight);
            }
            
            make.centerX.mas_equalTo(0);
            make.top.equalTo(self.view.mas_bottom);
        }];
    } else if (animationType == AYPopupAnimationTypeSideFromLeft) {
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.contentView.popupFixedWidth > 0) {
                make.width.mas_equalTo(self.contentView.popupFixedWidth);
            }
            
            if (self.contentView.popupFixedHeight > 0) {
                make.height.mas_equalTo(self.contentView.popupFixedHeight);
                make.centerY.mas_equalTo(0);
            } else {
                make.top.bottom.mas_equalTo(0);
            }
            
            make.right.equalTo(self.view.mas_left);
        }];
    } else if (animationType == AYPopupAnimationTypeSideFromRight) {
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.contentView.popupFixedWidth > 0) {
                make.width.mas_equalTo(self.contentView.popupFixedWidth);
            }
            
            if (self.contentView.popupFixedHeight > 0) {
                make.height.mas_equalTo(self.contentView.popupFixedHeight);
                make.centerY.mas_equalTo(0);
            } else {
                make.top.bottom.mas_equalTo(0);
            }
            
            make.left.equalTo(self.view.mas_right);
        }];
    }
    
    [UIView animateWithDuration:0.27 animations:^{
        [self animateSubViews];
    } completion:^(BOOL finished) {
        void (^dismissCompletedBlock)(void) = nil;
        if (self.contentView.dismissCompletedBlock) {
            dismissCompletedBlock = [self.contentView.dismissCompletedBlock copy];
        }
        
        if (self.contentView.targetController) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];

            self.contentView = nil;
            
            if (dismissCompletedBlock) {
                dismissCompletedBlock();
            }
            
            if (block) {
                block();
            }
        } else {
            self.contentView = nil;
            
            [self dismissViewControllerAnimated:NO completion:^{
                if (dismissCompletedBlock) {
                    dismissCompletedBlock();
                }
                
                if (block) {
                    block();
                }
            }];
        }
    }];
}

#pragma mark - private
- (void)animateSubViews {
    self.dimView.alpha = 0.0;
    
    AYPopupAnimationType animationType = self.contentView.animationType;

    if (animationType == AYPopupAnimationTypeSideFromBottom
        || animationType == AYPopupAnimationTypeSideFromLeft
        || animationType == AYPopupAnimationTypeSideFromRight) {
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } else {
        self.contentView.alpha = 0.0;
    }
}

// 是否有自己的控制器
- (BOOL)isViewHasItOwnController:(UIView *)view {
    if (view.viewController != self) {
        return YES;
    }
    
    return NO;
}

#pragma mark - getter

- (UIColor *)backgroundColor {
    return self.dimView.backgroundColor;
}

- (UIView *)dimView {
    if (!_dimView) {
        _dimView = [[UIView alloc] init];
        
        [_dimView addGestureRecognizer:self.dimViewTapGesture];
    }
    
    return _dimView;
}

- (UITapGestureRecognizer *)dimViewTapGesture {
    if (!_dimViewTapGesture) {
        _dimViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimViewTapGestureAction:)];
    }
    return _dimViewTapGesture;
}

- (UIPanGestureRecognizer *)panToDismissGesture {
    if (!_panToDismissGesture) {
        _panToDismissGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        _panToDismissGesture.enabled = NO;
    }
    return _panToDismissGesture;
}

#pragma mark - setter
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.dimView.backgroundColor = backgroundColor;
}

- (void)setContentView:(UIView *)contentView {
    if (_contentView && (_contentView != contentView)) {
        if ([self isViewHasItOwnController:_contentView]) {
            [_contentView.viewController removeFromParentViewController];
        }
        [_contentView removeFromSuperview];
    }

    _contentView = contentView;
    if (contentView) {
        [self.view addSubview:contentView];
        if ([self isViewHasItOwnController:contentView]) {
            [self addChildViewController:contentView.viewController];
        }
    }
}

#pragma mark - action

- (void)dimViewTapGestureAction:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)pan {
    CGPoint transP = [pan translationInView:self.contentView];
//    NSLog(@"transP=%@", NSStringFromCGPoint(transP));
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (self.contentView.animationType == AYPopupAnimationTypeSideFromBottom) {
            self.panOriginOffset = self.contentView.top;
        } else if (self.contentView.animationType == AYPopupAnimationTypeSideFromLeft) {
            self.panOriginOffset = self.contentView.right;
        } else if (self.contentView.animationType == AYPopupAnimationTypeSideFromRight) {
            self.panOriginOffset = self.contentView.left;
        }
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        if (self.contentView.animationType == AYPopupAnimationTypeSideFromBottom) {
            CGFloat top = self.panOriginOffset + transP.y;
            if (top <= self.panOriginOffset) {
                return;
            }
            self.contentView.top = self.panOriginOffset + transP.y;
        } else if (self.contentView.animationType == AYPopupAnimationTypeSideFromLeft) {
            CGFloat x = self.panOriginOffset + transP.x;
            if (x >= self.panOriginOffset) {
                return;
            }
            self.contentView.right = self.panOriginOffset + transP.x;
        } else if (self.contentView.animationType == AYPopupAnimationTypeSideFromRight) {
            CGFloat x = self.panOriginOffset + transP.x;
            if (x <= self.panOriginOffset) {
                return;
            }
            self.contentView.left = self.panOriginOffset + transP.x;
        }
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [pan velocityInView:self.contentView];
//        NSLog(@"velocity=%@", NSStringFromCGPoint(velocity));
        
        if (self.contentView.animationType == AYPopupAnimationTypeSideFromBottom) {
            if ((transP.y > self.contentView.height / 2.0) && (velocity.y >= 0)) {
                [self dismiss];
            } else if (velocity.y > 100.0) {
                [self dismiss];
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    self.contentView.top = self.panOriginOffset;
                }];
            }
        } else if (self.contentView.animationType == AYPopupAnimationTypeSideFromLeft) {
            if ((fabs(transP.x) > self.contentView.width / 2.0) && (velocity.x <= 0)) {
                [self dismiss];
            } else if (velocity.x < -100.0) {
                [self dismiss];
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    self.contentView.right = self.panOriginOffset;
                }];
            }
        } else if (self.contentView.animationType == AYPopupAnimationTypeSideFromRight) {
            if ((transP.x > self.contentView.width / 2.0) && (velocity.x >= 0)) {
                [self dismiss];
            } else if (velocity.x > 100.0) {
                [self dismiss];
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    self.contentView.left = self.panOriginOffset;
                }];
            }
        }
    } else {
        if (self.contentView.animationType == AYPopupAnimationTypeSideFromBottom) {
            [UIView animateWithDuration:0.25 animations:^{
                self.contentView.top = self.panOriginOffset;
            }];
        } else if (self.contentView.animationType == AYPopupAnimationTypeSideFromLeft) {
            [UIView animateWithDuration:0.25 animations:^{
                self.contentView.right = self.panOriginOffset;
            }];
        } else if (self.contentView.animationType == AYPopupAnimationTypeSideFromRight) {
            [UIView animateWithDuration:0.25 animations:^{
                self.contentView.left = self.panOriginOffset;
            }];
        }
    }
}


#pragma mark - notification


#pragma mark - api


#pragma mark - other


@end

@implementation UIView (AYPopupViewConfig)

MMMSynthesizeIntProperty(animationType, setAnimationType)
MMMSynthesizeCGPointProperty(popupPoint, setPopupPoint)
MMMSynthesizeIntProperty(popupAlign, setPopupAlign)
MMMSynthesizeCGFloatProperty(popupFixedWidth, setPopupFixedWidth)
MMMSynthesizeCGFloatProperty(popupFixedHeight, setPopupFixedHeight)
MMMSynthesizeIdCopyProperty(popupCompletedBlock, setPopupCompletedBlock)
MMMSynthesizeIdCopyProperty(dismissCompletedBlock, setDismissCompletedBlock)
MMMSynthesizeIdStrongProperty(popupBackgroundDimColor, setPopupBackgroundDimColor)
MMMSynthesizeBOOLProperty(disableTouchOutToDismiss, setDisableTouchOutToDismiss)
MMMSynthesizeIdWeakProperty(targetController, setTargetController)
MMMSynthesizeIdWeakProperty(myController, setMyController)
MMMSynthesizeBOOLProperty(panGestureEnable, setPanGestureEnable)

- (void)setPopupPointFromView:(UIView *)view referenceAlign:(AYPopupAlign)align {
    [self setPopupPointFromView:view referenceAlign:align offset:CGPointZero];
}

- (void)setPopupPointFromView:(UIView *)view referenceAlign:(AYPopupAlign)align offset:(CGPoint)offset {
    if (!view) {
        return;
    }
    
    CGPoint referencePoint = CGPointZero;
    switch (align) {
        case AYPopupAlignTopLeft: {
            referencePoint = CGPointMake(CGRectGetMinX(view.frame), CGRectGetMinY(view.frame));
        }
            break;
        case AYPopupAlignTopRight: {
            referencePoint = CGPointMake(CGRectGetMaxX(view.frame), CGRectGetMinY(view.frame));
        }
            break;
        case AYPopupAlignBottomLeft: {
            referencePoint = CGPointMake(CGRectGetMinX(view.frame), CGRectGetMaxY(view.frame));
        }
            break;
        case AYPopupAlignBottomRight: {
            referencePoint = CGPointMake(CGRectGetMaxX(view.frame), CGRectGetMaxY(view.frame));
        }
            break;
        case AYPopupAlignCenter: {
            referencePoint = view.center;
        }
            break;
        case AYPopupAlignCenterLeft: {
            referencePoint = CGPointMake(CGRectGetMinX(view.frame), CGRectGetMidY(view.frame));
        }
            break;
        case AYPopupAlignCenterRight: {
            referencePoint = CGPointMake(CGRectGetMaxX(view.frame), CGRectGetMidY(view.frame));
        }
            break;
        case AYPopupAlignTopCenter: {
            referencePoint = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMinY(view.frame));
        }
            break;
        case AYPopupAlignBottomCenter: {
            referencePoint = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMaxY(view.frame));
        }
            break;
            
        default:
            break;
    }
    
    UIViewController *vc = self.targetController ?: [UIUtils visibleViewController];
    CGPoint point = [vc.view convertPoint:CGPointMake(referencePoint.x + offset.x, referencePoint.y + offset.y) fromView:view.superview];
    
    self.popupPoint = point;
}

@end
