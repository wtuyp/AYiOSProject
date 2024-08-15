//
//  AppTabBar.m
//
//  Created by alpha yu on 2022/11/9.
//

#import "AppTabBar.h"
#import "AppTabBarItemView.h"

@interface AppTabBar ()

@property (nonatomic, copy) NSArray<AppTabBarItemView *> *itemViewArray;

@end

@implementation AppTabBar

#pragma mark - getter

- (AppTabBarItemView *)createTabBarItemViewWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag {
    AppTabBarItemView *button = [AppTabBarItemView buttonWithTitle:title color:TAB_BAR_TITLE_NORMAL_COLOR selectedColor:TAB_BAR_TITLE_SELECTED_COLOR font:(IS_IPHONE ? TAB_BAR_TITLE_FONT : FONT_BOLD(13)) image:image selectedImage:selectedImage imagePosition:IS_IPHONE ? TitleImageButtonImagePositionTop : TitleImageButtonImagePositionLeft gap:IS_IPHONE ? 0 : 10];
    button.adjustsButtonWhenHighlighted = NO;
    [button addTarget:self action:@selector(itemViewAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;

    return button;
}

#pragma mark - setter

- (void)setItemConfigArray:(NSArray<AppTabBarItemConfig *> *)itemConfigArray {
    _itemConfigArray = itemConfigArray;
    
    [self removeAllSubviews];
    
    for (AppTabBarItemConfig *config in itemConfigArray) {
        AppTabBarItemView *itemView = [self createTabBarItemViewWithTitle:config.title image:config.image selectedImage:config.selectedImage tag:config.tag];
        [self addSubview:itemView];
    }

    self.itemViewArray = self.subviews;
    [self.itemViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.itemViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)setSelectedItemTag:(NSInteger)selectedItemTag {
    _selectedItemTag = selectedItemTag;
    for (AppTabBarItemView *item in self.itemViewArray) {
        item.selected = (item.tag == selectedItemTag) ? YES : NO;
    }
}

#pragma mark - action

- (void)itemViewAction:(AppTabBarItemView *)sender {
    NSInteger tag = sender.tag;
    if (self.selectedItemBlock) {
        self.selectedItemBlock(tag);
    }
}

#pragma mark - private

- (void)animate:(AppTabBarItemView *)item {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.2;
    animation.repeatCount = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:0.9];
    animation.toValue = [NSNumber numberWithFloat:1.1];
    [item.layer addAnimation:animation forKey:nil];
}

@end
