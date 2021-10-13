//
//  GroupNotificationViewController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/22.
//

#import "GroupNotificationViewController.h"

@interface GroupNotificationViewController ()

@end

@implementation GroupNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllViews];
}

- (void)setAllViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"群通知(没有公开群，写个寂寞)";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
