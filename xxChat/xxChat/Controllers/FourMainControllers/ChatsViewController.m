//
//  MessageViewController.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/7.
//

#import "ChatsViewController.h"
#import "ChatCell.h"
#import "MessageViewController.h"
#import "UITabBar+RedPoint.h"

@interface ChatsViewController () <UITableViewDataSource, UITableViewDelegate,JMessageDelegate,JMSGConversationDelegate>

//加载会话列表的tableView
@property (nonatomic, strong)UITableView *conversationsTableView;

//储存会话列表 （array中是 JMSGConversation）
@property (nonatomic, strong)NSMutableArray *conversationsArray;

//总的未读消息数
@property (nonatomic, assign)int allUnreadCount;

//群组lieb
@property (nonatomic,strong)NSMutableArray *groupArray;

@end

@implementation ChatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加代理
    [JMessage addDelegate:self withConversation:nil];
    
    //设置监听中心，添加观察者
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(addChatWithUsername:) name:@"AddChat" object:nil];
    [center addObserver:self selector:@selector(deleteConversation:) name:@"DeletedGroup" object:nil];

    [self layoutView];
    [self getGroupsList];
    [self loadData];
    
}

#pragma mark - 懒加载
- (NSMutableArray*)groupArray {
    if (!_groupArray) {
        _groupArray = [[NSMutableArray alloc]init];
    }
    return _groupArray;
}



#pragma mark - 加载数据
- (void)loadData {
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            //正常返回时 resultObject里面为NSArray 成员类型为 JMSGConversation
            for (JMSGConversation *conversation in resultObject) {
                self.allUnreadCount += [conversation.unreadCount intValue];
                [self.conversationsArray addObject:conversation];
            }
            [self.conversationsTableView reloadData];
            [self.tabBarController.tabBar showRedPointAtIndex:0 withUnreadCount:self.allUnreadCount];
        }
    }];
}




- (UITableView *)conversationsTableView {
    if (_conversationsTableView == nil) {
        _conversationsTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _conversationsTableView.delegate = self;
        _conversationsTableView.dataSource = self;
    }
    return _conversationsTableView;
}

#pragma mark - 懒加载
- (NSArray *)conversationsArray {
    if (_conversationsArray == nil) {
        NSMutableArray *array = [NSMutableArray array];
        _conversationsArray = array;
    }
    return _conversationsArray;
}


#pragma mark - JMSGMessageDelegate
- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error {
    _allUnreadCount = 0;
    [self.conversationsArray removeAllObjects];
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        for (JMSGConversation *conversation in resultObject) {
            self.allUnreadCount += [conversation.unreadCount intValue];
            [self.conversationsArray addObject:conversation];
        }
        [self.conversationsTableView reloadData];
        [self.tabBarController.tabBar showRedPointAtIndex:0 withUnreadCount:self.allUnreadCount];
    }];
}

#pragma mark -tableView的 dataSource 和 delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversationsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //复用ID为 chat
    NSString *ID = @"chat";
    ChatCell *cell = [self.conversationsTableView dequeueReusableCellWithIdentifier:ID];

    if (cell == nil) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //传入数据 JMSGConversation
    JMSGConversation *conversation = _conversationsArray[indexPath.row];
    [cell setConversation:conversation];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [self.conversationsTableView cellForRowAtIndexPath:indexPath];
    if (!cell.rowHeight) {
        return 80;
    } else {
        return cell.rowHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //总的未读消息数
    _allUnreadCount -= [cell.conversation.unreadCount intValue];
    [self.tabBarController.tabBar showRedPointAtIndex:0 withUnreadCount:_allUnreadCount];
    
    //清除该会话的未读消息数
    [cell.conversation clearUnreadCount];
    cell.redPoint.unreadCount = [cell.conversation.unreadCount intValue];
    
    //创建会话的controller
    MessageViewController *controller = [[MessageViewController alloc] init];
    
    //判断是群聊还是单聊
    if (cell.conversation.conversationType == kJMSGConversationTypeGroup) {
        //获取对应群组人数
        for (JMSGGroup* group in self.groupArray) {
            if ([group.name isEqualToString:cell.name.text]) {
                
                [group memberArrayWithCompletionHandler:^(id resultObject, NSError *error) {
                    
                    NSArray* array = resultObject;
                    
                    NSString* title = [NSString stringWithFormat:@"%@(%lu)",group.name,array.count];
                    
                    controller.title = title;
                    
                    controller.conversation = cell.conversation;
                    
                    [self.navigationController pushViewController:controller animated:YES];

                    
                }];
                break;
            }
        }
        
    } else {
        
        controller.title = cell.name.text;
        controller.conversation = cell.conversation;
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}

#pragma mark -
- (void)layoutView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.conversationsTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.conversationsTableView];
    
    //右上角的添加button
    UIBarButtonItem *addBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openAddController)];
    addBtnItem.tintColor = MainColor;
    //右上角的搜索按钮
    UIBarButtonItem *searchBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(openSearchController)];
    searchBtnItem.tintColor = MainColor;
    //加入按钮数组
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




- (void)getGroupsList {
    
    [JMSGGroup myGroupArray:^(id resultObject, NSError *error) {
        if (!error) {
            
            NSArray* gidArray = resultObject;
            
            for (int i = 0; i < gidArray.count; i++) {
                NSString* gid = gidArray[i];
                
                [JMSGGroup groupInfoWithGroupId:gid completionHandler:^(id resultObject, NSError *error) {
                    
                    JMSGGroup* group = resultObject;
                    
                    [self.groupArray addObject:group];
                    
                }];
            }
  
            
        } else {
            
            NSLog(@"获取群组列表出错：%@",error);
            
        }
        
    }];
    
}

































































#pragma mark - 观察者响应方法
//创建单聊对话
- (void)addChatWithUsername:(NSNotification*)notification {
    
    //获得通知传过来的消息
    NSString* username = notification.userInfo[@"username"];
    
    //创建新的单聊
    [JMSGConversation createSingleConversationWithUsername:username completionHandler:^(id resultObject, NSError *error) {

        JMSGConversation *conversations = (JMSGConversation *)resultObject;
        
        if (error) {
            
            NSLog(@"创建单聊出现错误：%@",error);
            return;
            
        } else {
            
            //查看是否已经是存在的对话
            for (JMSGConversation *conversation in self.conversationsArray) {
                if (conversation.title == conversations.title) {
                    return;
                }
            }
            
            [self.conversationsArray addObject:conversations];
            [self.conversationsTableView reloadData];
            
        }
    }];
}

//删除群组后 删除对应的会话
- (void)deleteConversation:(NSNotification*)notification {
    
    NSString* gid = notification.userInfo[@"gid"];
    NSString* groupName = notification.userInfo[@"groupName"];
    
    [JMSGConversation deleteGroupConversationWithGroupId:gid];
    
    for (JMSGConversation* conversation in self.conversationsArray) {
        
        if (conversation.conversationType == kJMSGConversationTypeGroup && [conversation.title isEqualToString:groupName]) {
            
            [self.conversationsArray removeObject:conversation];
            [self.conversationsTableView reloadData];
            break;
        }
    }
    
    
    
    
}




@end
