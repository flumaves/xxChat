//
//  FriendInvitationViewController.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/2.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
#define JMESSAGE_APPKEY @"4823f4aad010e515513e2275"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]


NS_ASSUME_NONNULL_BEGIN

@interface FriendInvitationViewController : UIViewController

//显示添加者的tableview
@property (nonatomic,strong) UITableView* friendInvtationTableView;

//好友申请者的数组
@property(nonatomic,strong) NSMutableArray* friendInvitationArray;

//好友申请理由数组
@property(nonatomic,strong) NSMutableArray* invitedReasonArray;
@end

NS_ASSUME_NONNULL_END
