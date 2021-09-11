//
//  ChangeInfoViewController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/3.
//

#import "ChangeInfoViewController.h"

@interface ChangeInfoViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
///紧挨一起的表示会在同一个view中出现
@property (nonatomic, strong)UIImageView *iconImageView;//头像

@property (nonatomic, strong)UITextField *textField;    //名字

@property (nonatomic, strong)UIDatePicker *datePicker;  //生日

@property (nonatomic, strong)UITableView *genderTableView; //性别
@property (nonatomic, strong)NSIndexPath *selectedIndexPath;//选中的cell

@property (nonatomic, strong)UITextView *textView;      //签名
@property (nonatomic, strong)UILabel *countLbl;         //字数限制label

@end

#define MAXSIGNLENGTH 60

@implementation ChangeInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatView];
}


#pragma mark - 加载页面
- (void)creatView {
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    //放在navigationBar后面的背景view
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    backgroundView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    [self.view addSubview:backgroundView];
    
    //右侧的确定按钮
    //头像的要另外设置一个样式
    if ([_infoType isEqual:@"头像"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"省略号"] style:UIBarButtonItemStyleDone target:self action:@selector(changeImage)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(changeInfomation)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    }
    
    //左侧的返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //判断infotype 来加载具体的页面内容
    //infotype -> @"头像"  @"名字"  @"性别"  @"生日"  @"地区"  @"签名"
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat navigationBarMAXY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    ///头像
    if ([_infoType isEqual:@"头像"]) {
        //修改view的背景颜色
        self.view.backgroundColor = [UIColor whiteColor];
        
        CGFloat width = screenWidth;
        CGFloat x = 0;
        CGFloat y = ([UIScreen mainScreen].bounds.size.height - width) / 2;
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
        _iconImageView.backgroundColor = [UIColor blackColor];
        //获取头像数据
        [_user largeAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
            self.iconImageView.image = [UIImage imageWithData:data];
        }];
        [self.view addSubview:_iconImageView];
    
    ///名称
    } else if ([_infoType isEqual:@"名字"]) { //nickName
        CGFloat x = 0;
        CGFloat y = navigationBarMAXY + 10;
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, screenWidth, 50)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.text = _user.nickname;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:_textField];
    
    ///性别
    } else if ([_infoType isEqual:@"性别"]) { //gender
        CGFloat x = 0;
        CGFloat y = navigationBarMAXY;
        CGFloat height = self.view.frame.size.height - navigationBarMAXY;
        _genderTableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, screenWidth, height)];
        _genderTableView.delegate = self;
        _genderTableView.dataSource = self;
        _genderTableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_genderTableView];
        
        if (_user.gender == kJMSGUserGenderMale) {
            _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        } else if (_user.gender == kJMSGUserGenderFemale) {
            _selectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        }
        
    ///生日
    } else if ([_infoType isEqual:@"生日"]){
        CGFloat x = 0;
        CGFloat y = navigationBarMAXY;
        CGFloat width = screenWidth;
        CGFloat height = 216;
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        _datePicker.frame = CGRectMake(x, y, width, height);
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];    //设置为中文
        _datePicker.backgroundColor = [UIColor whiteColor];
        //将NSString转成NSDate
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //NSString转NSDate
        NSDate *date = [formatter dateFromString:_user.birthday];
        _datePicker.date = date;
        //添加监听
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_datePicker];
        
    ///地址
    } else if ([_infoType isEqual:@"地区"]) { //address
        
    ///签名
    } else if ([_infoType isEqual:@"签名"]){  //signature
        CGFloat x = 0;
        CGFloat y = navigationBarMAXY;
        CGFloat width = screenWidth;
        CGFloat height = 200;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _textView.delegate = self;
        _textView.text = _user.signature;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:15];
        UIEdgeInsets insets = UIEdgeInsetsMake(30, 30, 30, 30);
        _textView.textContainerInset = insets;
        [self.view addSubview:_textView];
        
        //字数限制的小lbl
        width = 20;
        x = screenWidth - 10 - width;
        y = CGRectGetMaxY(_textView.frame) - 10 -width;
        _countLbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, width)];
        _countLbl.textColor = [UIColor grayColor];
        _countLbl.font = [UIFont systemFontOfSize:12];
        //剩余可输入字数
        NSUInteger lbl = MAXSIGNLENGTH - _textView.text.length;
        _countLbl.text = [NSString stringWithFormat:@"%lu",lbl];
        [self.view addSubview:_countLbl];
    }
}


#pragma mark - 签名的textView的delegate
- (void)textViewDidChange:(UITextView *)textView {
    //剩余可输入字数
    NSUInteger lbl = MAXSIGNLENGTH - _textView.text.length;
    _countLbl.text = [NSString stringWithFormat:@"%lu",lbl];
}

#pragma mark - 生日的datePick 的监听方法
- (void)dateChange:(UIDatePicker *)datePicker {
    NSDate *birthday = _datePicker.date;
    //判断数据的合理性
    //超过了现在的时间
    NSDate *now = [NSDate date];
    NSComparisonResult result = [now compare:birthday];
    if (result == NSOrderedAscending) {
        [datePicker setDate:now animated:YES];
    }
}

#pragma mark - 性别的tableview 的delegate 和datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //在cell的右边添加一个 ✅
    CGFloat width = 30;
    CGFloat y = 10;
    CGFloat x = [UIScreen mainScreen].bounds.size.width - 10 - width;
    UIImageView *pickImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
    pickImgView.image = [UIImage imageNamed:@"对勾"];
    pickImgView.hidden = YES;
    [cell.contentView addSubview:pickImgView];
    
    if ([indexPath isEqual:_selectedIndexPath]) {   //让选中的cell显示✅
        pickImgView.hidden = NO;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"男";
    } else {
        cell.textLabel.text = @"女";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //记录选中的cell 重新刷新tableview
    _selectedIndexPath = indexPath;
    [_genderTableView reloadData];
}


#pragma mark - 修改头像
- (void)changeImage {
    UIAlertController *actionSheet = [[UIAlertController alloc] init];
    //添加按钮
    UIAlertAction *action_1 = [UIAlertAction actionWithTitle:@"从相册选择(未开放)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        imagePicker.delegate = self;
//        imagePicker.allowsEditing = YES;
//        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:imagePicker animated:YES completion:nil];

        
    ///由于选择相片过程中 NSURL为nil 设置默认的头像
        UIImage *image = [UIImage imageNamed:@"头像素材01"];
        NSData *imageData = UIImageJPEGRepresentation(image,1.0f);
        [self updataAvatarWithData:imageData];
    }];
    [actionSheet addAction:action_1];
    
    UIAlertAction *action_2 = [UIAlertAction actionWithTitle:@"拍照（未开放）" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        imagePicker.delegate = self;
//        imagePicker.allowsEditing = YES;
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    [actionSheet addAction:action_2];
    
    UIAlertAction *action_3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheet addAction:action_3];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}


#pragma mark - imagePicker 的delegate
//选完照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSLog(@"选完照片了");
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqual:@"public.image"]) {
        UIImage *image = info[UIImagePickerControllerEditedImage];
        _iconImageView.image = image;
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

//关闭
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 修改个人信息 (不包括头像)
- (void)changeInfomation {
    [self.view endEditing:YES];
    
    //获取原本的用户信息
    JMSGUserInfo *userInfo = [[JMSGUserInfo alloc] init];
    userInfo.nickname = _user.nickname;
    userInfo.gender = _user.gender;
    userInfo.birthday = @([_user.birthday doubleValue]);//这里应该是JMSUser的错误 把birthday属性设置成了NSString 但文档中规定是NSNumber
    userInfo.address = _user.address;
    userInfo.signature = _user.signature;
    
    if ([_infoType isEqual:@"名字"]) { ///nickName
        NSString *nickName = _textField.text;
        userInfo.nickname = nickName;
      
    } else if ([_infoType isEqual:@"性别"]) { ///gender
        UITableViewCell *cell = [_genderTableView cellForRowAtIndexPath:_selectedIndexPath];
        if ([cell.textLabel.text isEqual:@"男"]) {
            userInfo.gender = kJMSGUserGenderMale;
        } else {
            userInfo.gender = kJMSGUserGenderFemale;
        }
        
    } else if ([_infoType isEqual:@"生日"]){  ///birthday
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSTimeInterval birthdayInterval = [_datePicker.date timeIntervalSince1970];
        NSNumber *birthday = [NSNumber numberWithDouble:birthdayInterval] ;
        //修改属性
        userInfo.birthday = birthday;
        
    } else if ([_infoType isEqual:@"地区"]) { ///address
        
    } else if ([_infoType isEqual:@"签名"]){  ///signature
        NSString *signature = _textView.text;
        userInfo.signature = signature;
    }
    
    //修改用户信息
    [JMSGUser updateMyInfoWithUserInfo:userInfo completionHandler:^(id resultObject, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}


#pragma mark - 更新头像
- (void)updataAvatarWithData:(NSData *)avatarData {
    [JMSGUser updateMyAvatarWithData:avatarData avatarFormat:@"" completionHandler:^(id resultObject, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:error ? @"修改失败" : @"修改成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    self.iconImageView.image = [UIImage imageWithData:avatarData];
}


#pragma mark - 返回
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
