//
//  FriendInfomationViewController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/13.
//

#import "FriendInfomationViewController.h"

@interface FriendInfomationViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FriendInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllViews];
    
}
#pragma mark - 懒加载
- (UITableView*)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _tableView;
}

//基本设置
- (void)setAllViews {
    //navigationBar的title
    self.title = @"用户信息";
    //navigationBar添加一个leftButton 只要单独一个箭头
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //设置button颜色为主色调
    self.navigationController.navigationBar.tintColor = MainColor;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:226/255.0 alpha:1];
    //去掉多余的cell之间的分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    self.chatButton = [[UIButton alloc]initWithFrame:CGRectMake(15,500, ScreenWidth-30, 50)];
    [self.chatButton setBackgroundColor:MainColor];
    [self.chatButton setTitle:@"发消息" forState:UIControlStateNormal];
    self.chatButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.chatButton addTarget:self action:@selector(touchUpInsideChatButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chatButton];
    
}

#pragma mark - leftBarButtonItem的方法
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    //右侧的小箭头
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //选中不改变状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.User) {
        if (indexPath.section == 0) {
            //第一个cell 用来显示头像 需要单独添加一个UIImageView 不单独封装
            CGFloat iconX = cell.bounds.size.width - 30;
            CGFloat iconY = 10;
            CGFloat iconL = 60;
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconL, iconL)];
            iconView.backgroundColor = [UIColor grayColor];
            iconView.layer.cornerRadius = 10;
            [cell addSubview:iconView];
            
            cell.textLabel.text = @"头像";
        } else {
            //按顺序显示 昵称 账号 性别 地区 个性签名
            NSArray *array = [NSArray arrayWithObjects:
                              @"名字",@"xxChat ID",@"性别",@"生日",@"地区",@"个性签名",nil];
            cell.textLabel.text = array[indexPath.section - 1];
            
            //展示数据
            
            NSArray *array_2 = [self getInfoFromUser:self.User];
            cell.detailTextLabel.text = array_2[indexPath.section - 1];
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
        heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //第一个显示头像的cell行高设置为80
    //其余cell设置为50
    CGFloat rowHeight = 50;
    if (indexPath.section == 0) {
        rowHeight = 80;
    }
    return rowHeight;
}
#pragma mark - 获取用户信息和群组信息的方法
//获取用户信息方法
- (NSArray*)getInfoFromUser: (JMSGUser*)user{
    //账号
    NSString* userName = user.username;
    //昵称
    NSString* nickName;
    if (user.nickname) {
        nickName = user.nickname;
    }else{
        nickName = @"未设置";
    }
    //生日
    NSString* birthday;
    if (user.birthday) {
        birthday = user.birthday;
    }else{
        birthday = @"未设置";
    }
    //地址
    NSString* address;
    if (user.address) {
        address = user.address;
    }else{
        address = @"未设置";
    }
    //签名
    NSString* signature;
    if (user.signature) {
        signature = user.signature;
    }else{
        signature = @"未设置";
    }
    //性别
    NSString* gender;
    if (user.gender == kJMSGUserGenderUnknown) {
        gender = @"未设置";
    }else if (user.gender == kJMSGUserGenderMale) {
        gender = @"男";
    }else{
        gender = @"女";
    }
    //按顺序排好，昵称，账号，性别，地址，签名
    NSArray* array = [NSArray arrayWithObjects:nickName,userName,gender,birthday,address,signature, nil];
    return array;
}




        


#pragma mark -展示提示框
//展示提示框
-(void)showAlertViewWithMessage: (NSString*)message {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     
    }];

  [alertController addAction:cancelAction];
  [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - 发消息按钮点击
- (void)touchUpInsideChatButton:(UIButton*)button {
    
    
}




@end

