//
//  MeViewController.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/9.
//

#import "MeViewController.h"

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate>

//加载个人列表的tableView
@property (nonatomic, strong)UITableView *meTableView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.meTableView];
}

- (UITableView *)meTableView {
    if (_meTableView == nil) {
        _meTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _meTableView.delegate = self;
        _meTableView.dataSource = self;
    }
    return _meTableView;
}

#pragma mark -tableView的 dataSource 和 delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //复用ID为 chat
    NSString *ID = @"chat";
    
    UITableViewCell *cell = [self.meTableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = @"This is a cell";
    
    return cell;
}

@end
