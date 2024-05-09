//   
//   AppTableIndexView.h
//   
//   Created by alpha yu on 2023/5/19 
//   
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AppTableIndexView;

/// 索引栏代理
@protocol AppTableIndexViewDelegate <NSObject>

/// 手按下或者手滑动时
- (void)appTableIndexView:(AppTableIndexView *)view text:(NSString *)text index:(NSInteger)index;

/// 手抬起时
- (void)appTableIndexViewEndAction;

@end

/// 指示器协议
@protocol AppTableIndexIndicatorViewProtocol <NSObject>

- (void)showIndicatorWithText:(NSString *)text;
- (void)dismissIndicator;

@end

/// 列表索引栏
@interface AppTableIndexView : UIView

@property (nonatomic, strong, nullable) UIColor *trackBarBackgroundColor;   ///< 轨道背景色，默认 #F4F4F4
@property (nonatomic, assign) CGFloat trackBarWidth;            ///< 轨道背宽度，默认 16
@property (nonatomic, assign) CGFloat trackBarRadius;           ///< 轨道背圆角，默认 8

@property (nonatomic, strong) UIColor *itemTextColor;           ///< 索引项文本颜色，默认 #323232
@property (nonatomic, strong) UIColor *itemSelectedTextColor;   ///< 索引项文本选中颜色，默认 #000000
@property (nonatomic, strong) UIFont *itemTextFont;             ///< 索引项文本字体，默认 10

@property (nonatomic, assign) CGFloat itemSpace;                ///< 索引项间距，默认 8
@property (nonatomic, assign) CGFloat itemSize;                 ///< 索引项大小，默认 14
@property (nonatomic, assign) CGFloat itemBgCornerRadius;       ///< 索引项文本选中背景圆角

@property (nonatomic, strong) UIColor *itemSelectedBgColor;     ///< 索引项文本选中背景颜色，默认 clearColor

@property (nonatomic, assign, readonly) CGPoint touchPoint;     ///< 触摸位置，外部坐标点需要转换

@property (nonatomic, weak) id<AppTableIndexViewDelegate> delegate;

/// 指示器，默认 AppTableIndexIndicatorView (需要增加到一个父视图下并布局)
@property (nonatomic, strong) UIView<AppTableIndexIndicatorViewProtocol> *indicatorView;

/// 更新索引文本数组
- (void)updateIndexTextArray:(NSArray<NSString *> *)textArray;

/// 选中某个索引
- (void)itemSelectedWithIndexText:(NSString *)indexText;

@end

/// 索引栏的指示器
@interface AppTableIndexIndicatorView : UIView <AppTableIndexIndicatorViewProtocol>

@property (nonatomic, copy, readonly) NSString *indicatorText;
@property (nonatomic, strong) UIColor *textColor;   ///< 文本颜色，默认 #000000
@property (nonatomic, strong) UIFont *textFont;     ///< 文本字体，默认 32

@end

NS_ASSUME_NONNULL_END
