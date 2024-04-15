//   
//  HomeController.m
//   
//  Created by alpha yu on 2023/12/20 
//   
   

#import "HomeController.h"

@interface HomeController ()


@end

@implementation HomeController

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    [self setupData];
    [self setupNavigationBarItems];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollView.showsVerticalScrollIndicator = NO;
    
    WEAK_OBJ(scrollView)
    scrollView.mj_header = [AppRefreshHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            STRONG_OBJ(scrollView)
            [scrollView.mj_header endRefreshing];
        });
    }];
    
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - getter


#pragma mark - setter


#pragma mark - action


#pragma mark - notification


#pragma mark - api


#pragma mark - public


#pragma mark - private


@end
