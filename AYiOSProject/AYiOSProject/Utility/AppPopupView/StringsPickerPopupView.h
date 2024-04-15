//   
//  StringsPickerPopupView.h
//   
//  Created by alpha yu on 2024/1/4 
//   
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 单列数据选项 弹窗
@interface StringsPickerPopupView : UIView

- (instancetype)initWithTitle:(NSString *)title
                    dataArray:(NSArray<NSString *> *)dataArray
                defaultString:(NSString *)defaultString;

- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, copy) NSString *selectedString;
@property (nonatomic, copy) void (^resultBlock)(NSString *result, NSInteger index);

@end

NS_ASSUME_NONNULL_END
