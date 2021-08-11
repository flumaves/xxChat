//
//  MeViewController.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/9.
//

#import "MeViewController.h"

#import "InformationCell.h"

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate>

//加载个人列表的tableView
@property (nonatomic, strong)UITableView *meTableView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.meTableView];
}

- (UITableView *)meTableView {
    if (_meTableView == nil) {
        _meTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _meTableView.delegate = self;
        _meTableView.dataSource = self;
        
        _meTableView.tableFooterView = [[UIView alloc] init];
    }
    return _meTableView;
}

#pragma mark -tableView的 dataSource 和 delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //静态的tableView
    if (indexPath.section == 0) {
        InformationCell *cell = [[InformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"设置"];
        cell.textLabel.text = @"设定";
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 140;
    } else {
        return 50;
    }
}

@end
