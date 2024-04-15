//   
//  AppWebViewController.m
//   
//  Created by alpha yu on 2023/12/28 
//   
   

#import "AppWebViewController.h"

@interface AppWebViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation AppWebViewController

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupData];
    [self setupNavigationBarItems];
    [self setupSubviews];
    
    if (self.url.length > 0) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [self.webView loadRequest:request];
    }
    
    if (self.htmlString.length > 0) {
        [self.webView loadHTMLString:self.htmlString baseURL:nil];
    }
}

#pragma mark - override


#pragma mark - data

- (void)setupData {

}

#pragma mark - view

- (void)setupNavigationBarItems {
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:<#view#>];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setupSubviews {
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
    }];
}

#pragma mark - getter

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _webView;
}

#pragma mark - setter


#pragma mark - action


#pragma mark - notification


#pragma mark - api


#pragma mark - public


#pragma mark - private



@end
