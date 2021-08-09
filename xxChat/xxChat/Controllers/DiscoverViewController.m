//
//  DiscoverViewController.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/9.
//

#import "DiscoverViewController.h"

@interface DiscoverViewController () <UITableViewDataSource, UITableViewDelegate>

//加载朋友圈的tableView
@property (nonatomic, strong)UITableView *discoverTableView;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.discoverTableView];
}

- (UITableView *)discoverTableView {
    if (_discoverTableView == nil) {
        _discoverTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _discoverTableView.delegate = self;
        _discoverTableView.dataSource = self;
    }
    return _discoverTableView;
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
    NSString *ID = @"discover";
    
    UITableViewCell *cell = [self.discoverTableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = @"This is a discover";
    
    return cell;
}

@end
