//
//  SearchInfomationController.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/3.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
#define JMESSAGE_APPKEY @"4823f4aad010e515513e2275"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]

NS_ASSUME_NONNULL_BEGIN

@interface SearchInfomationController : UITableViewController
//用户信息
@property (nonatomic,strong) JMSGUser* User;
//群组信息
@property (nonatomic,strong) JMSGGroup* group;
//加好友按钮
@property (nonatomic,strong) UIButton* addButton;

@end

NS_ASSUME_NONNULL_END
