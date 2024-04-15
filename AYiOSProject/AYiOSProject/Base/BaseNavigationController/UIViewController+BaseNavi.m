//
//  UIViewController+BaseNavi.m
//
//  Created by alpha yu on 2023/12/20.
//

#import "UIView+AppCategory.h"
#import "MMMLab.h"

@implementation UIViewController (BaseNavi)

MMMSynthesizeBOOLProperty(backBarButtonHidden, setBackBarButtonHidden)
MMMSynthesizeBOOLProperty(interactivePopDisabled, setInteractivePopDisabled)

- (BOOL)backBarButtonAction {
    return YES;
}

@end

