//
//  FriendInfomationViewController.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/13.
//

#import <UIKit/UIKit.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <JMessage/JMessage.h>
#define JMESSAGE_APPKEY @"4823f4aad010e515513e2275"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]

NS_ASSUME_NONNULL_BEGIN

@interface FriendInfomationViewController : UIViewController

//用户信息
@property (nonatomic,strong) JMSGUser* user;

//tableview
@property (nonatomic,strong) UITableView* tableView;

//发起会话button
@property (nonatomic,strong) UIButton* chatButton;

@end

NS_ASSUME_NONNULL_END
