//
//  SelectUserForGroupController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/18.
//

#import "SelectUserForGroupController.h"

@interface SelectUserForGroupController ()<UITableViewDelegate,UITableViewDataSource,JMessageDelegate>

@end

@implementation SelectUserForGroupController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAllView];
    //获取列表
    if (self.sectionTitleArray.count == 0) {
        [self getFriendsList];
        
    } else {
        
        [self.tableView reloadData];
    }
        
}
#pragma mark - 懒加载
- (NSMutableArray*)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [[NSMutableArray alloc]init];
    }
    return _selectedArray;
}
- (NSMutableArray*)sectionTitleArray {
    if (_sectionTitleArray == nil) {
        _sectionTitleArray = [[NSMutableArray alloc]init];
    }
    return _sectionTitleArray;
}
- (NSMutableArray*)friendsListArray{
    if (_friendsListArray == nil) {
        _friendsListArray = [[NSMutableArray alloc]init];
    }
    return _friendsListArray;
}
- (UITableView*)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (void)setAllView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发起群聊";
    [self.view addSubview:self.tableView];
    //编辑状态为yes
    self.tableView.editing = YES;
    
    //底部的view
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height- 60, self.view.frame.size.width, 60)];

    _baseView.backgroundColor = [UIColor grayColor];

    [self.view addSubview:_baseView];
    
    //完成按钮
     _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.backgroundColor = MainColor;
        [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
    _confirmButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.enabled = YES;
    [_baseView addSubview:_confirmButton];
}




#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray* tempArray = self.friendsListArray[section];
    
    return tempArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //复用ID为 contact
    NSString *ID = @"contact";
    ContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //头像
    CGFloat iconX = 50;
    CGFloat iconY = 10;
    CGFloat iconL = 35;
    [cell.icon setFrame:CGRectMake(iconX, iconY, iconL, iconL)];
    
    //名称
    CGFloat nameX = CGRectGetMaxX(cell.icon.frame) + 50;
    CGFloat nameY = iconY + 8;
    CGFloat nameW = 150;
    CGFloat nameH = 20;
    [cell.name setFrame:CGRectMake(nameX, nameY, nameW, nameH)];
    
    
    //拿到对应首字母的那一部分user
    NSMutableArray* tempArray = self.friendsListArray[indexPath.section];
    
    JMSGUser *user = tempArray[indexPath.row];
    
    //设名字
    cell.name.text = user.nickname;
    //头像
    if (user.avatar != nil) {
        
        [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
            if (!error) {
                
                cell.icon.image = [UIImage imageWithData:data];

            } else {
                
                NSLog(@"选择列表的cell获取头像出现错误：%@",error);
                
            }
        }];
        
    } else {
        
        cell.icon.image = nil;
        
    }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
//每个section的headerView样式
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    //获取首字母
    NSString* firstLetter = [NSString stringWithFormat: @"       %@", self.sectionTitleArray[section]];
    
    UILabel* headerView = [[UILabel alloc]init];
    headerView.backgroundColor =[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    headerView.font = [UIFont systemFontOfSize:13];
    headerView.textAlignment = NSTextAlignmentLeft;
    headerView.text = firstLetter;
    
    
    return headerView;

}

//右侧字母索引数组代理
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionTitleArray;
}
//每个索引字被点击时的方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return index;
}




//是否可以编辑  默认的时YES

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

return YES;

}



//选择要对表进行处理的方式  默认是删除方式

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

return UITableViewCellEditingStyleDelete;

}

//选中时将选中行的在friendlistarray 中的数据添加到selectedarray中

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选择");
    //传user信息。
    NSMutableArray* tempArray = self.friendsListArray[indexPath.section];
    [self.selectedArray addObject:tempArray[indexPath.row]];

}

//取消选中时 将存放在self.selectedArray中的数据移除

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    NSLog(@"取消选择");
    NSMutableArray* tempArray = self.friendsListArray[indexPath.section];
    [self.selectedArray removeObject:tempArray[indexPath.row]];

}



//点击完成按钮
- (void)confirmClick:(UIButton *) button {
    if (self.selectedArray.count != 0) {
        
        CreateGroupViewController* createGroupVC = [[CreateGroupViewController alloc]init];
        //赋选出来的数组
        createGroupVC.selectedArray = self.selectedArray;
        
        [self.navigationController pushViewController:createGroupVC animated:YES];
        
    } else {
        
        [self showAlertViewWithMessage:@"还未选择好友"];
        
    }
    
    

}
#pragma mark - 获取朋友列表
- (void)getFriendsList{
    [JMSGFriendManager getFriendList:^(id resultObject, NSError *error) {
        if (!error) {
            self.friendsListArray = [NSMutableArray arrayWithArray:resultObject];
            self.friendsListArray = [self sortingContactsWithArray:self.friendsListArray];
            [self.tableView reloadData];
        }else{
            NSLog(@"获取朋友列表出现错误：%@",error);
        }
    }];
}

#pragma mark - 联系人排序
- (NSMutableArray*)sortingContactsWithArray:(NSMutableArray*)mutArray {
    //先清空section title数组
    [self.sectionTitleArray removeAllObjects];
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    //复制一份mutArray
    NSMutableArray* tempMutArray = [NSMutableArray arrayWithArray:mutArray];
    for (int i = 'A'; i <= 'Z'; i++) {
        
        NSMutableArray* userForSectionArray = [[NSMutableArray alloc]init];
        
        NSString* firstLetter = [NSString stringWithFormat:@"%c", i];
        
        
        for ( JMSGUser* user in mutArray ) {
            
            
            NSString* nickname = [NSString stringWithFormat:@"%@", user.nickname];
            //将中文转拼音
            nickname = [nickname getPinyin];
            //将小写转换成大写
            nickname = [nickname uppercaseString];
            //获取首字母 (第一个字符是空格，所以下标取1才能得到首字母)
            nickname = [nickname substringToIndex:1];
            
            //如果字母相等，加进数组中
            if ([nickname isEqualToString:firstLetter]) {
                
                [userForSectionArray addObject:user];
                //在原数组中删除掉该元素，那么原数组最后就会剩下一些无法识别的名字，再统一加入“#”组
                [tempMutArray removeObject:user];
                
            }
            
            
        }
        //如果这个数组不为空，那么证明这个首字母有用到，所以将这个首字母加入section title数组
        //同时将该部分联系人数组，加进总的数组中，形成二维数组。
        if (userForSectionArray.count != 0) {
            [self.sectionTitleArray addObject:firstLetter];
            [array addObject:userForSectionArray];
        }
            
        
    }
    
    //如果原数组不为空，那么必然有无法识别的名字,全部归类于#
    if (tempMutArray.count != 0) {
        [array addObject:tempMutArray];
        [self.sectionTitleArray addObject:@"#"];
    }
    
    
    
    return array;
}

#pragma mark -展示提示框
//展示提示框
-(void)showAlertViewWithMessage: (NSString*)message {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     
    }];

  [alertController addAction:cancelAction];
  [self presentViewController:alertController animated:YES completion:nil];
}


@end


