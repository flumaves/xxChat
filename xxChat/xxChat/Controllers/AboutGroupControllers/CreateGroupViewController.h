//
//  CreateGroupViewController.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/18.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
#import "SelectUserForGroupController.h"
#import "GroupViewController.h"

#define JMESSAGE_APPKEY @"4823f4aad010e515513e2275"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]
NS_ASSUME_NONNULL_BEGIN

@interface CreateGroupViewController : UIViewController
//已选好友名单
@property (nonatomic, strong) NSMutableArray* selectedArray;

//群名
@property (nonatomic, strong) UITextField* groupName;

//群描述
@property (nonatomic, strong) UITextView* descriptionTextView;

@end

NS_ASSUME_NONNULL_END
