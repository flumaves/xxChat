//
//  ContactViewController.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/9.
//

#import "ContactsViewController.h"

@interface ContactsViewController () <UITableViewDelegate,UITableViewDataSource,JMessageDelegate>

//加载联系人列表的tableView
@property (nonatomic, strong)UITableView *contactsTableView;


@end

@implementation ContactsViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        //设置监听中心，添加观察者
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(acceptFriendInvitation:) name:@"AcceptInvitation" object:nil];
        //添加代理，监听事件
        [JMessage addDelegate:self withConversation:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self getFriendsList];
    [self.view addSubview:self.contactsTableView];
    [self layoutView];
}
#pragma mark - 懒加载
- (NSMutableArray*)invitedReasonArray{
    if (_invitedReasonArray==nil) {
        _invitedReasonArray = [[NSMutableArray alloc]init];
    }
    return _invitedReasonArray;
}
- (NSMutableArray*)friendsListArray{
    if (_friendsListArray==nil) {
        _friendsListArray = [[NSMutableArray alloc]init];
    }
    return _friendsListArray;
}
- (NSMutableArray*)friendInvitationArray{
    if (_friendInvitationArray==nil) {
        _friendInvitationArray = [[NSMutableArray alloc]init];
    }
    return _friendInvitationArray;
}
- (UITableView *)contactsTableView {
    if (_contactsTableView == nil) {
        _contactsTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _contactsTableView.delegate = self;
        _contactsTableView.dataSource = self;
        _contactsTableView.tableFooterView = [[UIView alloc]init];//去掉下面多余的线
    }
    return _contactsTableView;
}

#pragma mark -tableView的 dataSource 和 delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0){
        return 2;
    }else{
        
        return self.friendsListArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //复用ID为 chat
    NSString *ID = @"contact";
    ContactCell *cell = [self.contactsTableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //第一模块
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            cell.icon.image = [UIImage imageNamed:@"新的朋友"];
            cell.name.text = @"新的朋友";
            //如果有新的好友请求，就加个红点
            if (_isReceiveInvitation) {
                cell.redPoint.hidden = NO;
            }else{
                cell.redPoint.hidden = YES;
            }
            cell.icon.backgroundColor = [UIColor whiteColor];
        } else if (indexPath.row == 1){
            cell.icon.image = [UIImage imageNamed:@"群组"];
            cell.name.text = @"群组";
            
            cell.icon.backgroundColor = [UIColor whiteColor];
        }
        
    }else{
        JMSGUser *user = self.friendsListArray[indexPath.row];
        
        //头像还没设,先设一个名字
        cell.name.text = user.nickname;
        
    }
    return cell;
}

//每个cell的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

//每个section的headerView高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        return 20;
    }
    return 0;
}

//每个section的headerView样式
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0 ) {
        
        UILabel* headerView = [[UILabel alloc]init];
        headerView.backgroundColor =[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
        headerView.font = [UIFont systemFontOfSize:13];
        headerView.textAlignment = NSTextAlignmentLeft;
        headerView.text = @"       A";
        
        
        return headerView;
    }
    return nil;
    
}

//cell被点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        //新的朋友 这个cell被点击时
        if (indexPath.row == 0) {
            //将小红点去掉
            self.isReceiveInvitation = NO;
            [self.contactsTableView reloadData];
            //打开新朋友列表
            FriendInvitationViewController* friendInvitationVC = [[FriendInvitationViewController alloc]init];
            //传递好友申请者数组
            friendInvitationVC.friendInvitationArray = self.friendInvitationArray;
            //传递申请理由数组
            friendInvitationVC.invitedReasonArray = self.invitedReasonArray;
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:friendInvitationVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }else if (indexPath.row == 1) {
            //打开群组列表
            [self.navigationController pushViewController:[[GroupViewController alloc]init] animated:YES];
            
        }
        
    } else {//好友被点击出现好友信息
        
        FriendInfomationViewController* friendInfoVC = [[FriendInfomationViewController alloc]init];
        //传user信息。
        friendInfoVC.User = _friendsListArray[indexPath.row];
        
        friendInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendInfoVC animated:YES];
        friendInfoVC.hidesBottomBarWhenPushed = NO;
        
        
    }
}
// cell右滑删除，问就是左滑不行
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos){
    if (indexPath.section != 0) {
        //创建Action,然后在里面实现删除方法
        UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            //获取相应信息，删除好友
            JMSGUser *user = self.friendsListArray[indexPath.row];
            [JMSGFriendManager removeFriendWithUsername:user.username appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
                        if (!error) {
                            [self.friendsListArray removeObject:user];
                            [self.contactsTableView reloadData];
                            NSLog(@"删除好友:%@",user.nickname);
                        }else{
                            NSLog(@"删除好友出现错误：%@",error);
                        }
            }];
            completionHandler(YES);
        }];
        deleteRowAction.backgroundColor = [UIColor redColor];
        //创建configuration
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
        //将右滑过度执行Action关掉
        config.performsFirstActionWithFullSwipe = NO;

        return config;
    }
    return nil;
}

- (void)layoutView {
    //右上角的添加button
    UIBarButtonItem *addBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openAddController)];
    
    addBtnItem.tintColor = MainColor;
    
    UIBarButtonItem *searchBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(openSearchController)];
    
    searchBtnItem.tintColor = MainColor;
    NSArray *btnArray = [NSArray arrayWithObjects:addBtnItem,searchBtnItem, nil];
    
    [self.navigationItem setRightBarButtonItems:btnArray];
    
}

//打开搜索页面
- (void)openSearchController {
}


//打开添加页面
- (void)openAddController {
    self.hidesBottomBarWhenPushed = YES;//隐藏tabar
    AddViewController *addViewController = [[AddViewController alloc]init];
    [self.navigationController pushViewController:addViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;//back回来又不隐藏了
}
#pragma mark - 好友事件代理
- (void)onReceiveFriendNotificationEvent:(JMSGFriendNotificationEvent *)event{
    //如果事件类型为收到好友请求
    if (event.eventType==kJMSGEventNotificationReceiveFriendInvitation) {
        //当没有push新的controller的时候，才显示红点。
        if (self.navigationController.viewControllers.count == 1) {
            self.isReceiveInvitation = YES;//收到了申请
            //让小红点刷出来
            [self.contactsTableView reloadData];
        }       
        //获取事件发送者
        bool isHaveSame = NO;//判断数组内是否有相同的请求
        for (JMSGUser* user in self.friendInvitationArray) {
        
            if ([user.nickname isEqualToString:[event getFromUsername]]) {
                isHaveSame = YES;
                break;
            }
        }
            
            if (!isHaveSame||self.friendInvitationArray.count==0) {
                [self.friendInvitationArray addObject:[event getFromUser]];
                //获取reason
                [self.invitedReasonArray addObject:[event getReason]];
            }
        
        NSLog(@"发生了一次收到好友请求事件,事件id为 %@",event.eventID);
    }
    
    //如果事件为对方接受了你的好友申请
    if (event.eventType==kJMSGEventNotificationAcceptedFriendInvitation) {
        NSString* nickName = [event getFromUser].nickname;
        NSLog(@"%@ 已接收好友申请",nickName);
        [self getFriendsList];
    }
    
    //如果对方拒绝了你的好友申请
    if (event.eventType==kJMSGEventNotificationDeclinedFriendInvitation) {
        NSString* nickName = [event getFromUser].nickname;
        [self showAlertViewWithMessage:[NSString stringWithFormat:@"%@ 已拒绝您的好友申请",nickName]];
    }
    
    //如果对方删除了你
    if (event.eventType==kJMSGEventNotificationDeletedFriend) {
        NSString* nickName = [event getFromUser].nickname;
        NSLog(@"%@ 已将你删除",nickName);
        [self getFriendsList];
    }
    
}

- (void)getFriendsList{
    [JMSGFriendManager getFriendList:^(id resultObject, NSError *error) {
        if (!error) {
            self.friendsListArray = [NSMutableArray arrayWithArray:resultObject];
            [self.contactsTableView reloadData];
        }else{
            NSLog(@"获取朋友列表出现错误：%@",error);
        }
    }];
}

- (void)acceptFriendInvitation:(NSNotification*)notification{
    [self getFriendsList];
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

@end
