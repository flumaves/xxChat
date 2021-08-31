//
//  AddViewController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/8/19.
//

#import "AddViewController.h"

@interface AddViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"添加朋友和群组";
    [self setAllViews];
    
}

- (void)setAllViews{
    //加朋友模式 按钮
    self.addFriendButton = [[UIButton alloc]init];
    [self.addFriendButton setTitle:@"找人" forState:UIControlStateNormal];
    [self.addFriendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addFriendButton setBackgroundColor:MainColor];
    [self.addFriendButton.layer setBorderWidth:0.5];
    [self.addFriendButton.layer setBorderColor:[MainColor CGColor]];
    [self.addFriendButton addTarget:self action:@selector(changePattern:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addFriendButton];
    
    //加群组模式 按钮
    self.addGroupButton = [[UIButton alloc]init];
    [self.addGroupButton setTitle:@"找群" forState:UIControlStateNormal];
    [self.addGroupButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.addGroupButton setTitleColor:MainColor forState:UIControlStateNormal];
    [self.addGroupButton setBackgroundColor:[UIColor whiteColor] ];
    [self.addGroupButton.layer setBorderWidth:0.5];
    [self.addGroupButton.layer setBorderColor:[MainColor CGColor]];
    [self.addGroupButton addTarget:self action:@selector(changePattern:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addGroupButton];
    
    //搜索框
    self.searchField = [[UITextField alloc]init];
    [self.searchField setBackgroundColor:[UIColor lightGrayColor]];
    self.searchField.layer.cornerRadius = 6;
    self.searchField.backgroundColor = [UIColor whiteColor];
    [self.searchField setFont:[UIFont systemFontOfSize:15]];
    self.searchField.placeholder = @" 请输入xxChatID";
    [self.searchField.layer setBorderWidth:0.5];
    [self.searchField.layer setBorderColor: [MainColor CGColor]];
    self.searchField.textAlignment = NSTextAlignmentCenter;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 100)];
    view.backgroundColor = [UIColor clearColor];
    view.image = [UIImage imageNamed:@"搜索"];
    self.searchField.leftView = view;
    [self.view addSubview:_searchField];
    
    //搜索按钮
    self.confirmButton = [[UIButton alloc]init];
    [self.confirmButton setBackgroundColor:[UIColor whiteColor]];
    [self.confirmButton setTitle:@"搜索" forState:UIControlStateNormal];
    [self.confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.confirmButton setTitleColor:MainColor forState:UIControlStateNormal];
    [self.view addSubview:_confirmButton];
    
    //显示结果的tableview
    self.searchTableView = [[UITableView alloc]init];
    self.searchTableView.dataSource = self;
    self.searchTableView.delegate = self;
    [self.view addSubview:_searchTableView];
    
    
    
    
    [self autoLayoutAllViews];
}
//自动布局方法
- (void)autoLayoutAllViews{
    ///加好友模式 按钮
    _addFriendButton.sd_layout.
    leftSpaceToView(self.view, ScreenWidth/2-60).
    heightIs(30).
    autoWidthRatio(2).
    topSpaceToView(self.view, 100);
    ///加群组模式 按钮
    _addGroupButton.sd_layout.
    leftSpaceToView(_addFriendButton, 0).
    topEqualToView(_addFriendButton).
    widthRatioToView(_addFriendButton, 1).
    heightRatioToView(_addFriendButton, 1);
    ///搜索框
    _searchField.sd_layout.
    topSpaceToView(_addFriendButton, 20).
    heightIs(30).
    widthIs(ScreenWidth-100).
    leftSpaceToView(self.view, 25);
    _searchField.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    ///搜索按钮
    _confirmButton.sd_layout.
    topEqualToView(_searchField).
    bottomEqualToView(_searchField).
    leftSpaceToView(_searchField, 5).
    rightSpaceToView(self.view, 10);
    ///搜索结果的tableview
    _searchTableView.sd_layout.
    topSpaceToView(_searchField, 30).
    widthIs(ScreenWidth).
    bottomEqualToView(self.tabBarController);
    
    
    
}

//两个按钮的点击方法，切换模式
- (void)changePattern: (UIButton*)button{
    //改变button颜色，以及更改占位字
    if (self.addFriendButton==button&&self.inFindGroup) {
        [self.addFriendButton setBackgroundColor:MainColor];
        [self.addGroupButton setBackgroundColor:[UIColor whiteColor]];
        [self.addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addGroupButton setTitleColor:MainColor forState:UIControlStateNormal];
        self.searchField.text = @"";
        self.searchField.placeholder = @"请输入xxChatID";
        self.inFindGroup = NO;
    }else if (self.addGroupButton==button&&!self.inFindGroup){
        [self.addGroupButton setBackgroundColor:MainColor];
        [self.addFriendButton setBackgroundColor:[UIColor whiteColor]];
        [self.addGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addFriendButton setTitleColor:MainColor forState:UIControlStateNormal];
        self.searchField.text =@"";
        self.searchField.placeholder = @"请输入xxChat群聊ID";
        self.inFindGroup = YES;
    }
}

#pragma mark -tableView的 dataSource 和 delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //复用ID为 add
    NSString *ID = @"add";
    
    SearchResultCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[SearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

@end
