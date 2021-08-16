//
//  LoginAndRegisterView.h
//  xxChat
//
//  Created by 谢恩平 on 2021/8/16.
//

#import <UIKit/UIKit.h>
#import <SDAutoLayout/SDAutoLayout.h>

#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

NS_ASSUME_NONNULL_BEGIN

@interface LoginAndRegisterView : UIView
//登陆按钮
@property (nonatomic,strong) UIButton *loginButton;
//注册按钮
@property (nonatomic,strong) UIButton *registerButton;
//滑块
@property (nonatomic,strong) UIView *slider;
//注册账号输入框
@property (nonatomic,strong) UITextField *regiAccount;
//注册密码输入框1
@property (nonatomic,strong) UITextField *regiPassword_1;
//注册密码输入框2 这个用来确认密码
@property (nonatomic,strong) UITextField *regiPassword_2;
//登陆账号输入框
@property (nonatomic,strong) UITextField *loginAccount;
//登陆密码输入框
@property (nonatomic,strong) UITextField *loginPassword;
//确认按钮
@property (nonatomic,strong) UIButton *confirmButton;
//账号下面的线
@property (nonatomic,strong) UIView *line_1;
//密码下面的线
@property (nonatomic,strong) UIView *line_2;

//判断滑块在哪个位置的bool
@property (nonatomic) BOOL inRegister;

@end

NS_ASSUME_NONNULL_END
