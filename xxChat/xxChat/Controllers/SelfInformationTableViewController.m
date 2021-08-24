//
//  SelfInformationTableViewController.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/11.
//

#import "SelfInformationTableViewController.h"
#import "ChangeInfoViewController.h"

@interface SelfInformationTableViewController ()

@property (nonatomic, strong) JMSGUser *user;

@end

@implementation SelfInformationTableViewController

#pragma mark - 加载页面和页面消失的方法
/*
 这个界面显示时隐藏tabBarController
 离开界面重新显示tabBarController
 */
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    //加载页面重新获取user模型 使得在更改用户信息后能及时更新
    _user = [JMSGUser myInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    
    //navigationBar的title
    self.title = @"个人信息";
    //navigationBar添加一个leftButton 只要单独一个箭头
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //设置button颜色为黑色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    //去掉多余的cell之间的分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //选中不改变状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                          @"名字",@"xxChat ID",@"性别",@"生日",@"地区",@"签名",nil];
        cell.textLabel.text = array[indexPath.section - 1];
        
        //展示数据 后期用用户模型加载
        NSString *gender = [[NSString alloc] init];
        if (_user.gender == kJMSGUserGenderMale) {
            gender = @"男";
        } else if (_user.gender == kJMSGUserGenderFemale){
            gender = @"女";
        } else {
            gender = @"未透露性别";
        }
        
        NSArray *array_2 = [NSArray arrayWithObjects:
                            _user.nickname ? _user.nickname : @"还未设置昵称哦",
                            _user.username ? _user.username : @"",
                            gender,
                            _user.birthday ? _user.birthday : @"还未设置生日哦",
                            _user.address  ? _user.address  : @"还未设置地址哦",
                            @"",    //签名处默认空白
                            nil];
        cell.detailTextLabel.text = array_2[indexPath.section - 1];
        cell.detailTextLabel.textColor = [UIColor grayColor];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ChangeInfoViewController *controller = [[ChangeInfoViewController alloc] init];
    controller.title = [@"修改" stringByAppendingString:cell.textLabel.text];
    controller.infoType = cell.textLabel.text;
    controller.user = _user;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
