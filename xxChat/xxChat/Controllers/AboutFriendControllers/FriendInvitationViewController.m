//
//  FriendInvitationViewController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/3.
//

#import "FriendInvitationViewController.h"
#import "xxChatDelegate.h"
#import "FriendInvitationCell.h"
#import "AddViewController.h"

@interface FriendInvitationViewController ()<UITableViewDelegate,UITableViewDataSource,xxChatDelegate,JMessageDelegate>

@end

@implementation FriendInvitationViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        //添加代理
        [JMessage addDelegate:self withConversation:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllViews];
}
- (NSMutableArray*)invitedReasonArray{
    if (_invitedReasonArray==nil) {
        _invitedReasonArray = [[NSMutableArray alloc]init];
    }
    return _invitedReasonArray;
}
- (NSMutableArray*)friendInvitationArray{
    if (_friendInvitationArray==nil) {
        _friendInvitationArray = [[NSMutableArray alloc]init];
    }
    return _friendInvitationArray;
}
- (UITableView *)friendInvtationTableView{
    if (_friendInvtationTableView == nil) {
        _friendInvtationTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _friendInvtationTableView.delegate = self;
        _friendInvtationTableView.dataSource = self;
        _friendInvtationTableView.tableFooterView = [[UIView alloc]init];//去掉多余的线
    }
    return _friendInvtationTableView;
}

- (void)setAllViews{
    self.navigationItem.title = @"新的朋友";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.friendInvtationTableView];
    //右上角的添加button
    UIBarButtonItem *addBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openAddController)];
    addBtnItem.tintColor = MainColor;
    
    NSArray *btnArray = [NSArray arrayWithObjects:addBtnItem, nil];
    [self.navigationItem setRightBarButtonItems:btnArray];
    
}





#pragma mark -tableView的 dataSource 和 delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.friendInvitationArray.count == 0) {
        return 1;
    }
    return self.friendInvitationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.friendInvitationArray.count == 0) {
        UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"暂无任何申请";
        cell.textLabel.textColor = [UIColor grayColor];
        return cell;
    }else{
        //复用ID为 Invitation
        NSString *ID = @"Invitation";
        FriendInvitationCell *cell = [self.friendInvtationTableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[FriendInvitationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        //选中不改变状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置代理
        cell.delegate = self;
        //传入indexPath
        cell.indexPath = indexPath;
        
        //信息设置
        JMSGUser* user = self.friendInvitationArray[indexPath.row];
        
        //头像
        if (user.avatar != nil) {
            
            [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
                if (!error) {
                    
                    cell.icon.image = [UIImage imageWithData:data];

                } else {
                    
                    NSLog(@"好友申请的cell获取头像出现错误：%@",error);
                    
                }
            }];
            
        } else {
            
            cell.icon.image = nil;
            
        }
        //昵称
        cell.name.text = user.nickname;
        
        //id
        cell.xxChatID.text = user.username;
        
        //留言
        NSString* reason = [NSString stringWithFormat:@"对方留言：%@",self.invitedReasonArray[indexPath.row]];
        cell.reason.text = reason;
        
        
        return cell;
    }
    
    
        
   
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark - xxChatDelegate
//接受邀请的行为
- (void)acceptInvitation:(NSIndexPath*)indexPath{
    //通过indexPath找到对应的cell
    JMSGUser* user = self.friendInvitationArray[indexPath.row];
    NSString* userName = user.username;
    [JMSGFriendManager acceptInvitationWithUsername:userName appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            [self.friendInvitationArray removeObjectAtIndex:indexPath.row];
            [self.invitedReasonArray removeObjectAtIndex:indexPath.row];
            [self.friendInvtationTableView reloadData];
            //发送通知，让好友列表更新
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AcceptInvitation" object:self];
        }else{
            NSLog(@"接受好友邀请出错：%@",error);
        }
        //如果是最后一个邀请，就pop掉
        if (self.friendInvitationArray.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    
    NSLog(@"接受好友邀请");

}

//拒绝邀请的行为
- (void)rejectInvitation:(NSIndexPath*)indexPath{
    //通过indexPath找到对应的cell
    JMSGUser* user = self.friendInvitationArray[indexPath.row];
    NSString* userName = user.username;
    [JMSGFriendManager rejectInvitationWithUsername:userName appKey:JMESSAGE_APPKEY reason:nil completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            [self.friendInvitationArray removeObjectAtIndex:indexPath.row];
            [self.invitedReasonArray removeObjectAtIndex:indexPath.row];
            [self.friendInvtationTableView reloadData];
        }else{
            NSLog(@"拒绝好友邀请出错：%@",error);
        }
        //如果是最后一个邀请，就pop掉
        if (self.friendInvitationArray.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    NSLog(@"拒绝好友邀请");

    
}
#pragma mark - 好友事件代理
- (void)onReceiveFriendNotificationEvent:(JMSGFriendNotificationEvent *)event{
    //如果事件类型为收到好友请求
    if (event.eventType==kJMSGEventNotificationReceiveFriendInvitation) {
        //获取事件发送者
        bool isHaveSame = NO;//判断数组内是否有相同的请求
        for (JMSGUser* user in self.friendInvitationArray) {
            //getFromUsername的返回值居然是nickname   我真服了
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
        [self.friendInvtationTableView reloadData];
    }
    
}

//打开添加页面
- (void)openAddController {
    self.hidesBottomBarWhenPushed = YES;//隐藏tabar
    AddViewController *addViewController = [[AddViewController alloc]init];
    [self.navigationController pushViewController:addViewController animated:YES];
}

@end
