//
//  LoginAndRegisterView.m
//  xxChat
//
//  Created by 谢恩平 on 2021/8/16.
//

#import "LoginAndRegisterView.h"

@implementation LoginAndRegisterView

//重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layOutViews];
    }
    return self;
}

- (void)layOutViews{
    self.backgroundColor = [UIColor whiteColor];
    
    //注册与登陆按钮
    self.registerButton = [[UIButton alloc]init];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:15];//字体
    [self.registerButton addTarget:self action:@selector(slideringViewsWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_registerButton];
    
    self.loginButton = [[UIButton alloc]init];
    [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:MainColor forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:15];//字体
    [self.loginButton addTarget:self action:@selector(slideringViewsWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginButton];
    
    //滑块的灰色背景
    UIView *sliderBackground = [[UIView alloc]init];
    sliderBackground.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:sliderBackground];
    
    //按钮下的滑块
    self.slider = [[UIView alloc]init];
    self.slider.backgroundColor = MainColor;
    [self addSubview:_slider];
    [self.slider setFrame:CGRectMake(ScreenWidth/2, 0, 0, 0)];//给一个初始x，不用autolayout写死，防止动画出现问题。
    
    //注册输入框的初始化
    self.regiAccount = [[UITextField alloc]init];
    self.regiAccount.layer.cornerRadius = 6;
    self.regiAccount.backgroundColor = [UIColor whiteColor];
    [self.regiAccount setFont:[UIFont systemFontOfSize:15]];
    [self.regiAccount setFrame:CGRectMake(ScreenWidth/12-ScreenWidth, 0, 0, 0)];//center用不了，因为还没有frame。
    self.regiAccount.placeholder = @"输入账号";
    self.regiAccount.layer.borderWidth = 0.5;//设置边框宽度
    self.regiAccount.layer.borderColor = [MainColor CGColor];//边框颜色
    self.regiAccount.leftViewMode = UITextFieldViewModeAlways;//设置左侧view一直存在
    UIImageView *view_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    view_1.backgroundColor = [UIColor clearColor];
    view_1.image = [UIImage imageNamed:@"账号"];
    self.regiAccount.leftView = view_1;
    [self addSubview:_regiAccount];
    
    
    self.regiPassword_1 = [[UITextField alloc]init];
    self.regiPassword_1.layer.cornerRadius = 6;
    self.regiPassword_1.backgroundColor = [UIColor whiteColor];
    [self.regiPassword_1 setFont:[UIFont systemFontOfSize:15]];
    self.regiPassword_1.placeholder = @"输入密码";
    self.regiPassword_1.secureTextEntry = YES;//密码输入模式
    self.regiPassword_1.layer.borderWidth = 0.5;//设置边框宽度
    self.regiPassword_1.layer.borderColor = [MainColor CGColor];//边框颜色
    self.regiPassword_1.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *view_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    view_2.backgroundColor = [UIColor clearColor];
    view_2.image = [UIImage imageNamed:@"密码"];
    self.regiPassword_1.leftView = view_2;
    [self addSubview:_regiPassword_1];
    
    self.regiPassword_2 = [[UITextField alloc]init];
    self.regiPassword_2.layer.cornerRadius = 6;
    self.regiPassword_2.backgroundColor = [UIColor whiteColor];
    [self.regiPassword_2 setFont:[UIFont systemFontOfSize:15]];
    self.regiPassword_2.placeholder = @"再次确认密码";
    self.regiPassword_2.secureTextEntry = YES;
    self.regiPassword_2.layer.borderWidth = 0.5;//设置边框宽度
    self.regiPassword_2.layer.borderColor = [MainColor CGColor];//边框颜色
    self.regiPassword_2.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *view_3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    view_3.backgroundColor = [UIColor clearColor];
    view_3.image = [UIImage imageNamed:@"密码"];
    self.regiPassword_2.leftView = view_3;
    [self addSubview:_regiPassword_2];
    
    //登陆输入框初始化
    self.loginAccount = [[UITextField alloc]init];
    self.loginAccount.layer.cornerRadius = 6;
    self.loginAccount.backgroundColor = [UIColor whiteColor];
    [self.loginAccount setFont:[UIFont systemFontOfSize:15]];
    [self.loginAccount setFrame:CGRectMake(ScreenWidth/12, 0, 0, 0)];//设置初始位置
    self.loginAccount.placeholder = @"请输入账号";
    self.loginAccount.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *view_4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    view_4.backgroundColor = [UIColor clearColor];
    view_4.image = [UIImage imageNamed:@"账号"];
    self.loginAccount.leftView = view_4;
    [self addSubview:self.loginAccount];
    
    //账号下面的线
    self.line_1 = [[UIView alloc]init];
    self.line_1.backgroundColor = MainColor;
    [self addSubview:_line_1];
    
    self.loginPassword = [[UITextField alloc]init];
    self.loginPassword.layer.cornerRadius = 6;
    self.loginPassword.backgroundColor = [UIColor whiteColor];
    [self.loginPassword setFont:[UIFont systemFontOfSize:15]];
    self.loginPassword.placeholder = @"请输入密码";
    self.loginPassword.secureTextEntry = YES;
    self.loginPassword.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *view_5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    view_5.backgroundColor = [UIColor clearColor];
    view_5.image = [UIImage imageNamed:@"密码"];
    self.loginPassword.leftView = view_5;
    [self addSubview:self.loginPassword];
    
    //密码下面的线
    self.line_2 = [[UIView alloc]init];
    self.line_2.backgroundColor = MainColor;
    [self addSubview:_line_2];
    
    //设置确认按钮
    self.confirmButton = [[UIButton alloc]init];
    [self.confirmButton setBackgroundColor:MainColor];
    [self.confirmButton setTitle:@"确 认" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.confirmButton];
    
    
    
    //执行自动布局方法
    [self AutoLayoutAllViews];
    
   
}

#pragma mark - 自动布局方法
- (void)AutoLayoutAllViews{
    //注册按钮的布局
    _registerButton.sd_layout.
    heightIs(50).
    widthIs(ScreenWidth/2).
    topSpaceToView(self, 10).
    leftEqualToView(self);
    
    //登陆按钮的布局
    _loginButton.sd_layout.
    heightRatioToView(_registerButton, 1).
    topEqualToView(_registerButton).
    leftSpaceToView(_registerButton, 0).
    widthIs(ScreenWidth/2);
    
    //按钮下的滑块布局
    _slider.sd_layout.
    topSpaceToView(_registerButton, 0).
    heightIs(1).
    widthIs(ScreenWidth/2);
    
    //注册账号框和注册密码1，注册密码2
    _regiAccount.sd_layout.
    topSpaceToView(_slider, 20).
    widthIs(ScreenWidth*5/6).
    autoHeightRatio(1/8.0);
    
    _regiPassword_1.sd_layout.
    topSpaceToView(_regiAccount, 10).
    leftEqualToView(_regiAccount).
    rightEqualToView(_regiAccount).
    heightRatioToView(_regiAccount, 1);
    
    _regiPassword_2.sd_layout.
    topSpaceToView(_regiPassword_1, 10).
    leftEqualToView(_regiAccount).
    rightEqualToView(_regiAccount).
    heightRatioToView(_regiAccount, 1);
    
    //登陆账号框
    _loginAccount.sd_layout.
    topSpaceToView(_slider, 20).
    widthIs(ScreenWidth*5/6).
    autoHeightRatio(1/8.0);
    
    //账号下的线
    _line_1.sd_layout.
    topSpaceToView(_loginAccount, 5).
    widthRatioToView(_loginAccount, 1).
    heightIs(0.5).leftEqualToView(_loginAccount);
    
    //登陆密码框
    _loginPassword.sd_layout.
    topSpaceToView(_loginAccount, 15).
    leftEqualToView(_loginAccount).
    rightEqualToView(_loginAccount).
    heightRatioToView(_loginAccount, 1);
    
    //密码下的线
    _line_2.sd_layout.
    topSpaceToView(_loginPassword, 5).
    widthRatioToView(_loginAccount, 1).
    heightIs(0.5).leftEqualToView(_loginAccount);
    
    //确认按钮
    _confirmButton.sd_layout.topSpaceToView(self.loginPassword, 50).centerXEqualToView(self).widthRatioToView(self, 0.6).autoHeightRatio(0.2);
    _confirmButton.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
    
    
   
    
}

- (void)slideringViewsWithButton: (UIButton*)button{
    //改变button颜色
    [button setTitleColor:MainColor forState:UIControlStateNormal];
    //将另一个button颜色调回
    if (self.loginButton==button) {
        [self.registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }

    //动画
    [UIView animateWithDuration:0.5 animations:^{
            //滑块的动画
        CGPoint center = self.slider.center;
        center.x = button.center.x;
        self.slider.center = center;
          
        
        //输入框的动画
            ///如果滑块是登陆按钮，且滑块在注册按钮下面
        if (self.loginButton==button&&self.inRegister) {
            self.inRegister = NO;
            
            CGPoint center_1 = self.regiAccount.center;
            CGPoint center_2 = self.regiPassword_1.center;
            CGPoint center_3 = self.regiPassword_2.center;
            CGPoint center_4 = self.loginAccount.center;
            CGPoint center_5 = self.loginPassword.center;
            CGPoint center_6 = self.confirmButton.center;
            CGPoint center_7 = self.line_1.center;
            CGPoint center_8 = self.line_2.center;
            center_1.x -= ScreenWidth;
            center_2.x -= ScreenWidth;
            center_3.x -= ScreenWidth;
            center_4.x -= ScreenWidth;
            center_5.x -= ScreenWidth;
            center_6.y -= 40;
            center_7.x -= ScreenWidth;
            center_8.x -= ScreenWidth;
            self.regiAccount.center = center_1;
            self.regiPassword_1.center = center_2;
            self.regiPassword_2.center = center_3;
            self.loginAccount.center = center_4;
            self.loginPassword.center = center_5;
            self.confirmButton.center = center_6;
            self.line_1.center = center_7;
            self.line_2.center = center_8;

            
            ///如果button是注册按钮，而且滑块不在注册按钮下面
        }else if(self.registerButton==button&&!self.inRegister){
            self.inRegister = YES;
            
            CGPoint center_1 = self.regiAccount.center;
            CGPoint center_2 = self.regiPassword_1.center;
            CGPoint center_3 = self.regiPassword_2.center;
            CGPoint center_4 = self.loginAccount.center;
            CGPoint center_5 = self.loginPassword.center;
            CGPoint center_6 = self.confirmButton.center;
            CGPoint center_7 = self.line_1.center;
            CGPoint center_8 = self.line_2.center;
            center_1.x += ScreenWidth;
            center_2.x += ScreenWidth;
            center_3.x += ScreenWidth;
            center_4.x += ScreenWidth;
            center_5.x += ScreenWidth;
            center_6.y += 40;
            center_7.x += ScreenWidth;
            center_8.x += ScreenWidth;
            self.regiAccount.center = center_1;
            self.regiPassword_1.center = center_2;
            self.regiPassword_2.center = center_3;
            self.loginAccount.center = center_4;
            self.loginPassword.center = center_5;
            self.confirmButton.center = center_6;
            self.line_1.center = center_7;
            self.line_2.center = center_8;

        }
       
    }completion:nil];
      
}

@end
