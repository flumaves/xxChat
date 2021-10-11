//
//  GroupViewController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/13.
//

#import "GroupViewController.h"

@interface GroupViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置监听中心，添加观察者
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didCreateGroup:) name:@"CreatedGroup" object:nil];

    [self setAllViews];
    [self getGroupsList];

    
}
#pragma mark - 懒加载
- (NSMutableArray*)otherGroupArray {
    if (_otherGroupArray == nil) {
        _otherGroupArray = [[NSMutableArray alloc]init];
    }
    return _otherGroupArray;
}
- (NSMutableArray*)myGroupArray {
    if (_myGroupArray == nil) {
        _myGroupArray = [[NSMutableArray alloc]init];
    }
    return _myGroupArray;
}
- (NSMutableArray*)conversationsArray {
    if (_conversationsArray == nil) {
        _conversationsArray = [[NSMutableArray alloc]init];
    }
    return _conversationsArray;
}
- (NSMutableArray*)sectionTitleArray {
    if (_sectionTitleArray == nil) {
        _sectionTitleArray = [[NSMutableArray alloc]init];
    }
    return _sectionTitleArray;
}
- (NSMutableArray*)friendsListArray{
    if (_friendsListArray == nil) {
        _friendsListArray = [[NSMutableArray alloc]init];
    }
    return _friendsListArray;
}
- (NSMutableArray*)groupsListArray {
    if (_groupsListArray == nil) {
        _groupsListArray = [[NSMutableArray alloc]init];
    }
    return _groupsListArray;
}
- (UITableView*)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];//去掉下面多余的线

    }
    return _tableView;
}

//基本设置
- (void)setAllViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"群组列表";
    [self.view addSubview:self.tableView];
    
    //发起群聊按钮
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeSystem];

    selectedBtn.frame = CGRectMake(0, 0, 60, 30);

    [selectedBtn setTitle:@"发起群聊" forState:UIControlStateNormal];
    
    selectedBtn.titleLabel.font = [UIFont systemFontOfSize:16];

    [selectedBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectedBtn];

    self.navigationItem.rightBarButtonItem =selectItem;
}


#pragma mark -tableView的 dataSource 和 delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 && _myGroupArray.count != 0) {
        
        return _myGroupArray.count;
        
    } else if (section == 2 && _otherGroupArray.count != 0) {
        
        return _otherGroupArray.count;
    }
        
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //复用ID为 group
    NSString *ID = @"group";
    ContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //第一模块
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.icon.image = [UIImage imageNamed:@"通知"];
            cell.name.text = @"群通知";
            cell.icon.backgroundColor = [UIColor whiteColor];

            
            //如果有新的通知，就加个红点
            if (_isReceiveGroupEvent) {
                cell.redPoint.hidden = NO;
            }else{
                cell.redPoint.hidden = YES;
            }
            
            
        }
        
    } else if (indexPath.section == 1) {
        
        if (_myGroupArray.count == 0) {
            UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"暂无相关群组";
            cell.textLabel.textColor = [UIColor grayColor];
            return cell;
        }
        
        
        JMSGGroup* group = _myGroupArray[indexPath.row];
        
        //设名字
        cell.name.text = group.name;
        //头像
        if (![group.avatar isEqualToString:@""]) {
            
            [group thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
                if (!error) {
                    
                    cell.icon.image = [UIImage imageWithData:data];

                } else {
                    
                    NSLog(@"群组列表的cell获取头像出现错误：%@",error);
                    
                }
            }];
            
        } else {
            
            [cell.icon setImage:[UIImage imageNamed:@"头像占位图"]];
            
        }
        
    } else if (indexPath.section == 2) {
        
        if (_otherGroupArray.count == 0) {
            UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"暂无相关群组";
            cell.textLabel.textColor = [UIColor grayColor];
            return cell;
        }
        
        
        JMSGGroup* group = _otherGroupArray[indexPath.row];
        
        //设名字
        cell.name.text = group.name;
        //头像
        if (![group.avatar isEqualToString:@""]) {
            
            [group thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
                if (!error) {
                    
                    cell.icon.image = [UIImage imageWithData:data];

                } else {
                    
                    NSLog(@"群组列表的cell获取头像出现错误：%@",error);
                    
                }
            }];
            
        } else {
            
            [cell.icon setImage:[UIImage imageNamed:@"头像占位图"]];
            
        }
        
  
        
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
        return 30;
    }
    return 0;
}

//每个section的headerView样式
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0 ) {
        
        NSArray* array = [NSArray arrayWithObjects:@"      我的群组", @"      我加入的群组", nil];
        
        UILabel* headerView = [[UILabel alloc]init];
        headerView.backgroundColor =[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
        headerView.font = [UIFont systemFontOfSize:14];
        headerView.textColor = [UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:1];
        headerView.textAlignment = NSTextAlignmentLeft;
        headerView.text = array[section-1];
        
//        if (self.myGroupArray.count == 0) {
//            headerView.text = array[1];
//        } else if (self.otherGroupArray.count == 0) {
//            headerView.text = array[0];
//        }
        
        
        return headerView;
    }
    return nil;
    
}

//cell被点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        //群通知 这个cell被点击时
        if (indexPath.row == 0) {
            //将小红点去掉
            self.isReceiveGroupEvent = NO;
            [self.tableView reloadData];
            //打开通知列表
            GroupNotificationViewController* groupNotificationVC = [[GroupNotificationViewController alloc]init];
            //传递通知数组
//            groupNotificationVC.friendInvitationArray = self.friendInvitationArray;
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:groupNotificationVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }
        
    } else {//群组被点击直接进入会话
        
        NSArray* tempArray;
        JMSGGroup* group;
        
        if (indexPath.section == 1) {
            tempArray = self.myGroupArray;
            group = tempArray[indexPath.row];
        } else {
            tempArray = self.otherGroupArray;
            group = tempArray[indexPath.row];
        }
        
        NSString* gid = group.gid;
        
        [JMSGConversation createGroupConversationWithGroupId:gid completionHandler:^(id resultObject, NSError *error) {
            
            if (!error) {
                
                JMSGConversation* conversation = resultObject;
                MessageViewController* messageVC = [[MessageViewController alloc]init];
                messageVC.conversation = conversation;
                
                [self.navigationController pushViewController:messageVC animated:YES];
                self.hidesBottomBarWhenPushed = YES;
                
            } else {
                
                NSLog(@"点击群组列表打开群聊会话出错：%@",error);
                
            }
            
            
        }];
        

        
    }
}

// cell右滑解散，问就是左滑不行
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos){
    if (indexPath.section == 1) {
        //创建Action,然后在里面实现解散方法
        UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"解散" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            //获取相应信息，删除群组
            JMSGGroup *group = self.myGroupArray[indexPath.row];
            [JMSGGroup dissolveGroupWithGid:group.gid handler:^(id resultObject, NSError *error) {
                if (!error) {
                    [self.myGroupArray removeObject:group];
                    [self.tableView reloadData];
                    
                    NSString* gid = group.gid;
                    NSString* groupName = group.name;
                    
                    
                    
                    NSDictionary* dic = [NSDictionary dictionaryWithObjects:@[gid, groupName] forKeys:@[@"gid", @"groupName"]];
                    
                    NSNotification* notification = [[NSNotification alloc]initWithName:@"DeletedGroup" object:nil userInfo:dic];
                    [[NSNotificationCenter defaultCenter]postNotification:notification];
                    
                    
                } else {
                    
                    NSLog(@"解散群组出错:%@",error);
                    
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

//发起群聊按钮点击响应事件
- (void)selectedBtn:(UIButton *)button {
    SelectUserForGroupController* selectVC = [[SelectUserForGroupController alloc]init];
    //传好友列表
    selectVC.friendsListArray = self.friendsListArray;
    //传首字母数组
    selectVC.sectionTitleArray = self.sectionTitleArray;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectVC animated:YES];
   
}


#pragma mark - 获取群组列表
- (void)getGroupsList {
    
    [JMSGGroup myGroupArray:^(id resultObject, NSError *error) {
        if (!error) {
            NSArray* gidArray = resultObject;
            
            //获取当前账号信息
            JMSGUser* ownerUser = [JMSGUser myInfo];
            
            for (int i = 0; i < gidArray.count; i++) {
                NSString* gid = gidArray[i];
                
                [JMSGGroup groupInfoWithGroupId:gid completionHandler:^(id resultObject, NSError *error) {
                    
                    JMSGGroup* group = resultObject;
                    
                    if ([group.owner isEqualToString:ownerUser.username]) {
                        [self.myGroupArray addObject:group];
                    } else {
                        [self.otherGroupArray addObject:group];
                    }
                    [self.tableView reloadData];
                    
                }];
            }
            
  
            
        } else {
            
            NSLog(@"获取群组列表出错：%@",error);
            
        }
        
    }];
    
}



#pragma mark - 观察者响应方法
- (void)didCreateGroup:(NSNotification*)notification {
    [self.myGroupArray removeAllObjects];
    [self.otherGroupArray removeAllObjects];
    
    [self getGroupsList];
    
}


@end
