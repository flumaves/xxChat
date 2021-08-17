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

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

//显示消息的tableView
@property (nonatomic, strong) UITableView *messageTableView;

//底部输入文字的视图
@property (nonatomic, strong) InputView *inputView;

//消息数组
@property (nonatomic, strong) NSMutableArray *messages;

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
    //此时键盘为隐藏
    self.typing = NO;
    
    //navigationBar添加一个leftButton 只要单独一个箭头
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //设置为黑色
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    [self creatTableView];
}

#pragma mark - 懒加载
- (NSMutableArray *)messages {
    if (_messages == nil) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"message.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dictArray.count];
        Message *previousModel = nil;
        
        for (NSDictionary *dict in dictArray) {
            MessageFrame *frameM = [[MessageFrame alloc] init];
            Message *message = [Message messageWithDict:dict];
            
            //判断是否显示时间
            message.timeHidden =  [message.time isEqualToString:previousModel.time];
            frameM.message = message;
            [models addObject:frameM];
            previousModel = message;
        }
        self.messages = [models mutableCopy];
    }
    return _messages;
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
    
    if (self.messages.count > 0) {  //有消息记录再让tableview滚动，否则会error
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
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
    //获取最后一条消息的模型 进行时间的比较
    Message *lastMessage = (Message *)[[_messages lastObject] message];
    
    //消息当前发送时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSString *dateString = [formatter stringFromDate:date];
    
    //创建模型储存
    Message *newMessage = [[Message alloc] init];
    newMessage.type = MessageType_ME;
    newMessage.text = text;
    newMessage.time = dateString;
    newMessage.timeHidden = [dateString isEqualToString:lastMessage.time];
    
    MessageFrame *messageFrame = [[MessageFrame alloc] init];
    messageFrame.message = newMessage;
    
    [self.messages addObject:messageFrame];
    [self.messageTableView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_messages.count - 1 inSection:0];
    [self.messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

///拖动屏幕的操作
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //取消编辑状态 会改变keyboard的状态 从而发送通知
    [self.view endEditing:YES];
}

#pragma mark - tableView的 dataSource 和 delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.messageFrame = self.messages[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageFrame *frame = [self.messages objectAtIndex:indexPath.row];
    return frame.rowHeight;
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
