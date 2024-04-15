//   
//  AYLabelView.h
//   
//  Created by alpha yu on 2024/2/18 
//   
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 主要用于有内边距的 Label
@interface AYLabelView : UIView

@property (nonatomic, strong, readonly) UILabel *textLabel;

- (instancetype)initWithHorizontalInset:(CGFloat)horizontalInset;

@end

NS_ASSUME_NONNULL_END
