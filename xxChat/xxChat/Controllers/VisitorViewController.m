//
//  VisitorViewController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/8/16.
//

#import "VisitorViewController.h"
#import "User.h"
#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]


@interface VisitorViewController ()<xxChatDelegate>
//xxchat的logo
@property (nonatomic,strong) UIImageView *xxIcon;
//登陆与注册的view
@property (nonatomic,strong) LoginAndRegisterView *LARView;
//本地保存的登陆记录
@property (nonatomic,strong) NSMutableArray *didLoginArray;


@end

@implementation VisitorViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllViews];
    [self setData];
}

///懒加载
-(NSMutableArray*)didLoginArray
{
    if(_didLoginArray==nil){
        _didLoginArray = [[NSMutableArray alloc]init];
    }
    return _didLoginArray;
}

- (void)setAllViews{
    self.view.backgroundColor = [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1];
    //初始化xxchat的logo
    self.xxIcon = [[UIImageView alloc]init];
    self.xxIcon.backgroundColor = [UIColor whiteColor];
//    self.xxIcon.size = CGSizeMake(200, 200);
//    self.xxIcon.layer.cornerRadius = 50;
    [self.view addSubview:_xxIcon];
    
    //初始化登陆和注册的view
    self.LARView = [[LoginAndRegisterView alloc]init];
    self.LARView.delegate = self;
    [self.view addSubview:_LARView];
    
    //执行自动布局方法
    [self autolayoutAllViews];
    
}

#pragma mark - 自动布局方法
- (void)autolayoutAllViews{
    _xxIcon.sd_layout.
    topSpaceToView(self.view, 100).
    centerXEqualToView(self.view).
    widthIs(100).
    heightIs(100);
    _xxIcon.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
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
  if (type == Register_Account) {
    //注册账号
      [JMSGUser registerWithUsername:account password:password completionHandler:^(id resultObject, NSError *error) {
          if (!error) {
              
              [self showAlertViewWithMessage:@"注册成功QAQ"];
              self.LARView.regiAccount.text = @"";
              self.LARView.regiPassword_2.text = @"";
              self.LARView.regiPassword_1.text = @"";
              
          }else {
              
              NSString* errorStr = [NSString stringWithFormat:@"%@",error];
              
              if ([errorStr containsString:@"user exist"]){//如果错误里面包含这个字符串
                  
                  [self showAlertViewWithMessage:@"用户已存在"];
                  
              }
              NSLog(@"注册账号出现错误：%@",error);
              
          }
      }];
      
  }else if (type == Login_Account) {
      //登陆账号
      [JMSGUser loginWithUsername:account password:password completionHandler:^(id resultObject, NSError *error) {
          
          if (!error){//如果错误为空，即登陆成功
              
              //搜索登陆记录，有前科就把它删掉
              [self searchingAndUpdateUserArrayWithAccount:account];
              //记录登陆信息
              [self recordingLoginInfoWithAccount:account WithPassword:password];

              //监听已经登陆,让scene delegate跳转页面
              [[NSNotificationCenter defaultCenter]postNotificationName:@"FinishLogin" object:self];
              
          }else{
              
              NSString* errorStr = [NSString stringWithFormat:@"%@",error];
              
              if ([errorStr containsString:@"invalid password"]){//如果错误里面包含这个字符串
                  
                  [self showAlertViewWithMessage:@"账号或密码错误"];
                  
              }
              NSLog(@"登陆失败：%@",error);
              
          }
      }];
    
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

- (void)changePassword{
    [self.navigationController pushViewController:[[ChangePasswordViewController alloc]init] animated:YES];
}

#pragma mark - 设置一些一开始的数据
- (void)setData{
    //设置上次登陆的账号在登陆界面中
    NSMutableArray* dicArray = [User getDictionaryFromPlistWithFileName:@"Users"];
    self.didLoginArray = [User usersArrayWithDictionaryArray:dicArray];
    if (self.didLoginArray.count!=0){
        User *user = self.didLoginArray[self.didLoginArray.count-1];
        self.LARView.loginAccount.text = user.account;
        //暂时为了方便登陆先把密码加进去，以后删除
        self.LARView.loginPassword.text = user.password;
    }
}

//将最新的登陆信息存在本地
- (void)recordingLoginInfoWithAccount:(NSString*)account WithPassword:(NSString*)password{
    User *user = [[User alloc]init];
    user.account = account;
    user.password = password;
    [self.didLoginArray addObject:user];
    NSMutableArray *array = [User dicsArrayWithUserArray:self.didLoginArray];
    [User writeToFileWithUsersDicArray:array AndFileName:@"Users"];
}

//搜索是否有登陆记录，有就删掉
- (void)searchingAndUpdateUserArrayWithAccount:(NSString*)account{
    //指定过滤条件：数组中的实例的account属性是否包含account
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"account CONTAINS %@", account];
    //获取过滤出来的数据
    NSMutableArray* array = [NSMutableArray arrayWithArray:[self.didLoginArray filteredArrayUsingPredicate:predicate]];
    //如果过滤出来的数组不为0
    if (array.count!=0){
        NSUInteger index = 0;
        //遍历数组找相同
        for (NSUInteger i=0; i<self.didLoginArray.count;i++ ) {
            User *user = self.didLoginArray[i];
            if ([user.account isEqualToString:account]) {
                index = i;
                break;
            }
        }
        //删除指定下标的元素
        [self.didLoginArray removeObjectAtIndex:index];
    }

}

@end
