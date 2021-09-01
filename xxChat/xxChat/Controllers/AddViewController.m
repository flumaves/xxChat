//
//  AddViewController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/8/19.
//

#import "AddViewController.h"

@interface AddViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllViews];
    
}
//懒加载
- (NSMutableArray*)userAndGroupArray{
    if (_userAndGroupArray==nil) {
        _userAndGroupArray = [[NSMutableArray alloc]init];
    }
    return _userAndGroupArray;
}

- (void)setAllViews{
    //基本设置
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"添加朋友和群组";
    self.navigationController.navigationBar.tintColor = MainColor;

    
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
    self.searchField.textAlignment = NSTextAlignmentCenter;//居中显示
    self.searchField.clearButtonMode = UITextFieldViewModeWhileEditing;//清除按钮
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 100)];
    view.backgroundColor = [UIColor clearColor];
    view.image = [UIImage imageNamed:@"搜索"];
    self.searchField.leftView = view;
    self.searchField.delegate = self;
    
    self.searchField.text = @"111111";//测试用 记得删
    
    [self.view addSubview:_searchField];
    
    //搜索按钮
    self.confirmButton = [[UIButton alloc]init];
    [self.confirmButton setBackgroundColor:[UIColor whiteColor]];
    [self.confirmButton setTitle:@"搜索" forState:UIControlStateNormal];
    [self.confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.confirmButton setTitleColor:MainColor forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(searchingFriendAndGroup) forControlEvents:UIControlEventTouchUpInside];
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
    topSpaceToView(self.navigationController.navigationBar, 10);
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
    bottomEqualToView(self.view);

    
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

#pragma mark - tableView的 dataSource 和 delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger i = self.userAndGroupArray.count;
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //复用ID为 add
    NSString *ID = @"add";
    SearchResultCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    //获取搜索得到的user或group，赋值ID和昵称
    if (!_inFindGroup) {
        JMSGUser* user = self.userAndGroupArray[0];
        cell.ID.text = user.username;
        cell.name.text = user.nickname;
    }else{
        JMSGGroup* group = self.userAndGroupArray[0];
        cell.ID.text = group.gid;
        cell.name.text = group.name;
    }
    return cell;
}
//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
//当cell被点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;//隐藏tabar
    SearchInfomationController* searchInfoVC = [[SearchInfomationController alloc]init];
    //传入数据
    if (!_inFindGroup) {
        searchInfoVC.User = self.userAndGroupArray[0];
    }else{
        searchInfoVC.group = self.userAndGroupArray[0];
    }
    [self.navigationController pushViewController:searchInfoVC animated:YES];
  
}
#pragma mark - 搜索方法
- (void)searchingFriendAndGroup{
   
    //如果找群按钮没被选中
    if (!_inFindGroup) {
        NSString *username = self.searchField.text;
        NSArray *usernameArray = [NSArray arrayWithObject:username];
        [JMSGUser userInfoArrayWithUsernameArray:usernameArray appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                NSArray *userArray = resultObject;
                //先清空，再加进来
                [self.userAndGroupArray removeAllObjects];
                [self.userAndGroupArray addObjectsFromArray:userArray];
                [self.searchTableView reloadData];

            }else{
                NSLog(@"-搜索朋友出现错误：%@-",error);
            }
            
        }];
    }else{
        NSString* groupID = self.searchField.text;
        [JMSGGroup groupInfoWithGroupId:groupID completionHandler:^(id resultObject, NSError *error) {
                if (!error) {
                    JMSGGroup *group = resultObject;
                    [self.userAndGroupArray removeAllObjects];
                    [self.userAndGroupArray addObject:group];
                }else{
                    NSLog(@"-搜索群组出现错误：%@-",error);
                }
        }];
    }
}
#pragma mark - textfield 的delegate
//输入框内有内容变化
- (void)textFieldDidChangeSelection:(UITextField *)textField API_AVAILABLE(ios(13.0), tvos(13.0)){
    //如果搜索框内没有文本
    if(self.searchField.text.length==0){
        [self.userAndGroupArray removeAllObjects];
        [self.searchTableView reloadData];
    }
}


@end
