//   
//  UIView+AppPopup.m
//   
//  Created by alpha yu on 2024/12/17 
//   
   

#import "UIView+AppPopup.h"
#import "MacroObjc.h"
#import "UIUtils.h"

@interface UIView ()

@property (nonatomic, copy) void (^keyboardWillShowBlock)(NSTimeInterval animationDuration, UIViewAnimationOptions animationOptions, CGRect keyboardFrame);
@property (nonatomic, copy) void (^keyboardWillHideBlock)(NSTimeInterval animationDuration, UIViewAnimationOptions animationOptions, CGRect keyboardFrame);

@end

@implementation UIView (AppPopup)

AppSynthesizeIdWeakProperty(targetController, setTargetController)
AppSynthesizeIdCopyProperty(keyboardWillShowBlock, setKeyboardWillShowBlock)
AppSynthesizeIdCopyProperty(keyboardWillHideBlock, setKeyboardWillHideBlock)

#pragma mark - getter



#pragma mark - public

- (void)popupWithAlign:(AYPopupAlign)align
               atPoint:(CGPoint)point {
    self.animationType = AYPopupAnimationTypeFade;
    self.popupPoint = point;
    self.popupAlign = align;
    
    [self.target popupView:self];
}

- (void)popupWithAlign:(AYPopupAlign)align
              fromView:(UIView *)view
             viewAlign:(AYPopupAlign)viewAlign {
    [self popupWithAlign:align fromView:view viewAlign:viewAlign offset:CGPointZero];
}

- (void)popupWithAlign:(AYPopupAlign)align
              fromView:(UIView *)view
             viewAlign:(AYPopupAlign)viewAlign
                offset:(CGPoint)offset {
    if (!view) {
        return;
    }

    self.animationType = AYPopupAnimationTypeFade;
    self.popupPoint = [self pointAtTargetController:self.target fromView:view viewAlign:viewAlign offset:offset];
    self.popupAlign = align;
    
    [self.target popupView:self];
}

- (void)slideFromBottom {
    [self slideFromBottomWithHeight:0];
}

- (void)slideFromBottomWithHeight:(CGFloat)height {
    self.animationType = AYPopupAnimationTypeSideFromBottom;
    self.popupFixedHeight = height;
    
    [self.target popupView:self];
}

- (void)slideFromLeftWithWidth:(CGFloat)width {
    self.animationType = AYPopupAnimationTypeSideFromLeft;
    self.popupFixedWidth = width;
    [self addGestureRecognizer:self.panToDismissGesture];
    
    [self.target popupView:self];
}

- (void)slideFromRightWithWidth:(CGFloat)width {
    self.animationType = AYPopupAnimationTypeSideFromRight;
    self.popupFixedWidth = width;
    [self addGestureRecognizer:self.panToDismissGesture];
    
    [self.target popupView:self];
}

- (void)popupAtCenter {
    [self popupWithAlign:AYPopupAlignCenter fromView:self.target.view viewAlign:AYPopupAlignCenter];
}

- (void)dismissPopup {
    [self.target dismissView:self];
}

- (void)registerKeyboardObserverWithWillShowBlock:(void (^)(NSTimeInterval animationDuration, 
                                                            UIViewAnimationOptions animationOptions,
                                                            CGRect keyboardFrame))willShowBlock
                                    willHideBlock:(void (^)(NSTimeInterval animationDuration,
                                                            UIViewAnimationOptions animationOptions,
                                                            CGRect keyboardFrame))willHideBlock {
    self.keyboardWillShowBlock = willShowBlock;
    self.keyboardWillHideBlock = willHideBlock;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotify:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotify:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)alwaysKeepViewBottomAboveKeyboardTop {
    WEAK_SELF
    [self registerKeyboardObserverWithWillShowBlock:^(NSTimeInterval animationDuration, UIViewAnimationOptions animationOptions, CGRect keyboardFrame) {
        [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
            STRONG_SELF
            self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -keyboardFrame.size.height);
        } completion:nil];
    } willHideBlock:^(NSTimeInterval animationDuration, UIViewAnimationOptions animationOptions, CGRect keyboardFrame) {
        [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
            STRONG_SELF
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

#pragma mark - private

- (UIViewController *)target {
    if (!self.targetController) {
        // 这里没有考虑 presentedViewController 等遮挡，可自行设置 targetController
        self.targetController = [UIUtils rootViewController];
    }
    
    return self.targetController;
}

- (CGPoint)pointAtTargetController:(UIViewController *)target fromView:(UIView *)fromView viewAlign:(AYPopupAlign)viewAlign {
    return [self pointAtTargetController:target fromView:fromView viewAlign:viewAlign offset:CGPointZero];
}

- (CGPoint)pointAtTargetController:(UIViewController *)target fromView:(UIView *)fromView viewAlign:(AYPopupAlign)viewAlign offset:(CGPoint)offset {
    if (!fromView) {
        return CGPointZero;
    }
    
    CGPoint referencePoint = CGPointZero;
    switch (viewAlign) {
        case AYPopupAlignTopLeft: {
            referencePoint = CGPointMake(CGRectGetMinX(fromView.frame), CGRectGetMinY(fromView.frame));
        }
            break;
        case AYPopupAlignTopRight: {
            referencePoint = CGPointMake(CGRectGetMaxX(fromView.frame), CGRectGetMinY(fromView.frame));
        }
            break;
        case AYPopupAlignBottomLeft: {
            referencePoint = CGPointMake(CGRectGetMinX(fromView.frame), CGRectGetMaxY(fromView.frame));
        }
            break;
        case AYPopupAlignBottomRight: {
            referencePoint = CGPointMake(CGRectGetMaxX(fromView.frame), CGRectGetMaxY(fromView.frame));
        }
            break;
        case AYPopupAlignCenter: {
            referencePoint = fromView.center;
        }
            break;
        case AYPopupAlignCenterLeft: {
            referencePoint = CGPointMake(CGRectGetMinX(fromView.frame), CGRectGetMidY(fromView.frame));
        }
            break;
        case AYPopupAlignCenterRight: {
            referencePoint = CGPointMake(CGRectGetMaxX(fromView.frame), CGRectGetMidY(fromView.frame));
        }
            break;
        case AYPopupAlignTopCenter: {
            referencePoint = CGPointMake(CGRectGetMidX(fromView.frame), CGRectGetMinY(fromView.frame));
        }
            break;
        case AYPopupAlignBottomCenter: {
            referencePoint = CGPointMake(CGRectGetMidX(fromView.frame), CGRectGetMaxY(fromView.frame));
        }
            break;
            
        default:
            break;
    }
    
    CGPoint point = [target.view convertPoint:CGPointMake(referencePoint.x + offset.x, referencePoint.y + offset.y) fromView:fromView.superview];
    
    return point;
}

#pragma mark - notify

- (void)keyboardWillShowNotify:(NSNotification *)notify {
    NSInteger curve = [notify.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect frame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (self.keyboardWillShowBlock) {
        self.keyboardWillShowBlock(duration, curve << 16, frame);
    }
}

- (void)keyboardWillHideNotify:(NSNotification *)notify {
    NSInteger curve = [notify.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect frame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (self.keyboardWillHideBlock) {
        self.keyboardWillHideBlock(duration, curve << 16, frame);
    }
}

@end
