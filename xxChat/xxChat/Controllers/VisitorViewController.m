//
//  VisitorViewController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/8/16.
//

#import "VisitorViewController.h"
#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]


@interface VisitorViewController ()<xxChatDelegate>
//xxchat的logo
@property (nonatomic,strong) UIImageView *xxIcon;
//登陆与注册的view
@property (nonatomic,strong) LoginAndRegisterView *LARView;


@end

@implementation VisitorViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layOutView];
}

- (void)layOutView{
    self.view.backgroundColor = [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1];
    //初始化xxchat的logo
    self.xxIcon = [[UIImageView alloc]init];
    self.xxIcon.backgroundColor = [UIColor whiteColor];
//    self.xxIcon.size = CGSizeMake(200, 200);
    self.xxIcon.layer.cornerRadius = 50;
    [self.view addSubview:_xxIcon];
    
    //初始化登陆和注册的view
    self.LARView = [[LoginAndRegisterView alloc]init];
    self.LARView.delegate = self;
    [self.view addSubview:_LARView];
    
    //执行自动布局方法
    [self AutolayoutAllViews];
    
}

#pragma mark - 自动布局方法
- (void)AutolayoutAllViews{
    _xxIcon.sd_layout.
    topSpaceToView(self.view, 100).
    centerXEqualToView(self.view).
    widthIs(100).
    heightIs(100);
    
    _LARView.sd_layout.
    topSpaceToView(_xxIcon, 100).
    widthIs(ScreenWidth).
    bottomEqualToView(self.view);

}

#pragma mark -展示提示框
//展示提示框
-(void)showAlertViewWithMessage: (NSString*)message
{
  UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     
  }];

  [alertController addAction:cancelAction];
  [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - LARView delegate

- (void)passAccount: (NSString*)account WithPassword: (NSString*)password WithAccountType: (AccountType)type{
  if (type==Register_Account) {
    //注册账号
      [JMSGUser registerWithUsername:account password:password completionHandler:^(id resultObject, NSError *error) {
                NSLog(@"-%@-",error);
          NSLog(@"=%@=",resultObject);
          [self showAlertViewWithMessage:@"注册成功QAQ"];
          self.LARView.regiAccount.text = @"";
          self.LARView.regiPassword_2.text = @"";
          self.LARView.regiPassword_1.text = @"";
      }];
      
  }else if(type==Login_Account){
      //登陆账号
      [JMSGUser loginWithUsername:account password:password completionHandler:^(id resultObject, NSError *error) {
                NSLog(@"-%@-",error);
          NSLog(@"=%@=",resultObject);
      }];
      NSLog(@"登陆账号");
      //监听已经登陆
      [[NSNotificationCenter defaultCenter]postNotificationName:@"FinishLogin" object:self];
      
      
  }else if(type==No_Account){
      //没填账号
      [self showAlertViewWithMessage:@"账号不能为空哦QAQ"];
  }else if(type==No_Password){
      //没填密码
      [self showAlertViewWithMessage:@"密码不能为空哦QAQ"];
  }else if (type==Password_NotEqual)
      //密码不相等
      [self showAlertViewWithMessage:@"两次密码不相等QAQ"];

}

@end
