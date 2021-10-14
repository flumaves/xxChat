//
//  ChangePasswordViewController.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/11.
//

#import <UIKit/UIKit.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <JMessage/JMessage.h>
#define JMESSAGE_APPKEY @"4823f4aad010e515513e2275"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]
NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordViewController : UIViewController

//账号输入框
@property (nonatomic,strong) UITextField *account;
//原来密码输入框
@property (nonatomic,strong) UITextField *originalPassword;
//修改密码输入框
@property (nonatomic,strong) UITextField *aNewPassword;
//确认按钮
@property (nonatomic,strong) UIButton *confirmButton;

@end

NS_ASSUME_NONNULL_END
