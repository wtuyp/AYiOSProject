//   
//  AppWebViewController.h
//   
//  Created by alpha yu on 2023/12/28 
//   
   

#import "BaseController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 网页
@interface AppWebViewController : BaseController

@property (nonatomic, strong, readonly) WKWebView *webView;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *htmlString;

- (void)setupSubviews NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
