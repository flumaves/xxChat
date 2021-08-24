//
//  MessageViewController.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import "MessageViewController.h"
#import "Message.h"
#import "MessageFrame.h"
#import "MessageCell.h"
#import "InputView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define INTERVAL 60*3 //3分钟的时间间隔

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JMSGMessageDelegate>

//显示消息的tableView
@property (nonatomic, strong) UITableView *messageTableView;

//底部输入文字的视图
@property (nonatomic, strong) InputView *inputView;

//消息数组
@property (nonatomic, strong) NSMutableArray *messagesArray;

//登陆的人
@property (nonatomic, strong) JMSGUser *user;

//聊天的对象
@property (nonatomic, strong) JMSGUser *anotherUser;

//聊天的群组

//判断是否正在输入文字
@property (nonatomic, assign, getter=isTyping ) BOOL typing;

@end

@implementation MessageViewController

/*
 页面打开时隐藏tabBar
 离开页面显示tabBar
 */
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加代理
    [JMessage addDelegate:self withConversation:_conversation];
    
    //此时键盘为隐藏
    self.typing = NO;
    
    //navigationBar添加一个leftButton 只要单独一个箭头
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //设置为黑色
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    [self creatTableView];
}

#pragma mark - 懒加载
//“我”用户
- (JMSGUser *)user {
    if (_user == nil) {
        JMSGUser *user = [JMSGUser myInfo];
        _user = user;
    }
    return _user;
}

//另一个用户
- (JMSGUser *)anotherUser {
    if (_anotherUser == nil) {
        _anotherUser = _conversation.target;
    }
    return _anotherUser;
}

- (NSMutableArray *)messagesArray {
    if (_messagesArray == nil) {
        _messagesArray = [[NSMutableArray alloc] init];
        
        //获取最新的50条记录
        NSNumber *limit = [NSNumber numberWithInt:50];
        NSArray *array = [_conversation messageArrayFromNewestWithOffset:nil limit:limit];
        Message *lastMessage = [[Message alloc] init];
        
        for (JMSGMessage *j_message in array) {
            //从JMSGMessage 转成 自己的message并封装messageFrame
            Message *message = [[Message alloc] init];
            message.userName = self.user.username;
            [message setMessage:j_message];
            //比较时间 设置模型的timeHidden属性
            if (lastMessage.time == nil) {  //这是第一条信息
                message.timeHidden = NO;
            } else {
                //消息数据是从最新的往前遍历 所以应该以上一条模型的时间戳为当前时间
                message.timeHidden = [self setTimeHiddenBetweenLastTime:j_message andCurrentTime:lastMessage.message];
            }
            //封装messageFrame
            MessageFrame *messageFrame = [[MessageFrame alloc] init];
            [messageFrame setMessage:message];
            [_messagesArray insertObject:messageFrame atIndex:0];
            //重新记录lastMessage
            lastMessage = message;
        }
    }
    return _messagesArray;
}

//创建界面
- (void)creatTableView {
    //tableView
    self.messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 90)];
    self.messageTableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.messageTableView.dataSource = self;
    self.messageTableView.delegate = self;
    self.messageTableView.separatorStyle = NO;
    [self.view addSubview:self.messageTableView];
    
    //文本输入框
    self.inputView = [[InputView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.messageTableView.frame), ScreenWidth, 90)];
    [self.view addSubview:_inputView];
    
    self.inputView.inputTextField.delegate = self;
    
    //注册键盘变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 收到消息的回调
- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error {
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    //创建模型储存
    Message *newMessage = [[Message alloc] init];
    newMessage.userName = _user.username;
    [newMessage setMessage:message];
    //获取最新一次消息的模型
    MessageFrame *lastMessageFrame = self.messagesArray.lastObject;
    JMSGMessage *lastMessage = lastMessageFrame.message.message;
    newMessage.timeHidden = [self setTimeHiddenBetweenLastTime:lastMessage andCurrentTime:message];
    
    MessageFrame *messageFrame = [[MessageFrame alloc] init];
    messageFrame.message = newMessage;
    
    [self.messagesArray addObject:messageFrame];
    [self.messageTableView reloadData];
    [self tableViewscrollToBotton];
}


#pragma mark - 发送消息的回调
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error {
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    //消息发送成功
    //创建模型储存
    Message *newMessage = [[Message alloc] init];
    newMessage.userName = _user.username;
    [newMessage setMessage:message];
    //获取最新一次消息的模型
    MessageFrame *lastMessageFrame = self.messagesArray.lastObject;
    JMSGMessage *lastMessage = lastMessageFrame.message.message;
    newMessage.timeHidden = [self setTimeHiddenBetweenLastTime:lastMessage andCurrentTime:message];
    
    MessageFrame *messageFrame = [[MessageFrame alloc] init];
    messageFrame.message = newMessage;
    
    [self.messagesArray addObject:messageFrame];
    [self.messageTableView reloadData];
    [self tableViewscrollToBotton];
}

#pragma mark - 比较时间的间隔
- (BOOL)setTimeHiddenBetweenLastTime:(JMSGMessage *)lastMessage andCurrentTime:(JMSGMessage *)currentMessage {
    NSTimeInterval lastTime = [lastMessage.timestamp doubleValue] / 1000;
    NSTimeInterval currentTime = [currentMessage.timestamp doubleValue] / 1000;
    NSTimeInterval betweenTime = currentTime - lastTime;
    if (betweenTime > INTERVAL) {
        //大于五分钟 不隐藏timeString
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - keyBoard通知的具体操作
//改变keyboard 判断调用 显示 还是 隐藏 keyboard
- (void)changeKeyBoard:(NSNotification *)notification {
    if ([self isTyping]) {
        //正在打字 接下来改变keyboard就要隐藏
        [self hideKeyBoard:notification];
        //重新记录
        self.typing = NO;
    } else {
        [self showKeyBoard:notification];
        self.typing = YES;
    }
}

//显示keyboard
- (void)showKeyBoard:(NSNotification *)notification {
    //计算键盘移动的距离
    NSDictionary *dict = notification.userInfo;
    CGRect keyBoardFrame = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardH = keyBoardFrame.size.height;
    CGFloat translateY = self.inputView.bounds.origin.y - keyBoardH + 30;
    //让这个inputView向上腾出键盘的高度 (为了防止空出太多白色 ，再添加20 向下移动一点）
    
    CGFloat time = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:time animations:^{
        self.inputView.transform = CGAffineTransformMakeTranslation(0, translateY);
        
        //重新设置tableView的frame
        CGRect frame = self.messageTableView.frame;
        frame.size.height = frame.size.height - keyBoardH + 30;
        self.messageTableView.frame = frame;
    }];
    
    if (self.messagesArray.count > 0) {  //有消息记录再让tableview滚动，否则会error
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0];
        [self.messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

//隐藏keyboard
- (void)hideKeyBoard:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    //获取键盘高度
    CGRect keyBoardFrame = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardH = keyBoardFrame.size.height;
    CGFloat time = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:time animations:^{
        //MakeTranslation是相对最初的位置 ，所以相对最初的位置为0 即可返回原位
        self.inputView.transform = CGAffineTransformMakeTranslation(0, 0);
        
        //重新设置tableView的frame
        CGRect frame = self.messageTableView.frame;
        frame.size.height = frame.size.height + keyBoardH - 30;
        self.messageTableView.frame = frame;
    }];
}

///点击发送后执行的操作
- (void)addMessage:(NSString *)text type:(MessageType)type {
    //创建消息
    JMSGTextContent *content = [[JMSGTextContent alloc] initWithText:text];
    JMSGMessage *message = [JMSGMessage createSingleMessageWithContent:content username:self.anotherUser.username];
    
    //发送消息
    [JMSGMessage sendMessage:message];
}

///拖动屏幕的操作
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //取消编辑状态 会改变keyboard的状态 从而发送通知
    [self.view endEditing:YES];
    self.typing = NO;
}

#pragma mark - tableView的 dataSource 和 delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.messageFrame = self.messagesArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageFrame *frame = [self.messagesArray objectAtIndex:indexPath.row];
    return frame.rowHeight;
}

#pragma mark - 滚动到最后一行
- (void)tableViewscrollToBotton {
    if (_messagesArray.count != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_messagesArray.count - 1 inSection:0];
        [self.messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark - textfield的delegate
//当按下回车键的时候
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //模型数据的处理
    [self addMessage:textField.text type:MessageType_ME];
    //清空textField
    self.inputView.inputTextField.text = @"";
    return YES;
}

#pragma mark - leftBarButtonItem的方法
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
