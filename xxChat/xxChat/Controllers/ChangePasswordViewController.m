//
//  ChangePasswordViewController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/11.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setAllViews];
    [self AutoLayoutAllViews];
}

- (void)setAllViews{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"修改密码";
    
    //背景view
    UIView* backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/3.0)];
    backgroundView.backgroundColor = MainColor;
    [self.view addSubview:backgroundView];
    
    //账号框
    self.account = [[UITextField alloc]init];
    self.account.layer.cornerRadius = 6;
    self.account.backgroundColor = [UIColor whiteColor];
    [self.account setFont:[UIFont systemFontOfSize:15]];
    [self.account setFrame:CGRectMake(ScreenWidth/12, 0, 0, 0)];//center用不了，因为还没有frame。
    self.account.placeholder = @"输入账号";
    self.account.layer.borderWidth = 0.5;//设置边框宽度
    self.account.layer.borderColor = [MainColor CGColor];//边框颜色
    self.account.leftViewMode = UITextFieldViewModeAlways;//设置左侧view一直存在
    self.account.clearButtonMode = UITextFieldViewModeWhileEditing;//设置一键清除按钮
    UIImageView *view_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    view_1.backgroundColor = [UIColor clearColor];
    view_1.image = [UIImage imageNamed:@"账号"];
    self.account.leftView = view_1;
    [self.view addSubview:self.account];
    
    //原始密码框
    self.originalPassword = [[UITextField alloc]init];
    self.originalPassword.layer.cornerRadius = 6;
    self.originalPassword.backgroundColor = [UIColor whiteColor];
    [self.originalPassword setFont:[UIFont systemFontOfSize:15]];
    self.originalPassword.placeholder = @"输入原密码";
    self.originalPassword.secureTextEntry = YES;//密码输入模式
    self.originalPassword.layer.borderWidth = 0.5;//设置边框宽度
    self.originalPassword.layer.borderColor = [MainColor CGColor];//边框颜色
    self.originalPassword.leftViewMode = UITextFieldViewModeAlways;
    self.originalPassword.clearButtonMode = UITextFieldViewModeWhileEditing;//设置一键清除按钮
    UIImageView *view_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    view_2.backgroundColor = [UIColor clearColor];
    view_2.image = [UIImage imageNamed:@"密码"];
    self.originalPassword.leftView = view_2;
    [self.view addSubview:self.originalPassword];
    
    //新密码框
    self.aNewPassword = [[UITextField alloc]init];
    self.aNewPassword.layer.cornerRadius = 6;
    self.aNewPassword.backgroundColor = [UIColor whiteColor];
    [self.aNewPassword setFont:[UIFont systemFontOfSize:15]];
    self.aNewPassword.placeholder = @"输入新密码";
    self.aNewPassword.secureTextEntry = YES;
    self.aNewPassword.layer.borderWidth = 0.5;//设置边框宽度
    self.aNewPassword.layer.borderColor = [MainColor CGColor];//边框颜色
    self.aNewPassword.leftViewMode = UITextFieldViewModeAlways;
    self.aNewPassword.clearButtonMode = UITextFieldViewModeWhileEditing;//设置一键清除按钮
    UIImageView *view_3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    view_3.backgroundColor = [UIColor clearColor];
    view_3.image = [UIImage imageNamed:@"密码"];
    self.aNewPassword.leftView = view_3;
    [self.view addSubview:self.aNewPassword];
    
    //设置确认按钮
    self.confirmButton = [[UIButton alloc]init];
    [self.confirmButton setBackgroundColor:MainColor];
    [self.confirmButton setTitle:@"确 认" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.confirmButton addTarget:self action:@selector(touchUpInsideConfiremButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
}

#pragma mark - 自动布局方法
- (void)AutoLayoutAllViews{
    
    
   
    
    //修改密码三件套
    _account.sd_layout.
    topSpaceToView(self.view, 300).
    widthIs(ScreenWidth*5/6).
    autoHeightRatio(1/8.0);
    
    _originalPassword.sd_layout.
    topSpaceToView(_account, 15).
    leftEqualToView(_account).
    rightEqualToView(_account).
    heightRatioToView(_account, 1);
    
    _aNewPassword.sd_layout.
    topSpaceToView(_originalPassword, 15).
    leftEqualToView(_originalPassword).
    rightEqualToView(_originalPassword).
    heightRatioToView(_originalPassword, 1);
    
 
    
    //确认按钮
    _confirmButton.sd_layout.
    topSpaceToView(_aNewPassword, 50).
    centerXEqualToView(self.view).widthRatioToView(self.view, 0.6).
    autoHeightRatio(0.2);
    _confirmButton.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
    
    
   
    
}

//点击确认按钮
- (void)touchUpInsideConfiremButton:(UIButton*)button{
    
    
    //如果存在密码或账号为空
    if ([self.account.text isEqualToString:@""]||[self.originalPassword.text isEqualToString:@""]||[self.aNewPassword.text isEqualToString:@""]) {
        
        [self showAlertViewWithMessage:@"账号或密码不能为空哦QAQ"];

        
    }else{
        //账号，原密码，新密码
        NSString* account = self.account.text;
        NSString* originalPassword = self.originalPassword.text;
        NSString* newPassword = self.aNewPassword.text;
        
        [JMSGUser loginWithUsername:account password:originalPassword completionHandler:^(id resultObject, NSError *error) {
            
                    if (!error) {//如果登陆没问题就跑修改密码方法
                        
                        [JMSGUser updateMyPasswordWithNewPassword:newPassword oldPassword:originalPassword completionHandler:^(id resultObject, NSError *error) {
                            
                            if (!error) {//如果修改没问题
                                
                                [self showAlertViewWithMessage:@"修改密码成功"];

                            }else{
                                
                                NSLog(@"更新密码出现错误：%@",error);
                                
                            }
                            
                        }];
                        
                    }else{//登陆出现问题
                        
                        NSString* errorStr = [NSString stringWithFormat:@"%@",error];
                        
                        if ([errorStr containsString:@"invalid password"]){//如果错误里面包含这个字符串
                            
                            [self showAlertViewWithMessage:@"账号或密码错误"];
                            
                        }
                    }
        }];
        
    }
    
    
 
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



@end
