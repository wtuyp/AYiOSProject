//
//  AYPopupController.m
//
//  Created by alpha yu on 2020/9/9.
//

#import "AYPopupController.h"
#import "MacroObjc.h"

@interface UIView (AYPopupPrivate)

/// 当视图是属于一个控制器时，关联自身的控制器。
@property (nonatomic, weak, nullable) UIViewController *popupViewReferenceController;

/// 滑动起始位置
@property (nonatomic, assign) CGFloat panOriginOffset;

@end

@implementation UIView (AYPopupPrivate)

AppSynthesizeIdWeakProperty(popupViewReferenceController, setPopupViewReferenceController)
AppSynthesizeFloatProperty(panOriginOffset, setPanOriginOffset)

@end


@implementation UIViewController (AYPopup)

#pragma mark - public

- (void)popupView:(UIView *)view {
    UIResponder *nextResponder = [view nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        view.popupViewReferenceController = (UIViewController *)nextResponder;
    }
    
    UIView *superView = self.view;
    
    view.dimView.frame = superView.bounds;
    [superView addSubview:view.dimView];
    [superView addSubview:view];
    
    if (view.popupViewReferenceController) {
        [view.popupViewReferenceController willMoveToParentViewController:self];
        [self addChildViewController:view.popupViewReferenceController];
    }
        
    void (^popupCompletedBlock)(BOOL finished) = ^(BOOL finished) {
        if (finished) {
            if (view.popupCompletedBlock) {
                view.popupCompletedBlock();
            }
        }
    };
    
    AYPopupAnimationType animationType = view.animationType;
    if (animationType == AYPopupAnimationTypeFade) {
        view.dimView.alpha = 0.0;
        view.alpha = 0.0;
        
        CGPoint popupPoint = view.popupPoint;
        AYPopupAlign align = view.popupAlign;
        
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (align == AYPopupAlignCenter) {
                make.centerX.equalTo(superView.mas_left).offset(popupPoint.x);
                make.centerY.equalTo(superView.mas_top).offset(popupPoint.y);
            } else if (align == AYPopupAlignTopLeft) {
                make.left.mas_equalTo(popupPoint.x);
                make.top.mas_equalTo(popupPoint.y);
            } else if (align == AYPopupAlignTopRight) {
                make.right.equalTo(superView.mas_left).offset(popupPoint.x);
                make.top.mas_equalTo(popupPoint.y);
            } else if (align == AYPopupAlignTopCenter) {
                make.centerX.equalTo(superView.mas_left).offset(popupPoint.x);
                make.top.mas_equalTo(popupPoint.y);
            } else if (align == AYPopupAlignBottomLeft) {
                make.left.mas_equalTo(popupPoint.x);
                make.bottom.equalTo(superView.mas_top).offset(popupPoint.y);
            } else if (align == AYPopupAlignBottomRight) {
                make.right.equalTo(superView.mas_left).offset(popupPoint.x);
                make.bottom.equalTo(superView.mas_top).offset(popupPoint.y);
            } else if (align == AYPopupAlignBottomCenter) {
                make.centerX.equalTo(superView.mas_left).offset(popupPoint.x);
                make.bottom.equalTo(superView.mas_top).offset(popupPoint.y);
            } else if (align == AYPopupAlignCenterLeft) {
                make.left.mas_equalTo(popupPoint.x);
                make.centerY.equalTo(superView.mas_top).offset(popupPoint.y);
            } else if (align == AYPopupAlignCenterRight) {
                make.right.equalTo(superView.mas_left).offset(popupPoint.x);
                make.centerY.equalTo(superView.mas_top).offset(popupPoint.y);
            }
            
            if (view.popupFixedWidth > 0) {
                make.width.mas_equalTo(view.popupFixedWidth);
            }
            
            if (view.popupFixedHeight > 0) {
                make.height.mas_equalTo(view.popupFixedHeight);
            }
        }];

        [UIView animateWithDuration:0.25 animations:^{
            view.dimView.alpha = 1.0;
            view.alpha = 1.0;
        } completion:popupCompletedBlock];
    } else if (animationType == AYPopupAnimationTypeSideFromBottom) {
        view.dimView.alpha = 0.0;
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (view.popupFixedWidth > 0) {
                make.width.mas_equalTo(view.popupFixedWidth);
            } else {
                make.left.right.mas_equalTo(0);
            }
            
            if (view.popupFixedHeight > 0) {
                make.height.mas_equalTo(view.popupFixedHeight);
            }
            
            make.centerX.mas_equalTo(0);
            make.top.equalTo(superView.mas_bottom);
        }];
        
        [superView setNeedsLayout];
        [superView layoutIfNeeded];
                
        [UIView animateWithDuration:0.25 animations:^{
            view.dimView.alpha = 1.0;
            
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (view.popupFixedWidth > 0) {
                    make.width.mas_equalTo(view.popupFixedWidth);
                    make.centerX.mas_equalTo(0);
                } else {
                    make.left.right.mas_equalTo(0);
                }
                
                if (view.popupFixedHeight > 0) {
                    make.height.mas_equalTo(view.popupFixedHeight);
                }
                
                make.bottom.mas_equalTo(0);
            }];
            
            [superView setNeedsLayout];
            [superView layoutIfNeeded];
        } completion:popupCompletedBlock];
    } else if (animationType == AYPopupAnimationTypeSideFromRight) {
        view.dimView.alpha = 0.0;
        
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (view.popupFixedWidth > 0) {
                make.width.mas_equalTo(view.popupFixedWidth);
            }
            
            if (view.popupFixedHeight > 0) {
                make.height.mas_equalTo(view.popupFixedHeight);
                make.centerY.mas_equalTo(0);
            } else {
                make.top.bottom.mas_equalTo(0);
            }
            
            make.left.equalTo(superView.mas_right);
        }];
        
        [superView setNeedsLayout];
        [superView layoutIfNeeded];
        
        [UIView animateWithDuration:0.25 animations:^{
            view.dimView.alpha = 1.0;
            
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (view.popupFixedWidth > 0) {
                    make.width.mas_equalTo(view.popupFixedWidth);
                }
                
                if (view.popupFixedHeight > 0) {
                    make.height.mas_equalTo(view.popupFixedHeight);
                    make.centerY.mas_equalTo(0);
                } else {
                    make.top.bottom.mas_equalTo(0);
                }
                
                make.right.equalTo(superView);
            }];
            
            [superView setNeedsLayout];
            [superView layoutIfNeeded];
        } completion:popupCompletedBlock];
    } else if (animationType == AYPopupAnimationTypeSideFromLeft) {
        view.dimView.alpha = 0.0;
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (view.popupFixedWidth > 0) {
                make.width.mas_equalTo(view.popupFixedWidth);
            }
            
            if (view.popupFixedHeight > 0) {
                make.height.mas_equalTo(view.popupFixedHeight);
                make.centerY.mas_equalTo(0);
            } else {
                make.top.bottom.mas_equalTo(0);
            }
            
            make.right.equalTo(superView.mas_left);
        }];
        
        [superView setNeedsLayout];
        [superView layoutIfNeeded];
        
        [UIView animateWithDuration:0.25 animations:^{
            view.dimView.alpha = 1.0;
            
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (view.popupFixedWidth > 0) {
                    make.width.mas_equalTo(view.popupFixedWidth);
                }
                
                if (view.popupFixedHeight > 0) {
                    make.height.mas_equalTo(view.popupFixedHeight);
                    make.centerY.mas_equalTo(0);
                } else {
                    make.top.bottom.mas_equalTo(0);
                }
                
                make.left.mas_equalTo(0);
            }];
            
            [superView setNeedsLayout];
            [superView layoutIfNeeded];
        } completion:popupCompletedBlock];
    }
}

- (void)dismissView:(UIView *)view {
    [UIView animateWithDuration:0.25 animations:^{
        [self dismissAnimatedWithView:view];
    } completion:^(BOOL finished) {
        void (^dismissCompletedBlock)(void) = nil;
        if (view.dismissCompletedBlock) {
            dismissCompletedBlock = [view.dismissCompletedBlock copy];
        }
        
        [view.dimView removeFromSuperview];
        [view removeFromSuperview];
        
        if (view.popupViewReferenceController) {
            [view.popupViewReferenceController willMoveToParentViewController:nil];
            [view.popupViewReferenceController removeFromParentViewController];
        }
        
        if (dismissCompletedBlock) {
            dismissCompletedBlock();
        }
    }];
}

#pragma mark - private

- (void)dismissAnimatedWithView:(UIView *)view {
    UIView *superView = self.view;
    
    view.dimView.alpha = 0.0;
    
    AYPopupAnimationType animationType = view.animationType;
    if (animationType == AYPopupAnimationTypeSideFromBottom) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (view.popupFixedWidth > 0) {
                make.width.mas_equalTo(view.popupFixedWidth);
            } else {
                make.left.right.mas_equalTo(0);
            }
            
            if (view.popupFixedHeight > 0) {
                make.height.mas_equalTo(view.popupFixedHeight);
            }
            
            make.centerX.mas_equalTo(0);
            make.top.equalTo(superView.mas_bottom);
        }];
        
        [superView setNeedsLayout];
        [superView layoutIfNeeded];
    } else if (animationType == AYPopupAnimationTypeSideFromRight) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (view.popupFixedWidth > 0) {
                make.width.mas_equalTo(view.popupFixedWidth);
            }
            
            if (view.popupFixedHeight > 0) {
                make.height.mas_equalTo(view.popupFixedHeight);
                make.centerY.mas_equalTo(0);
            } else {
                make.top.bottom.mas_equalTo(0);
            }
            
            make.left.equalTo(superView.mas_right);
        }];
        
        [superView setNeedsLayout];
        [superView layoutIfNeeded];
    } else if (animationType == AYPopupAnimationTypeSideFromLeft) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (view.popupFixedWidth > 0) {
                make.width.mas_equalTo(view.popupFixedWidth);
            }
            
            if (view.popupFixedHeight > 0) {
                make.height.mas_equalTo(view.popupFixedHeight);
                make.centerY.mas_equalTo(0);
            } else {
                make.top.bottom.mas_equalTo(0);
            }
            
            make.right.equalTo(superView.mas_left);
        }];
        
        [superView setNeedsLayout];
        [superView layoutIfNeeded];
    } else {
        view.alpha = 0.0;
    }
}

#pragma mark - getter


#pragma mark - setter


#pragma mark - action


@end

@implementation UIView (AYPopup)

AppSynthesizeIntProperty(animationType, setAnimationType)
AppSynthesizeCGPointProperty(popupPoint, setPopupPoint)
AppSynthesizeIntProperty(popupAlign, setPopupAlign)
AppSynthesizeCGFloatProperty(popupFixedWidth, setPopupFixedWidth)
AppSynthesizeCGFloatProperty(popupFixedHeight, setPopupFixedHeight)
AppSynthesizeIdCopyProperty(popupCompletedBlock, setPopupCompletedBlock)
AppSynthesizeIdCopyProperty(dismissCompletedBlock, setDismissCompletedBlock)

#pragma mark - getter

- (UIView *)dimView {
    UIView *view = objc_getAssociatedObject(self, _cmd);
    if (!view) {
        view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [view addGestureRecognizer:self.tapDimViewToDismissGesture];
        
        objc_setAssociatedObject(self, _cmd, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return view;
}

- (UITapGestureRecognizer *)tapDimViewToDismissGesture {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, _cmd);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimViewTapGestureAction:)];
        
        objc_setAssociatedObject(self, _cmd, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return gesture;
}

- (UIPanGestureRecognizer *)panToDismissGesture {
    UIPanGestureRecognizer *gesture = objc_getAssociatedObject(self, _cmd);
    if (!gesture) {
        gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        objc_setAssociatedObject(self, _cmd, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return gesture;
}

#pragma mark - setter


#pragma mark - public


#pragma mark - action

- (void)dimViewTapGestureAction:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self dismissPopup];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)pan {
    UIView *view = pan.view;
    CGPoint transP = [pan translationInView:view];
    
    if (view.animationType == AYPopupAnimationTypeSideFromBottom) {
        if (pan.state == UIGestureRecognizerStateBegan) {
            self.panOriginOffset = view.top;
        } else if (pan.state == UIGestureRecognizerStateChanged) {
            CGFloat top = self.panOriginOffset + transP.y;
            if (top <= self.panOriginOffset) {
                return;
            }
            view.top = self.panOriginOffset + transP.y;
        } else if (pan.state == UIGestureRecognizerStateEnded) {
            CGPoint velocity = [pan velocityInView:view];
            if ((transP.y > view.height / 2.0) && (velocity.y >= 0)) {
                [view dismissPopup];
            } else if (velocity.y > 100.0) {
                [view dismissPopup];
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    view.top = self.panOriginOffset;
                }];
            }
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                view.top = self.panOriginOffset;
            }];
        }
    } else if (view.animationType == AYPopupAnimationTypeSideFromRight) {
        if (pan.state == UIGestureRecognizerStateBegan) {
            self.panOriginOffset = view.left;
        } else if (pan.state == UIGestureRecognizerStateChanged) {
            CGFloat x = self.panOriginOffset + transP.x;
            if (x <= self.panOriginOffset) {
                return;
            }
            view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, transP.x, 0);
        } else if (pan.state == UIGestureRecognizerStateEnded) {
            CGPoint velocity = [pan velocityInView:view];
            if ((transP.x > view.width / 2.0) && (velocity.x >= 0)) {
                [view dismissPopup];
            } else if (velocity.x > 100.0) {
                [view dismissPopup];
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    view.transform = CGAffineTransformIdentity;
                }];
            }
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                view.transform = CGAffineTransformIdentity;
            }];
        }
    } else if (view.animationType == AYPopupAnimationTypeSideFromLeft) {
        if (pan.state == UIGestureRecognizerStateBegan) {
            self.panOriginOffset = view.right;
        } else if (pan.state == UIGestureRecognizerStateChanged) {
            CGFloat x = self.panOriginOffset + transP.x;
            if (x >= self.panOriginOffset) {
                return;
            }
            view.right = self.panOriginOffset + transP.x;
        } else if (pan.state == UIGestureRecognizerStateEnded) {
            CGPoint velocity = [pan velocityInView:view];
            if ((fabs(transP.x) > view.width / 2.0) && (velocity.x <= 0)) {
                [view dismissPopup];
            } else if (velocity.x < -100.0) {
                [view dismissPopup];
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    view.right = self.panOriginOffset;
                }];
            }
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                view.right = self.panOriginOffset;
            }];
        }
    }
}

@end
