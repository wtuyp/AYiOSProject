//
//  UIViewController+AppBaseNavi.m
//
//  Created by alpha yu on 2023/12/20.
//

#import "UIView+AppCategory.h"
#import "MacroObjc.h"

@implementation UIViewController (AppBaseNavi)

AppSynthesizeBOOLProperty(backBarButtonHidden, setBackBarButtonHidden)
AppSynthesizeBOOLProperty(interactivePopDisabled, setInteractivePopDisabled)

- (BOOL)backBarButtonAction {
    return YES;
}

@end

