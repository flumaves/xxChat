//
//  SelfInformationTableViewController.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/11.
//

#import "SelfInformationTableViewController.h"


@interface SelfInformationTableViewController ()

@end

@implementation SelfInformationTableViewController

#pragma mark - 加载页面和页面消失的方法
/*
 这个界面显示时隐藏tabBarController
 离开界面重新显示tabBarController
 */
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //navigationBar的title
    self.title = @"个人信息";
    //navigationBar添加一个leftButton 只要单独一个箭头
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //设置button颜色为黑色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:226/255.0 alpha:1];
    //去掉多余的cell之间的分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - leftBarButtonItem的方法
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
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
                          @"名字",@"xxChat ID",@"性别",@"地区",@"个性签名",nil];
        cell.textLabel.text = array[indexPath.section - 1];
        
        //展示数据 后期用用户模型加载
        NSArray *array_2 = [NSArray arrayWithObjects:
                            @"窝嫩叠", @"xxChatOne", @"男", @"广东", @"xxCHat" ,nil];
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
@end
