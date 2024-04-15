//   
//   UIScrollView+AppCategory.m
//
//   Created by alpha yu on 2023/3/30 
//   
   

#import "UIScrollView+AppCategory.h"
#import <objc/runtime.h>

@implementation UIScrollView (AppCategory)

- (UIView *)hContainerView {
    UIView *view = objc_getAssociatedObject(self, _cmd);
    if (!view) {
        view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.inset(0);
            make.height.equalTo(self);
        }];
        objc_setAssociatedObject(self, _cmd, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return view;
}

- (UIView *)vContainerView {
    UIView *view = objc_getAssociatedObject(self, _cmd);
    if (!view) {
        view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.inset(0);
            make.width.equalTo(self);
        }];
        objc_setAssociatedObject(self, _cmd, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return view;
}


@end
