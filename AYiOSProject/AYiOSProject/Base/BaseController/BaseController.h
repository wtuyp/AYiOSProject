//
//  BaseController.h
//
//  Created by MMM on 2021/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 控制器基类
@interface BaseController : UIViewController

@property (nonatomic, assign) BOOL firstLoading; ///< 首次加载

@end

NS_ASSUME_NONNULL_END
