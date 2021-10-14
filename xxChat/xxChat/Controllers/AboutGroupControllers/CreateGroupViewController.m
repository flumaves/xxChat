//
//  CreateGroupViewController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/22.
//

#import "CreateGroupViewController.h"

@interface CreateGroupViewController ()

@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllViews];
    
}

#pragma mark - 懒加载
- (NSMutableArray*)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [[NSMutableArray alloc]init];
    }
    return _selectedArray;
}



- (void)setAllViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"创建群聊";
    
    //群名label
    CGFloat nameLabelX = 50;
    CGFloat nameLabelY = 150;
    CGFloat nameLabelW = 150;
    CGFloat nameLabelH = 30;
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH)];
    nameLabel.text = @"群名：";
    [self.view addSubview:nameLabel];

    //群名初始化
    CGFloat groupNameX = 50;
    CGFloat groupNameY = CGRectGetMaxY(nameLabel.frame)+5;
    CGFloat groupNameW = ScreenWidth-100;
    CGFloat groupNameH = 40;
    
    self.groupName = [[UITextField alloc]initWithFrame:CGRectMake(groupNameX, groupNameY, groupNameW, groupNameH)];
    self.groupName.placeholder = @"请输入群名";
    self.groupName.layer.borderWidth = 1;
    self.groupName.layer.borderColor = [MainColor CGColor];
    self.groupName.layer.cornerRadius = 4;
    [self.view addSubview:self.groupName];
    
    //一根线
    CGFloat lineX = 50;
    CGFloat lineY = CGRectGetMaxY(self.groupName.frame)+35;
    CGFloat lineW = ScreenWidth-100;
    CGFloat lineH = 1;
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    
    
    //群描述label
    CGFloat descriptionLabelX = 50;
    CGFloat descriptionLabelY = CGRectGetMaxY(self.groupName.frame)+50;
    CGFloat descriptionLabelW = 150;
    CGFloat descriptionLabelH = 30;
    
    UILabel* descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(descriptionLabelX, descriptionLabelY, descriptionLabelW, descriptionLabelH)];
    descriptionLabel.text = @"群描述：";
    [self.view addSubview:descriptionLabel];
    
    
    //群描述初始化
    CGFloat descriptionTVX = 50;
    CGFloat descriptionTVY = CGRectGetMaxY(descriptionLabel.frame)+5;
    CGFloat descriptionTVW = ScreenWidth-100;
    CGFloat descriptionTVH = 200;
    
    self.descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(descriptionTVX, descriptionTVY, descriptionTVW, descriptionTVH)];
    self.descriptionTextView.layer.borderWidth = 1;
    self.descriptionTextView.layer.borderColor = [MainColor CGColor];
    self.descriptionTextView.font = [UIFont systemFontOfSize:16];
    self.descriptionTextView.layer.cornerRadius = 4;
    [self.view addSubview:self.descriptionTextView];
    
    
    //确认btn
    CGFloat confirmBtnX = 100;
    CGFloat confirmBtnY = CGRectGetMaxY(self.descriptionTextView.frame)+30;
    CGFloat confirmBtnW = ScreenWidth-200;
    CGFloat confirmBtnH = 40;
    
    UIButton* confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(confirmBtnX, confirmBtnY, confirmBtnW, confirmBtnH)];
    confirmBtn.backgroundColor = MainColor;
    confirmBtn.layer.cornerRadius = 4;
    [confirmBtn setTitle:@"创 建" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmBtn addTarget:self action:@selector(confirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];


    
}

- (void)confirmBtn:(UIButton*)button {
    
    NSMutableArray* tempArray = [[NSMutableArray alloc]init];
    //遍历拿出username
    for (JMSGUser* user in self.selectedArray) {
        
        [tempArray addObject:user.username];
        
    }
    
    NSString* groupName = self.groupName.text;
    NSString* desc = self.descriptionTextView.text;
    
    [JMSGGroup createGroupWithName:groupName desc:desc memberArray:tempArray completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"CreatedGroup" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                //创建action
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    //遍历 然后pop到指定的controller
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                            if ([controller isKindOfClass:[GroupViewController class]]) {
                                GroupViewController *A =(GroupViewController *)controller;
                                     [self.navigationController popToViewController:A animated:YES];
                            }
                        }
                    
                }];
                
                [self showAlertViewWithMessage:@"创建成功" withAction:action];

            } else {
                NSLog(@"创建群组出错：%@",error);
            }
    }];
    
}
#pragma mark -展示提示框
//展示提示框block版本
-(void)showAlertViewWithMessage: (NSString *)message withAction: (UIAlertAction *)action {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
  [alertController addAction:action];
  [self presentViewController:alertController animated:YES completion:nil];
}

//展示提示框纯文字版本
-(void)showAlertViewWithMessage:(NSString *)message {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];

  [alertController addAction:cancelAction];
  [self presentViewController:alertController animated:YES completion:nil];
}


@end
