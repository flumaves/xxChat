//
//  SelectUserForGroupController.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/18.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
#import "ContactCell.h"
#import "NSString+Pinyin.h"
#import "CreateGroupViewController.h"

#define JMESSAGE_APPKEY @"4823f4aad010e515513e2275"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]
NS_ASSUME_NONNULL_BEGIN

@interface SelectUserForGroupController : UIViewController

@property (nonatomic,strong) UITableView* tableView;

//底部的view
@property (nonatomic,strong) UIView* baseView;
//完成按钮
@property (nonatomic, strong) UIButton* confirmButton;
//已经被选择了的数组
@property (nonatomic,strong) NSMutableArray* selectedArray;

//section名
@property (nonatomic,strong) NSMutableArray* sectionTitleArray;

//好友列表数组
@property (nonatomic, strong) NSMutableArray* friendsListArray;

@end

NS_ASSUME_NONNULL_END
