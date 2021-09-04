//
//  FriendInvitationViewController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/3.
//

#import "FriendInvitationViewController.h"
#import "xxChatDelegate.h"
#import "FriendInvitationCell.h"

@interface FriendInvitationViewController ()<UITableViewDelegate,UITableViewDataSource,xxChatDelegate>

@end

@implementation FriendInvitationViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.friendInvtationTableView];
}





#pragma mark -tableView的 dataSource 和 delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendInvitationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    cell.name.text = user.nickname;
    cell.xxChatID.text = user.username;
    NSString* reason = [NSString stringWithFormat:@"对方留言：%@",self.invitedReasonArray[indexPath.row]];
    cell.reason.text = reason;
    
        
    return cell;
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
            [self.friendInvtationTableView reloadData];
            //发送通知，让好友列表更新
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AcceptInvitation" object:self];
        }else{
            NSLog(@"接受好友邀请出错：%@",error);
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
            [self.friendInvtationTableView reloadData];
        }else{
            NSLog(@"拒绝好友邀请出错：%@",error);
        }
    }];
    NSLog(@"拒绝好友邀请");

    
}



@end
