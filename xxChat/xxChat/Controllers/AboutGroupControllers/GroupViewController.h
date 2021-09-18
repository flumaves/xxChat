//
//  GroupViewController.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/13.
//

#import <UIKit/UIKit.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import "ContactCell.h"
#import "NSString+Pinyin.h"
#import "GroupNotificationViewController.h"
#import "GroupInfomationViewController.h"
#import "SelectUserForGroupController.h"
#import <JMessage/JMessage.h>

#define JMESSAGE_APPKEY @"4823f4aad010e515513e2275"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]
NS_ASSUME_NONNULL_BEGIN

@interface GroupViewController : UIViewController

//群组列表数组
@property (nonatomic, strong) NSMutableArray* groupsListArray;

@property (nonatomic, strong) NSMutableArray* myGroupArray;

@property (nonatomic, strong) NSMutableArray* otherGroupArray;

//好友列表数组
@property (nonatomic, strong) NSMutableArray* friendsListArray;

//联系人分类首字母数组
@property (nonatomic, strong) NSMutableArray* sectionTitleArray;

//储存会话列表 （array中是 JMSGConversation）
@property (nonatomic, strong) NSMutableArray* conversationsArray;


//判定是否有新的群组通知，例如有人申请入群，有人退群等。
@property (nonatomic) BOOL isReceiveGroupEvent;

//tableview
@property (nonatomic,strong) UITableView* tableView;

@end

NS_ASSUME_NONNULL_END
