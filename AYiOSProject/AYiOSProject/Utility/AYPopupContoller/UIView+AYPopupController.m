//
//  UIView+AYPopupController.m
//
//  Created by alpha yu on 2021/2/4.
//

#import "UIView+AYPopupController.h"

@implementation UIView (AYPopupController)

- (AYPopupController *)popupController {
    UIResponder *next = [self nextResponder];
    while (next) {
        if ([next isKindOfClass:[AYPopupController class]]) {
            return (AYPopupController *)next;
        }
        
        next = [next nextResponder];
    }
    
    return nil;
}

- (void)popupWithAlign:(AYPopupAlign)align
              fromView:(UIView *)view
        referenceAlign:(AYPopupAlign)referenceAlign
 dismissCompletedBlock:(void (^)(void))dismissCompletedBlock {
    [self popupWithAlign:align fromView:view referenceAlign:referenceAlign offset:CGPointZero dismissCompletedBlock:dismissCompletedBlock];
}

- (void)popupWithAlign:(AYPopupAlign)align
              fromView:(UIView *)view
        referenceAlign:(AYPopupAlign)referenceAlign
                offset:(CGPoint)offset
 dismissCompletedBlock:(void (^)(void))dismissCompletedBlock {
    if (!view) {
        return;
    }
    
    [self setPopupPointFromView:view referenceAlign:referenceAlign offset:offset];
    self.popupAlign = align;
    if (dismissCompletedBlock) {
        self.dismissCompletedBlock = dismissCompletedBlock;
    }
    
    AYPopupController *vc = [[AYPopupController alloc] init];
    vc.contentView = self;

    [vc popup];
}

- (void)popupWithAlign:(AYPopupAlign)align
               atPoint:(CGPoint)point
 dismissCompletedBlock:(void (^ _Nullable)(void))dismissCompletedBlock {    
    self.popupPoint = point;
    self.popupAlign = align;
    if (dismissCompletedBlock) {
        self.dismissCompletedBlock = dismissCompletedBlock;
    }
    
    AYPopupController *vc = [[AYPopupController alloc] init];
    vc.contentView = self;

    [vc popup];
}

- (void)slideFromBottom {
    [self slideFromBottomWithHeight:0];
}

- (void)slideFromBottomWithHeight:(CGFloat)height {
    self.popupFixedHeight = height;
    self.animationType = AYPopupAnimationTypeSideFromBottom;
    
    AYPopupController *vc = [[AYPopupController alloc] init];
    vc.contentView = self;

    [vc popup];
}

- (void)slideFromLeftWithWidth:(CGFloat)width {
    self.popupFixedWidth = width;
    self.animationType = AYPopupAnimationTypeSideFromLeft;
//    self.panGestureEnable = YES;
    
    AYPopupController *vc = [[AYPopupController alloc] init];
    vc.contentView = self;
    vc.panToDismissGesture.enabled = YES;
    
    [vc popup];
}

- (void)slideFromRightWithWidth:(CGFloat)width {
    self.popupFixedWidth = width;
    self.animationType = AYPopupAnimationTypeSideFromRight;
//    self.panGestureEnable = YES;
    
    AYPopupController *vc = [[AYPopupController alloc] init];
    vc.contentView = self;
    vc.panToDismissGesture.enabled = YES;
    
    [vc popup];
}

- (void)popupAtCenter {
    AYPopupController *vc = [[AYPopupController alloc] init];
    vc.contentView = self;
    [self popupWithAlign:AYPopupAlignCenter fromView:vc.view referenceAlign:AYPopupAlignCenter dismissCompletedBlock:NULL];
}

- (void)dismissPopup {
    [self.popupController dismiss];
}

- (void)dismissPopupWithCompletedBlock:(void (^)(void))block {
    [self.popupController dismissWithCompletedBlock:block];
}

@end
