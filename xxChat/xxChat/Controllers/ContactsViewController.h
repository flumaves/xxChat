//
//  ContactViewController.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/9.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
#import "AddViewController.h"
#import "ContactCell.h"
#import "FriendInvitationViewController.h"

#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]

NS_ASSUME_NONNULL_BEGIN

@interface ContactsViewController : UIViewController
//好友列表数组
@property(nonatomic,strong) NSMutableArray* friendsListArray;

//好友申请列表数组
@property(nonatomic,strong) NSMutableArray* friendInvitationArray;

//好友申请理由数组
@property(nonatomic,strong) NSMutableArray* invitedReasonArray;

//判定是否有新的好友请求
@property (nonatomic) BOOL isReceiveInvitation;

@end

NS_ASSUME_NONNULL_END
