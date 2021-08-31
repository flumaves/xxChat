//
//  MessageViewController.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/7.
//

#import "ChatsViewController.h"
#import "ChatCell.h"

@interface ChatsViewController () <UITableViewDataSource, UITableViewDelegate>

//加载会话列表的tableView
@property (nonatomic, strong)UITableView *chatTableView;

@end

@implementation ChatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.chatTableView];
    [self layoutView];
    
}

- (UITableView *)chatTableView {
    if (_chatTableView == nil) {
        _chatTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
    }
    return _chatTableView;
}

#pragma mark -tableView的 dataSource 和 delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //复用ID为 chat
    NSString *ID = @"chat";
    
    ChatCell *cell = [self.chatTableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark -
- (void)layoutView{
    //右上角的添加button
    UIBarButtonItem *addBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openAddController)];
    addBtnItem.tintColor = MainColor;
    
    UIBarButtonItem *searchBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(openSearchController)];
    searchBtnItem.tintColor = MainColor;
    NSArray *btnArray = [NSArray arrayWithObjects:addBtnItem,searchBtnItem, nil];
    
    [self.navigationItem setRightBarButtonItems:btnArray];
    
}
//打开搜索页面
- (void)openSearchController{
}


//打开添加页面
- (void)openAddController{
    AddViewController *addViewController = [[AddViewController alloc]init];
    [self.navigationController pushViewController:addViewController animated:YES];
    
}




@end
