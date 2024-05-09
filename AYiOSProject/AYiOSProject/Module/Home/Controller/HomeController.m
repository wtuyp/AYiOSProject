//   
//  HomeController.m
//   
//  Created by alpha yu on 2023/12/20 
//   
   

#import "HomeController.h"
#import "HomeListCell.h"

#import "TableIndexDemoController.h"

@interface HomeController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *demoInfoArray;

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

#pragma mark - override


#pragma mark - data

- (void)setupData {
    self.demoInfoArray = @[
        @"TableIndexDemo",
    ];
}

#pragma mark - view

- (void)setupNavigationBarItems {
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:<#view#>];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.bottom.inset(0);
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

#pragma mark - setter


#pragma mark - action


#pragma mark - notification


#pragma mark - api


#pragma mark - public


#pragma mark - private


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demoInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *demoInfo = [self.demoInfoArray objectOrNilAtIndex:indexPath.row];
    
    HomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(HomeListCell.class) forIndexPath:indexPath];
    [cell updateTitle:demoInfo];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *demoInfo = [self.demoInfoArray objectOrNilAtIndex:indexPath.row];
    NSString *controllerName = STRING_FORMAT(@"%@Controller", demoInfo);
    Class controllerClass = NSClassFromString(controllerName);
    if (!controllerClass) {
        NSLog(@"%@ 控制器不存在", controllerName);
        return;
    }
    
    UIViewController *vc = [[controllerClass alloc] init];
    NAVI_PUSH_CONTROLLER(self, vc)
}

@end
