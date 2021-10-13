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
#import "MessageTableView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MoreFunctionView.h"
#import <PhotosUI/PhotosUI.h>
#import "ImagePicker.h"
#import "ImageCollectionViewCell.h"
#import "EmojiView.h"
#import "ImageBrowser.h"
#import "ImageBrowserCollectionViewCell.h"
#import "UIImage+YCHUD.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define INTERVAL 60*3 //3分钟的时间间隔

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JMSGMessageDelegate, InputViewDelegate, MessageCellDelegate, AVAudioPlayerDelegate,ImagePickerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
//navigationBar后面的背景的view
@property (nonatomic, strong) UIView *backgroundView;

//显示消息的tableView
@property (nonatomic, strong) MessageTableView *messageTableView;

//底部输入文字的视图
@property (nonatomic, strong) InputView *inputView;

//inputView的编辑状态
@property (nonatomic, assign) InputViewStatus fromStatus;
@property (nonatomic, assign) InputViewStatus toStatus;

//moreFunctionView
@property (nonatomic, strong) MoreFunctionView *moreFunctionView;

//表情包
@property (nonatomic, strong) EmojiView *emojiView;

//图片选择器
@property (nonatomic, weak) ImagePicker *imgPicker;
//图片浏览器
@property (nonatomic, weak) ImageBrowser *imgBrowser;
//聊天内容的图片的数组
@property (nonatomic, strong) NSMutableArray <JMSGImageContent *> *messageImageArray;

//imagePicker选中的图片数组
@property (nonatomic, strong) NSMutableArray *imagePathArray;

//表情包数组
@property (nonatomic, strong) NSMutableArray *emojiPathArray;

//消息数组
@property (nonatomic, strong) NSMutableArray <MessageFrame *> *messagesArray;

//会话类型 （单聊 群组）
@property (nonatomic, assign) JMSGConversationType conversationType;
//登陆的人
@property (nonatomic, strong) JMSGUser *user;
//聊天的对象
@property (nonatomic, strong) JMSGUser *anotherUser;
//聊天的群组
@property (nonatomic, strong) JMSGGroup *group;

//语音消息的播放器
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation MessageViewController

/*
 页面打开时隐藏tabBar
 离开页面显示tabBar
 */
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    
    //添加通知的监听
    [self addObservers];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    
    //注销通知的监听
    [self removeObservers];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加代理
    [JMessage addDelegate:self withConversation:_conversation];
    
    //navigationBar添加一个leftButton 只要单独一个箭头
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //设置为黑色
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    [self creatTableView];
}

#pragma mark - 添加监听
//添加监听
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreFunctionSubViewClick:) name:@"moreFunctionSubViewClick" object:nil];
}

//注销监听
- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"moreFunctionSubViewClick" object:nil];
}


#pragma mark - 懒加载
- (NSMutableArray *)messageImageArray {
    if (!_messageImageArray) {
        NSMutableArray *messageImageArray = [NSMutableArray array];
        //遍历messagesArray 判断内容的类型 如果是图片 添加到数组中
        for (int i = 0; i < _messagesArray.count; i++) {
            MessageFrame *messageFrame = _messagesArray[i];
            if (messageFrame.message.message.contentType == kJMSGContentTypeImage) {
                JMSGImageContent *content = (JMSGImageContent *)messageFrame.message.message.content;
                [messageImageArray addObject:content];
            }
        }
        NSLog(@"%lu",(unsigned long)messageImageArray.count);
        _messageImageArray = messageImageArray;
    }
    return _messageImageArray;
}

- (void)setConversation:(JMSGConversation *)conversation {
    _conversation = conversation;
    
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        self.anotherUser = (JMSGUser *)conversation.target;
    } else if (conversation.conversationType == kJMSGConversationTypeGroup) {
        self.group = (JMSGGroup *)conversation.target;
    }
    
    _conversationType = conversation.conversationType;
}

//“我”用户
- (JMSGUser *)user {
    if (_user == nil) {
        JMSGUser *user = [JMSGUser myInfo];
        _user = user;
    }
    return _user;
}

//消息数组
- (NSMutableArray *)messagesArray {
    if (_messagesArray == nil) {
        _messagesArray = [[NSMutableArray alloc] init];
        
        //获取最新的50条记录
        NSNumber *limit = [NSNumber numberWithInt:50];
        NSArray *array = [_conversation messageArrayFromNewestWithOffset:nil limit:limit];
        Message *lastMessage = [[Message alloc] init];
        
        for (JMSGMessage *j_message in array) {
            if (j_message.contentType != kJMSGContentTypeText &&
                j_message.contentType != kJMSGContentTypeImage &&
                j_message.contentType != kJMSGContentTypeVideo &&
                j_message.contentType != kJMSGContentTypeVoice) {
                continue;
            }
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

//图片数组
- (NSMutableArray *)imagePathArray {
    if (!_imagePathArray) {
        _imagePathArray = [NSMutableArray array];
        //所有子目录的文件名
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:[[NSBundle mainBundle] bundlePath]];
        NSString *subString = @"图片素材";
        //遍历子目录
        for (NSString *imageName in files) {
            if ([imageName containsString:subString]) {
                NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:imageName];
                [_imagePathArray addObject:path];
            }
        }
    }
    return _imagePathArray;
}

//表情包数组
- (NSMutableArray *)emojiPathArray {
    if (!_emojiPathArray) {
        _emojiPathArray = [NSMutableArray array];
        //所有子目录的文件名
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:[[NSBundle mainBundle] bundlePath]];
        NSString *subString = @"表情包素材";
        //遍历子目录
        for (NSString *emojiName in files) {
            if ([emojiName containsString:subString]) {
                NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:emojiName];
                [_emojiPathArray addObject:path];
            }
        }
    }
    return _emojiPathArray;
}


#pragma mark - 创建界面
- (void)creatTableView {
    CGFloat navigationBarMAXY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    //tableView
    self.messageTableView = [[MessageTableView alloc] initWithFrame:CGRectMake(0, navigationBarMAXY, ScreenWidth, ScreenHeight - 90 - navigationBarMAXY)];
    //取消tableView自动更改内边距
    self.messageTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.messageTableView.dataSource = self;
    self.messageTableView.delegate = self;
    [self.view addSubview:self.messageTableView];
    if (self.messagesArray.count != 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    
    //navigationBar后面添加一个view解决透明度引起的颜色问题
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, navigationBarMAXY)];
    _backgroundView.backgroundColor = self.messageTableView.backgroundColor;
    [self.view addSubview:_backgroundView];
    
    //文本输入框
    self.inputView = [[InputView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.messageTableView.frame), ScreenWidth, 90)];
    self.inputView.delegate = self;
    [self.view addSubview:_inputView];
    
    self.inputView.inputTextField.delegate = self;
    
    //moreFunctionView
    CGFloat moreFunctionViewHeight = 250;
    self.moreFunctionView = [[MoreFunctionView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, moreFunctionViewHeight)];
    _moreFunctionView.hidden = YES;
    [self.view addSubview:_moreFunctionView];
    
    //emojiView
    CGRect emojiViewFrame = _moreFunctionView.frame;
    self.emojiView = [[EmojiView alloc] initWithFrame:emojiViewFrame];
    _emojiView.emojiCollectionView.delegate = self;
    _emojiView.emojiCollectionView.dataSource = self;
    _emojiView.hidden = YES;
    [self.view addSubview:_emojiView];
    
    //注册键盘变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 收到消息的回调
- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error {
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    if (![self.conversation isMessageForThisConversation:message]) {
        //判断消息是否属于该会话
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
    [self.messageTableView scrollsToTop];
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
    newMessage.userName = self.user.username;
    [newMessage setMessage:message];
    //获取最近一次消息的模型（判断是否隐藏时间）
    MessageFrame *lastMessageFrame = self.messagesArray.firstObject;
    JMSGMessage *lastMessage = lastMessageFrame.message.message;
    newMessage.timeHidden = [self setTimeHiddenBetweenLastTime:lastMessage andCurrentTime:message];
    
    MessageFrame *messageFrame = [[MessageFrame alloc] init];
    messageFrame.message = newMessage;
    
    [self.messagesArray addObject:messageFrame];
    [self.messageTableView reloadData];
    [self tableViewScrollToButton];
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
- (void)KeyboardWillChange:(NSNotification *)notification
{
    _moreFunctionView.hidden = YES;
    _emojiView.hidden = YES;
    
    NSDictionary *dict = notification.userInfo;
    CGRect KeyboardFrame = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat KeyboardY = KeyboardFrame.origin.y;
    //为了美观将view向下移动30 避免inputview下方空白太大
    CGRect inputViewFrame = _inputView.frame;
    inputViewFrame.origin.y = KeyboardY - inputViewFrame.size.height + 30;
    if (KeyboardY == ScreenHeight) {    //当键盘缩回时 重新将额外移动的30像素还原
        inputViewFrame.origin.y -= 30;
    }
    //tableView的frame
    CGRect tableViewFrame = _messageTableView.frame;
    tableViewFrame.origin.y = inputViewFrame.origin.y - tableViewFrame.size.height;
    
    if (_fromStatus == InputViewStatusShowKeyboard && (_toStatus == InputViewStatusShowEmoji || _toStatus == InputViewStatusShowMore)) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.inputView.frame = inputViewFrame;
        self.messageTableView.frame = tableViewFrame;
    }];
}

///点击发送后执行的操作
- (void)addMessage:(NSString *)text type:(MessageType)type {
    //创建消息
    JMSGTextContent *content = [[JMSGTextContent alloc] initWithText:text];
    if (_conversationType == kJMSGConversationTypeSingle) {
        JMSGMessage *message = [JMSGMessage createSingleMessageWithContent:content username:self.anotherUser.username];
        
        //发送消息
        [JMSGMessage sendMessage:message];
    } else {
        JMSGMessage *message = [JMSGMessage createGroupMessageWithContent:content groupId:_group.gid];
        [JMSGMessage sendMessage:message];
    }
}

#pragma mark - scrollViewBeginDragging
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.messageTableView]) {
        if (_toStatus == InputViewStatusShowKeyboard) {
            //取消编辑状态 会改变keyboard的状态 从而发送通知
            [self.view endEditing:YES];
            self.moreFunctionView.hidden = YES;
            self.emojiView.hidden = YES;
        } else if (_toStatus != InputViewStatusNothing) {
            //改成默认状态
            self.inputView.fromStatus = _toStatus;
            self.inputView.toStatus = InputViewStatusNothing;
            [self changeInputViewFromStatus:_toStatus ToStatus:InputViewStatusNothing];
        }
    }
}

#pragma mark - tableView的 dataSource 和 delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = @"messageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.delegate = self;
    }
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

/// 滚动到底部
- (void)tableViewScrollToButton {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

#pragma mark - collectionView的delegate和datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.imgPicker.imageCollectionView]) {
        return self.imagePathArray.count;
    } else if ([collectionView isEqual:self.emojiView.emojiCollectionView]){
        return self.emojiPathArray.count;
    } else if ([collectionView isEqual:self.imgBrowser.imageBrowserCollectionView]){
        return self.messageImageArray.count;
    } else {
        return 20;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.imgPicker.imageCollectionView]) {
        ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        //加载图片素材
        NSString *imagePath = [self.imagePathArray objectAtIndex:indexPath.item];
        cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
        cell.delegate = self.imgPicker;
        return cell;
        
    } else if ([collectionView isEqual:self.emojiView.emojiCollectionView]) {
        EmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emojiCell" forIndexPath:indexPath];
        //加载表情包素材
        NSString *emojiPath = [self.emojiPathArray objectAtIndex:indexPath.item];
        cell.emojiImageView.image = [UIImage imageWithContentsOfFile:emojiPath];
        cell.emojiPath = emojiPath;
        return cell;
        
    } else {
        ImageBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageBrowserCell" forIndexPath:indexPath];
        JMSGImageContent *content = _messageImageArray[indexPath.item];
        NSLog(@"%@",content.imageLink);
        [content largeImageDataWithProgress:nil completionHandler:^(NSData *data, NSString *objectId, NSError *error) {
            if (error) {
                NSLog(@"imageBrowserCell设置图片出错：%@",error);
                return;
            }
            //设置cell的放大倍数，当图片很长的时候，cell默认的3.5倍不够 这是设置图片能够放大到跟屏幕一样宽
            if (content.imageSize.width < [UIScreen mainScreen].bounds.size.width) {
                cell.scrollView.maximumZoomScale = [UIScreen mainScreen].bounds.size.width / content.imageSize.width;
            }
            cell.imgView.image = [UIImage YCHUDImageWithSmallGIFData:data scale:1];
        }];
        return cell;
    
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:_imgPicker.imageCollectionView]) {
       
    } else if ([collectionView isEqual:_emojiView.emojiCollectionView]) {
        //获取图片data
        EmojiCollectionViewCell *cell = (EmojiCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        NSData *data = [NSData data];
        //判断是gif还是png
        if (cell.emojiType == EmojiType_JPG) {
            //直接通过cell中的imgeView获取图片数据
            data = UIImagePNGRepresentation(cell.emojiImageView.image);
        } else if (cell.emojiType == EmojiType_GIF) {
            //gif转NSData
            data = [NSData dataWithContentsOfFile:cell.emojiPath];
        }
        //创建消息
        JMSGImageContent *content = [[JMSGImageContent alloc] initWithImageData:data];
        if (_conversationType == kJMSGConversationTypeSingle) {
            JMSGMessage *message = [JMSGMessage createSingleMessageWithContent:content username:self.anotherUser.username];
            //发送消息
            [JMSGMessage sendMessage:message];
        } else {
            JMSGMessage *message = [JMSGMessage createGroupMessageWithContent:content groupId:_group.gid];
            //发送消息
            [JMSGMessage sendMessage:message];
        }
    }
}


#pragma mark - textfield的delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_messagesArray.count != 0) {
        [self.messageTableView scrollsToTop];
        
        [self.inputView.emojiBtn setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
        [self.inputView.moreBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
        self.inputView.fromStatus = _toStatus;
        _fromStatus = _toStatus;
        self.inputView.toStatus = InputViewStatusShowKeyboard;
        _toStatus = InputViewStatusShowKeyboard;
    }
}

//当按下回车键的时候
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //模型数据的处理
    [self addMessage:textField.text type:MessageType_ME];
    //清空textField
    self.inputView.inputTextField.text = @"";
    return YES;
}


#pragma mark - inputView的 delegate 和 通知
//发送语音消息
- (void)sendMessage:(JMSGVoiceContent *)voiceContent {
    if (_conversationType == kJMSGConversationTypeSingle) {
        JMSGMessage *message = [JMSGMessage createSingleMessageWithContent:voiceContent username:self.anotherUser.username];
        
        //发送消息
        [JMSGMessage sendMessage:message];
        
    } else {
        JMSGMessage *message = [JMSGMessage createGroupMessageWithContent:voiceContent groupId:self.group.gid];
        
        //发送消息
        [JMSGMessage sendMessage:message];
    }
}

//更新inputview的状态
- (void)changeInputViewFromStatus:(InputViewStatus)fromStatus ToStatus:(InputViewStatus)toStatus {
    NSLog(@"%ld,%ld",(long)fromStatus, (long)toStatus);
    _fromStatus = fromStatus;
    _toStatus = toStatus;
    self.moreFunctionView.hidden = YES;
    self.emojiView.hidden = YES;
    
    if (toStatus == InputViewStatusShowKeyboard) {
    ///要展示键盘
        return;
    }
    
    if (toStatus == InputViewStatusShowMore || toStatus == InputViewStatusShowEmoji) {
    ///展示moreFunctionView 或是 表情包
        if (toStatus == InputViewStatusShowMore) {  //显示moreFunctionView
            self.moreFunctionView.hidden = NO;
            [self.view bringSubviewToFront:self.moreFunctionView];
            //重新移动到屏幕的底部
            CGRect frame = _moreFunctionView.frame;
            frame.origin.y = ScreenHeight;
            _moreFunctionView.frame = frame;
        } else if (toStatus == InputViewStatusShowEmoji) {  //显示表情包
            self.emojiView.hidden = NO;
            [self.view bringSubviewToFront:self.emojiView];
            //重新移动到屏幕的底部
            CGRect frame = _emojiView.frame;
            frame.origin.y = ScreenHeight;
            _emojiView.frame = frame;
        }
        if (fromStatus == InputViewStatusShowEmoji || fromStatus == InputViewStatusShowMore) {
            //原本是表情包状态或moreFunctionView 则InputView不需要动画
            if (toStatus == InputViewStatusShowMore) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGRect frame = self.moreFunctionView.frame;
                    frame.origin.y -= frame.size.height;
                    self.moreFunctionView.frame = frame;
                }];
            } else {
                [UIView animateWithDuration:0.3 animations:^{
                    CGRect frame = self.emojiView.frame;
                    frame.origin.y -= frame.size.height;
                    self.emojiView.frame = frame;
                }];
            }
            return;
        } else if (fromStatus == InputViewStatusShowVoice ||
                   fromStatus == InputViewStatusNothing) {
            //原本是录音状态
            [UIView animateWithDuration:0.3 animations:^{
                //inputview的位置改变
                CGRect inputViewFrame = self.inputView.frame;
                CGFloat transY = self.inputView.frame.origin.y - self.moreFunctionView.frame.size.height + 30;
                inputViewFrame.origin.y = transY;
                self.inputView.frame = inputViewFrame;
                
                if (toStatus == InputViewStatusShowEmoji) {
                    //emojiView的位置改变
                    CGRect frame = self.emojiView.frame;
                    frame.origin.y = frame.origin.y - self.emojiView.frame.size.height;
                    self.emojiView.frame = frame;
                } else {
                    //moreFunctionView的位置改变
                    CGRect frame = self.moreFunctionView.frame;
                    frame.origin.y = frame.origin.y - self.moreFunctionView.frame.size.height;
                    self.moreFunctionView.frame = frame;
                }
                //tableView的位置改变
                CGRect tableViewFrame = self.messageTableView.frame;
                tableViewFrame.origin.y = inputViewFrame.origin.y - tableViewFrame.size.height;
                self.messageTableView.frame = tableViewFrame;
            }];
        } else if (fromStatus == InputViewStatusShowKeyboard) {
            [_inputView.inputTextField resignFirstResponder];
            
            //原本是显示键盘
            if (toStatus == InputViewStatusShowMore) {
                [UIView animateWithDuration:0.2 animations:^{
                    CGRect frame = self.moreFunctionView.frame;
                    frame.origin.y -= frame.size.height;
                    self.moreFunctionView.frame = frame;
                    
                    CGRect inputViewFrame = self.inputView.frame;
                    inputViewFrame.origin.y = frame.origin.y - inputViewFrame.size.height + 30;
                    self.inputView.frame = inputViewFrame;
                    
                    CGRect tableViewFrame = self.messageTableView.frame;
                    tableViewFrame.origin.y = inputViewFrame.origin.y - tableViewFrame.size.height;
                    self.messageTableView.frame = tableViewFrame;
                }];
            } else {
                [UIView animateWithDuration:0.3 animations:^{
                    CGRect frame = self.emojiView.frame;
                    frame.origin.y -= frame.size.height;
                    self.emojiView.frame = frame;
                    
                    CGRect inputViewFrame = self.inputView.frame;
                    inputViewFrame.origin.y = frame.origin.y - inputViewFrame.size.height + 30;
                    self.inputView.frame = inputViewFrame;
                    
                    CGRect tableViewFrame = self.messageTableView.frame;
                    tableViewFrame.origin.y = inputViewFrame.origin.y - tableViewFrame.size.height;
                    self.messageTableView.frame = tableViewFrame;
                }];
            }
        }
        return;
    }
    
    if (toStatus == InputViewStatusShowVoice) {
    ///显示录音
        if (fromStatus == InputViewStatusShowMore || fromStatus == InputViewStatusShowEmoji) {
            [UIView animateWithDuration:0.3 animations:^{
                //emojiView和moreFunctionView
                CGRect frame = self.emojiView.frame;
                frame.origin.y = ScreenHeight;
                self.emojiView.frame = frame;
                self.moreFunctionView.frame = frame;
                //inputview
                CGRect inputViewFrame = self.inputView.frame;
                inputViewFrame.origin.y = frame.origin.y - inputViewFrame.size.height;
                self.inputView.frame = inputViewFrame;
                //tableView
                CGRect tableViewFrame = self.messageTableView.frame;
                tableViewFrame.origin.y = inputViewFrame.origin.y - tableViewFrame.size.height;
                self.messageTableView.frame = tableViewFrame;
            }];
        }
        if (fromStatus == InputViewStatusShowKeyboard) {
            [_inputView.inputTextField resignFirstResponder];
        }
        return;
    }
    
    if (toStatus == InputViewStatusNothing) {
    ///显示最初的默认状态
        if (fromStatus == InputViewStatusShowMore || fromStatus == InputViewStatusShowEmoji) {
            [UIView animateWithDuration:0.3 animations:^{
                //emojiView和moreFunctionView
                CGRect frame = self.emojiView.frame;
                frame.origin.y = ScreenHeight;
                self.emojiView.frame = frame;
                self.moreFunctionView.frame = frame;
                //inputview
                CGRect inputViewFrame = self.inputView.frame;
                inputViewFrame.origin.y = frame.origin.y - inputViewFrame.size.height;
                self.inputView.frame = inputViewFrame;
                //tableView
                CGRect tableViewFrame = self.messageTableView.frame;
                tableViewFrame.origin.y = inputViewFrame.origin.y - tableViewFrame.size.height;
                self.messageTableView.frame = tableViewFrame;
                
                if (fromStatus == InputViewStatusShowEmoji) {
                    [self.inputView.emojiBtn setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
                }
                if (fromStatus == InputViewStatusShowMore) {
                    [self.inputView.moreBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
                }
            }];
        }
        return;
    }
}


#pragma mark - ImageimgPicker的delegate
- (void)didFinishingPickImage {
    NSMutableArray *choosePhotoArray = _imgPicker.choosePhotoArray;
    for (ImageCollectionViewCell *cell in choosePhotoArray) {
        NSData *data = UIImagePNGRepresentation(cell.imageView.image);
        //创建消息
        JMSGImageContent *content = [[JMSGImageContent alloc] initWithImageData:data];
        if (_conversationType == kJMSGConversationTypeSingle) {
            JMSGMessage *message = [JMSGMessage createSingleMessageWithContent:content username:_anotherUser.username];
            [JMSGMessage sendMessage:message];
        } else {
            JMSGMessage *message = [JMSGMessage createGroupMessageWithContent:content groupId:_group.gid];
            [JMSGMessage sendMessage:message];
        }
    }
    //隐藏imagePicker
    [UIView animateWithDuration:0.3 animations:^{
        CGRect imageimgPickerFrame = self.imgPicker.frame;
        imageimgPickerFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.imgPicker.frame = imageimgPickerFrame;
        self.navigationController.navigationBar.hidden = NO;
    }];
}

- (void)didCancelPickImage {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect imageimgPickerFrame = self.imgPicker.frame;
        imageimgPickerFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.imgPicker.frame = imageimgPickerFrame;
        self.navigationController.navigationBar.hidden = NO;
    }];
}


#pragma mark - ImageBrowser的方法
- (void)imageBrowserOneTimeTap {
    NSLog(@"%s",__func__);
    [_imgBrowser removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imageBrowserOneTimeTap" object:nil];
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark - moreFunctionView的delegate
- (void)moreFunctionSubViewClick:(NSNotification *)notification {
    MoreFunctionSubView *subView = notification.object;
    NSString *subViewText = subView.lbl.text;
    if ([subViewText isEqual:@"相片"]) {
        ImagePicker *imageimgPicker = [[ImagePicker alloc] initWithFrame:
                                    CGRectMake(0,
                                               [UIScreen mainScreen].bounds.size.height,
                                               [UIScreen mainScreen].bounds.size.width,
                                               [UIScreen mainScreen].bounds.size.height)];
        imageimgPicker.delegate = self;
        imageimgPicker.imageCollectionView.delegate = self;
        imageimgPicker.imageCollectionView.dataSource = self;
        self.imgPicker = imageimgPicker;
        [self.view addSubview:imageimgPicker];
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = imageimgPicker.frame;
            frame.origin.y = 0;
            imageimgPicker.frame = frame;
            self.navigationController.navigationBar.hidden = YES;
        }];
    } else {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:@"功能未开放" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - MessageCell的delegate
//播放语音消息
- (void)playVoice:(NSData *)data {
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    _audioPlayer.numberOfLoops = 1;
    _audioPlayer.delegate = self;
    [_audioPlayer play];
}

/// 显示imageBrowser
- (void)showImageBrowserWithImageTag:(int)imageTag {
    ImageBrowser *imageBrowser = [[ImageBrowser alloc] initWithFrame:CGRectMake(0,
                                                                                0,
                                                            [UIScreen mainScreen].bounds.size.width,
                                                            [UIScreen mainScreen].bounds.size.height)];
    imageBrowser.imageBrowserCollectionView.delegate = self;
    imageBrowser.imageBrowserCollectionView.dataSource = self;
    _imgBrowser = imageBrowser;
    [_imgBrowser.imageBrowserCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.messageImageArray.count - imageTag inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    [self.view addSubview:imageBrowser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageBrowserOneTimeTap) name:@"imageBrowserOneTimeTap" object:nil];
    
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - leftBarButtonItem的方法
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - audioPlayer的delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        NSLog(@"successfully");
    } else {
        NSLog(@"unsuccessfully");
    }
}
@end
