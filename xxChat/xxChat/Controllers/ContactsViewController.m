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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置监听中心，添加观察者
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(acceptFriendInvitation:) name:@"AcceptInvitation" object:nil];
    [JMessage addDelegate:self withConversation:nil];
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
        _contactsTableView = [[UITableView alloc] initWithFrame:self.view.frame];
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
        return 1;
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
    }
    //第一模块的第一个cell
    if(indexPath.section==0&&indexPath.row==0){
        cell.icon.image = [UIImage imageNamed:@"新的朋友"];
        cell.name.text = @"新的朋友";
        //如果有新的好友请求，就加个红点
        if (_isReceiveInvitation) {
            cell.redPoint.hidden = NO;
        }else{
            cell.redPoint.hidden = YES;
        }
        cell.icon.backgroundColor = [UIColor whiteColor];
    }else{
        JMSGUser *user = self.friendsListArray[indexPath.row];
        
        //头像还没设,先设一个名字
        cell.name.text = user.nickname;
        
    }
    return cell;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

//cell被点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //新的朋友 这个cell被点击时
    if(indexPath.section==0){
        //将小红点去掉
        self.isReceiveInvitation = NO;
        [self.contactsTableView reloadData];
        //打开新朋友列表
        FriendInvitationViewController *friendInvitationVC = [[FriendInvitationViewController alloc]init];
        //传递好友申请者数组
        friendInvitationVC.friendInvitationArray = self.friendInvitationArray;
        //传递申请理由数组
        friendInvitationVC.invitedReasonArray = self.invitedReasonArray;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendInvitationVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }
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
    self.hidesBottomBarWhenPushed = YES;//隐藏tabar
    AddViewController *addViewController = [[AddViewController alloc]init];
    [self.navigationController pushViewController:addViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;//back回来又不隐藏了
}
#pragma mark - 好友事件代理
- (void)onReceiveFriendNotificationEvent:(JMSGFriendNotificationEvent *)event{
    //如果事件类型为收到好友请求
    if (event.eventType==kJMSGEventNotificationReceiveFriendInvitation) {
        self.isReceiveInvitation = YES;
        [self.contactsTableView reloadData];
        //获取事件发送者
        bool isHaveSame = NO;//判断数组内是否有相同的请求
        for (JMSGUser* user in self.friendInvitationArray) {
            if (user.username == [event getFromUsername]) {
                isHaveSame = YES;
                break;
            }
        }
            
            if (!isHaveSame||self.friendInvitationArray.count==0) {
                [self.friendInvitationArray addObject:[event getFromUser]];
            }
        
        //获取reason
        [self.invitedReasonArray addObject:[event getReason]];
        NSLog(@"发生了一次收到好友请求事件,事件id为 %@",event.eventID);
        
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

@end
