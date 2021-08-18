//
//  SelfInformationTableViewController.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/11.
//


///该tableView用于显示个人界面中点击第一个cell跳转的更详细的个人信息显示

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelfInformationTableViewController : UITableViewController

@property (nonatomic, strong) JMSGUser *user;

@end

NS_ASSUME_NONNULL_END
