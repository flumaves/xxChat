//
//  VisitorViewController.m
//  xxChat
//
//  Created by 谢恩平 on 2021/8/16.
//

#import "VisitorViewController.h"
#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]


@interface VisitorViewController ()
//xxchat的logo
@property (nonatomic,strong) UIImageView *xxIcon;
//登陆与注册的view
@property (nonatomic,strong) LoginAndRegisterView *LARView;


@end

@implementation VisitorViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layOutView];
}

- (void)layOutView{
    self.view.backgroundColor = [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1];
    //初始化xxchat的logo
    self.xxIcon = [[UIImageView alloc]init];
    self.xxIcon.backgroundColor = [UIColor whiteColor];
//    self.xxIcon.size = CGSizeMake(200, 200);
    self.xxIcon.layer.cornerRadius = 50;
    [self.view addSubview:_xxIcon];
    
    //初始化登陆和注册的view
    self.LARView = [[LoginAndRegisterView alloc]init];
    [self.view addSubview:_LARView];
    
    //执行自动布局方法
    [self AutolayoutAllViews];
    
}

#pragma mark - 自动布局方法
- (void)AutolayoutAllViews{
    _xxIcon.sd_layout.
    topSpaceToView(self.view, 100).
    centerXEqualToView(self.view).
    widthIs(100).
    heightIs(100);
    
    _LARView.sd_layout.
    topSpaceToView(_xxIcon, 100).
    widthIs(ScreenWidth).
    bottomEqualToView(self.view);

}


@end
