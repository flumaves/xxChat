//
//  MeViewController.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/9.
//

#import "MeViewController.h"

#import "InformationCell.h"
#import "SelfInformationTableViewController.h"

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate>

//加载个人列表的tableView
@property (nonatomic, strong)UITableView *meTableView;

//登陆的人的用户模型
@property (nonatomic, strong)JMSGUser *user;

@end

@implementation MeViewController

/*
 这个页面需要隐藏掉navagationBar
 所以在将要显示view的时候设置hidden = YES
 在页面离开时设置hidden = NO
 */
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.meTableView];
}

- (UITableView *)meTableView {
    if (_meTableView == nil) {
        _meTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _meTableView.delegate = self;
        _meTableView.dataSource = self;
        
        _meTableView.tableFooterView = [[UIView alloc] init];
    }
    return _meTableView;
}

#pragma mark - 懒加载
- (JMSGUser *)user {
    if (_user == nil) {
        JMSGUser *userInfo = [JMSGUser myInfo];
        _user = userInfo;
    }
    return _user;
}

#pragma mark -tableView的 dataSource 和 delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //静态的tableView
    if (indexPath.section == 0) {
        ///个人信息
        InformationCell *cell = [[InformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        //右侧小箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //选中不改变颜色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {
        ///设定
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        //右侧小箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //选中不改变状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"设置"];
        cell.textLabel.text = @"设定(未开发)";
        return cell;
    } else if (indexPath.section == 2) {
        ///退出登陆
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        //选中不改变状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        /*
         这个cell中只需要自己添加一个居中的UILabel
          就不单独封装成一个cell了
         */
        CGFloat lblW = 200;
        CGFloat lblH = 30;
        CGFloat lblX = (self.view.bounds.size.width - lblW) / 2;
        CGFloat lblY = 10;  //cell的高度50 - label的高度30 再除2
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblW, lblH)];
        lbl.text = @"退出登录";
        lbl.textColor = [UIColor redColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:lbl];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //除了最上面显示信息的cell高度设置为140 其余高度都为50
    CGFloat rowHeight = 0;
    if (indexPath.section == 0) {
        rowHeight = 140;
    } else {
        rowHeight = 50;
    }
    return rowHeight;
}

//cell被选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //点击 个人信息的cell
        SelfInformationTableViewController *controller = [[SelfInformationTableViewController alloc] init];
        controller.user = self.user;
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section == 1) {
        //点击 设定
    } else if (indexPath.section == 2) {
        //点击 退出登录
        [JMSGUser logout:^(id resultObject, NSError *error) {
                    NSLog(@"-%@-",error);
        }];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FinishLogout" object:self];
    }
}

@end
