//
//  AddViewController.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/3.
//

#import <UIKit/UIKit.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <JMessage/JMessage.h>
#import "SearchResultCell.h"
#import "SearchInfomationController.h"

#define JMESSAGE_APPKEY @"4823f4aad010e515513e2275"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]

NS_ASSUME_NONNULL_BEGIN

@interface AddViewController : UIViewController

//点击展示好友搜索模块
@property (nonatomic,strong) UIButton* addFriendButton;
//点击展示群组搜索模块
@property (nonatomic,strong) UIButton* addGroupButton;
//搜索框
@property (nonatomic,strong) UITextField* searchField;
//确认搜索按键
@property (nonatomic,strong) UIButton* confirmButton;
//结果展示的tableview
@property (nonatomic,strong) UITableView* searchTableView;
//显示在tableview上的模型数组
@property (nonatomic,strong) NSMutableArray* userAndGroupArray;
//判断点击了哪个模式（找人或者找群）的bool
@property (nonatomic) BOOL inFindGroup;
@end

NS_ASSUME_NONNULL_END