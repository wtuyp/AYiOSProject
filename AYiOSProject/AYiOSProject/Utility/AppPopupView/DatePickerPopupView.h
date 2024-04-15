//   
//  DatePickerPopupView.h
//   
//  Created by alpha yu on 2024/1/4 
//   
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 日期选择器 弹窗
@interface DatePickerPopupView : UIView

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *minDate;

@property (nonatomic, copy) void (^dateSelectedBlock)(NSDate *date);

@end

NS_ASSUME_NONNULL_END
