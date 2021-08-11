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

- (void)viewDidLoad {
    [super viewDidLoad];
    //navigationBar的title
    self.title = @"个人信息";
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    //去掉多余的cell之间的分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        //第一个cell 用来显示头像 需要单独添加一个UIImageView 不单独封装
        CGFloat iconX = cell.bounds.size.width - 20;
        CGFloat iconY = 5;
        CGFloat iconL = 50;
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
    //第一个显示头像的cell行高设置为60
    //其余cell设置为50
    CGFloat rowHeight = 50;
    if (indexPath.section == 0) {
        rowHeight = 60;
    }
    return rowHeight;
}
@end
