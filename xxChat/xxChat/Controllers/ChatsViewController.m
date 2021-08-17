//
//  MessageViewController.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/7.
//

#import "ChatsViewController.h"
#import "ChatCell.h"
#import "MessageViewController.h"

@interface ChatsViewController () <UITableViewDataSource, UITableViewDelegate>

//加载会话列表的tableView
@property (nonatomic, strong)UITableView *chatTableView;

@end

@implementation ChatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.chatTableView];
    
}

- (UITableView *)chatTableView {
    if (_chatTableView == nil) {
        _chatTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
    }
    return _chatTableView;
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
    
    ChatCell *cell = [self.chatTableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    MessageViewController *controller = [[MessageViewController alloc] init];
    controller.title = cell.name.text;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
