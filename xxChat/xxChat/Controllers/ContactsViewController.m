//
//  ContactViewController.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/9.
//

#import "ContactsViewController.h"

@interface ContactsViewController () <UITableViewDelegate,UITableViewDataSource>

//加载联系人列表的tableView
@property (nonatomic, strong)UITableView *contactsTableView;


@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contactsTableView];
    [self layoutView];
}

- (UITableView *)contactsTableView {
    if (_contactsTableView == nil) {
        _contactsTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _contactsTableView.delegate = self;
        _contactsTableView.dataSource = self;
    }
    return _contactsTableView;
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
    NSString *ID = @"contact";
    
    UITableViewCell *cell = [self.contactsTableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = @"This is a contact";
    
    return cell;
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
