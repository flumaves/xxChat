//
//  SearchInfomationController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/3.
//

#import "SearchInfomationController.h"

@interface SearchInfomationController ()<UITextViewDelegate>

@end

@implementation SearchInfomationController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllViews];

}
//基本设置
- (void)setAllViews{
    //navigationBar的title
    self.title = @"用户信息";
    //navigationBar添加一个leftButton 只要单独一个箭头
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //设置button颜色为主色调
    self.navigationController.navigationBar.tintColor = MainColor;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:226/255.0 alpha:1];
    //去掉多余的cell之间的分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //留言框
    self.reasonTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, 340, ScreenWidth-30, 200)];
    self.reasonTextView.delegate = self;
    self.reasonTextView.font = [UIFont systemFontOfSize:16];
    self.reasonTextView.textColor = [UIColor lightGrayColor];
    self.reasonTextView.text = @"给对方留言：";
    [self.tableView addSubview:self.reasonTextView];
    
    //添加button
    self.addButton = [[UIButton alloc]initWithFrame:CGRectMake(15,550, ScreenWidth-30, 50)];
    [self.addButton setBackgroundColor:MainColor];
    [self.addButton setTitle:@"加好友" forState:UIControlStateNormal];
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.addButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.addButton];
}

#pragma mark - leftBarButtonItem的方法
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //如果user信息被传进来了
    if (self.User) {
        return 6;
    }else{
        return 3;
    }
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
    if (self.User){
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
                              @"名字",@"xxChat ID",@"性别",@"地区",@"个性签名",nil];
            cell.textLabel.text = array[indexPath.section - 1];
            
            //展示数据
            
            NSArray *array_2 = [self getInfoFromUser:self.User];
            cell.detailTextLabel.text = array_2[indexPath.section - 1];
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
    }else if(self.group){
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
            //按顺序显示 群名 群号
            NSArray *array = [NSArray arrayWithObjects:
                              @"群名",@"xxChat GroupID",nil];
            cell.textLabel.text = array[indexPath.section - 1];
            
            //展示数据
            NSArray *array_2 = [self getInfoFromGroup:self.group];
            cell.detailTextLabel.text = array_2[indexPath.section - 1];
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
    }else{
        NSLog(@"点击搜索出来的对象时，即没有好友传入，也没有群组传入");
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
    }else if (user.gender == kJMSGUserGenderMale){
        gender = @"男";
    }else{
        gender = @"女";
    }
    //按顺序排好，昵称，账号，性别，地址，签名
    NSArray* array = [NSArray arrayWithObjects:nickName,userName,gender,address,signature, nil];
    return array;
}

//获取群信息方法
- (NSArray*)getInfoFromGroup: (JMSGGroup*)group{
    NSString* name = group.name;
    NSString* gid = group.gid;
    NSArray* array = [NSArray arrayWithObjects:name,gid,nil];
    return array;
}

#pragma mark - 加好友方法
- (void)addFriend{
    NSString* userName = self.User.username;
    NSString* reason = self.reasonTextView.text;
    if ([reason isEqualToString:@"给对方留言："]) {
        reason = @"";
    }
    
    
    //发送好友请求方法
    [JMSGFriendManager sendInvitationRequestWithUsername:userName appKey:JMESSAGE_APPKEY reason:reason completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                [self showAlertViewWithMessage:@"已发送好友请求"];
            }else{
                [self showAlertViewWithMessage:@"发送好友请求失败"];
                NSLog(@"-发送好友请求失败：%@-",error);
            }
    }];
}

#pragma mark -展示提示框
//展示提示框
-(void)showAlertViewWithMessage: (NSString*)message
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     
    }];

  [alertController addAction:cancelAction];
  [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - textview delegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if([_reasonTextView.text isEqualToString:@"给对方留言："]){
        _reasonTextView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if([_reasonTextView.text isEqualToString:@""]){
        _reasonTextView.text = @"给对方留言：";
    }
}
@end
