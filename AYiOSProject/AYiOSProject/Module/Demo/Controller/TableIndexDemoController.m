//   
//  TableIndexDemoController.m
//   
//  Created by alpha yu on 2024/5/7 
//   
   

#import "TableIndexDemoController.h"
#import "AppTableIndexView.h"
#import "HomeListCell.h"
#import "DemoModel.h"

@interface TableIndexDemoController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AppTableIndexView *indexView0;    ///< 右边的 indexView
@property (nonatomic, strong) AppTableIndexView *indexView1;    ///< 右边的 indexView

@end

@implementation TableIndexDemoController

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TableIndex Demo";

    [self setupData];
    [self setupNavigationBarItems];
    [self setupSubviews];
    
    [MBProgressHUD showLoadingInView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadTableViewData];
        [MBProgressHUD hideAllTipsInView:self.view];
    });
}

#pragma mark - override


#pragma mark - data

- (void)setupData {

}

#pragma mark - view

- (void)setupNavigationBarItems {
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:<#view#>];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // AppNaviView 自定义导航栏
    [self addNaviViewAndConfig:^(AppNaviView * _Nonnull naviView) {
        naviView.title = @"TableIndex Demo";
    }];
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.inset(0);
    }];
    
    [self.view addSubview:self.indexView0];
    [self.view addSubview:self.indexView0.indicatorView];
    [self.indexView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tableView);
        make.right.mas_equalTo(-SCALE(5));
    }];
    [self.indexView0.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.indexView0);
        make.right.equalTo(self.indexView0.mas_left).offset(-SCALE(43));
    }];
    
    [self.view addSubview:self.indexView1];
    [self.view addSubview:self.indexView1.indicatorView];
    [self.indexView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tableView);
        make.left.mas_equalTo(SCALE(5));
    }];
    [self.indexView1.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.indexView1);
        make.left.equalTo(self.indexView1).offset(SCALE(43));
    }];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, TAB_BAR_HEIGHT, 0);
        _tableView.dataSource = (id<UITableViewDataSource>)self;
        _tableView.delegate = (id<UITableViewDelegate>)self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:HomeListCell.class forCellReuseIdentifier:NSStringFromClass(HomeListCell.class)];
    }
    return _tableView;
}

- (AppTableIndexView *)indexView0 {
    if (!_indexView0) {
        _indexView0 = [[AppTableIndexView alloc] init];
        _indexView0.delegate = (id<AppTableIndexViewDelegate>)self;
        _indexView0.itemTextColor = COLOR_HEX(#323232);
        _indexView0.itemSelectedTextColor = COLOR_HEX(#7E7AF5);
        _indexView0.trackBarBackgroundColor = UIColor.whiteColor;
        _indexView0.itemTextFont = FONT(10);
        [_indexView0 setShadowWithColor:COLOR_HEX(#000000) opacity:0.16 offset:CGSizeMake(0, 3) radius:6];
    }
    return _indexView0;
}

- (AppTableIndexView *)indexView1 {
    if (!_indexView1) {
        _indexView1 = [[AppTableIndexView alloc] init];
        _indexView1.delegate = (id<AppTableIndexViewDelegate>)self;
        _indexView1.itemTextColor = COLOR_HEX(#000000);
        _indexView1.itemSelectedTextColor = COLOR_HEX(#7E7AF5);
        _indexView1.trackBarBackgroundColor = nil;
        _indexView1.itemTextFont = FONT(10);
        _indexView1.itemSelectedBgColor = UIColor.whiteColor;
    }
    return _indexView1;
}

#pragma mark - setter


#pragma mark - action


#pragma mark - notification


#pragma mark - api


#pragma mark - public


#pragma mark - private

- (void)loadTableViewData {
    NSArray *titleArray = @[@"A", @"C", @"E", @"H", @"Q", @"S", @"X", @"Z"];
    for (NSString *index in titleArray) {
        for (NSInteger i = 0; i < arc4random_uniform(30) + 10; i++) {
            DemoModel *model = [[DemoModel alloc] init];
            model.name = STRING_FORMAT(@"%@_%li", index, (long)i);
            
            // 根据索引增加索引数据
            [self.tableView addIndexData:model index:index];
        }
    }
    
    // 更新 tableView 索引文本
    [self.tableView updateIndexArray:titleArray];
    
    // 更新 indexView 索引文本
    [self.indexView0 updateIndexTextArray:titleArray];
    [self.indexView1 updateIndexTextArray:titleArray];
    
    // indexView 初始选中第一项
    [self.indexView0 itemSelectedWithIndexText:self.tableView.indexArray.firstObject];
    [self.indexView1 itemSelectedWithIndexText:self.tableView.indexArray.firstObject];
    
    [self.tableView reloadData];
    
    // AYDataState 视图数据状态的应用
    self.tableView.viewDataState = self.tableView.indexArray.count == 0 ? AYViewDataStateEmpty : AYViewDataStateHidden;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableView.indexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *index = self.tableView.indexArray[section];
    NSArray *dataArray = [self.tableView indexDataArrayWithIndex:index];
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *index = self.tableView.indexArray[indexPath.section];
    
    // 根据索引获取索引数据数组
    NSArray *dataArray = [self.tableView indexDataArrayWithIndex:index];
    
    DemoModel *model = [dataArray objectOrNilAtIndex:indexPath.row];
    
    HomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(HomeListCell.class) forIndexPath:indexPath];
    [cell updateTitle:model.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.whiteColor;
    
    NSString *index = [self.tableView.indexArray objectOrNilAtIndex:section];
    UILabel *label = [UILabel labelWithColor:COLOR_HEX(#636363) font:FONT(11) text:index];
    
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(SCALE(16));
    }];
    
    return view;
}

// tableView 滚动时更新索引选中项
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [self.tableView indexPathsForVisibleRows].firstObject;
    NSString *index = [self.tableView.indexArray objectOrNilAtIndex:indexPath.section];
    [self.indexView0 itemSelectedWithIndexText:index];
    [self.indexView1 itemSelectedWithIndexText:index];
}

#pragma mark - AppTableIndexViewDelegate

- (void)appTableIndexView:(AppTableIndexView *)view text:(NSString *)text index:(NSInteger)index {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];

    if (view == self.indexView1) {
        // indicatorView 跟随位置变动
        [self.indexView1.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_top).offset(view.touchPoint.y);
            make.left.equalTo(view).offset(SCALE(43));
        }];
    }
}

- (void)appTableIndexViewEndAction {
    // 结束时更新索引，也可以不更新
    NSIndexPath *indexPath = [self.tableView indexPathsForVisibleRows].firstObject;
    NSString *index = [self.tableView.indexArray objectOrNilAtIndex:indexPath.section];
    [self.indexView0 itemSelectedWithIndexText:index];
    [self.indexView1 itemSelectedWithIndexText:index];
}

@end
