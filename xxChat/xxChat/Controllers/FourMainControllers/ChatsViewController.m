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

@end

@implementation ChatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加代理
    [JMessage addDelegate:self withConversation:nil];

    [self layoutView];
    [self loadData];
    
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

//创建单聊对话
- (void)addChat {
    [JMSGConversation createSingleConversationWithUsername:@"333333" completionHandler:^(id resultObject, NSError *error) {
        JMSGConversation *conversations = (JMSGConversation *)resultObject;
        if (error) {
            NSLog(@"%@",error);
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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
    controller.title = cell.name.text;
    controller.conversation = cell.conversation;
    [self.navigationController pushViewController:controller animated:YES];
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}

/// 过一段时间，取消cell的选中状态
- (void)deselect {
    [self.conversationsTableView deselectRowAtIndexPath:[self.conversationsTableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - 加载界面
- (void)layoutView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.conversationsTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.conversationsTableView];
    //右上角的添加button
    UIBarButtonItem *addBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openAddController)];
    addBtnItem.tintColor = MainColor;
    
    UIBarButtonItem *searchBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(openSearchController)];
    searchBtnItem.tintColor = MainColor;
    NSArray *btnArray = [NSArray arrayWithObjects:addBtnItem,searchBtnItem, nil];
    [self.navigationItem setRightBarButtonItems:btnArray];
    //左上角的button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"addChat" style:UIBarButtonItemStyleDone target:self action:@selector(addChat)];
    
    
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






@end
