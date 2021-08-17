//
//  SceneDelegate.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/7.
//

#import "SceneDelegate.h"

#import "ChatsViewController.h"
#import "ContactsViewController.h"
#import "DiscoverViewController.h"
#import "MeViewController.h"
#import "VisitorViewController.h"
#import "User.h"

@interface SceneDelegate ()

//消息界面
@property (nonatomic, strong)ChatsViewController *chatsViewController;

//联系人界面
@property (nonatomic, strong)ContactsViewController *contactsViewController;

//朋友圈界面
@property (nonatomic, strong)DiscoverViewController *discoverViewController;

//个人界面
@property (nonatomic, strong)MeViewController *meViewController;

//是否已经登陆
@property (nonatomic) BOOL didLogin;

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    //加载tabBarController和childViewController
    [self loadViewControllers];
    
    [self.window makeKeyAndVisible];
}

///加载页面的方法的简单封装
- (void)loadViewControllers {
    //判断是否登陆
    if (!_didLogin){
        //创建最外层的 tabBarController
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        //把每个界面控制器添加到 tabBarController 中
        [self addChildControllersToTabBarController:tabBarController];
        //tabBar渲染的颜色
        tabBarController.tabBar.tintColor = [UIColor colorWithRed:50 /255.0 green:205 /255.0 blue:50 / 255.0 alpha:1];

        self.window.rootViewController = tabBarController;
    }else{
        VisitorViewController *visitorViewController = [[VisitorViewController alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:visitorViewController];
        
        self.window.rootViewController = nav;
        
    }
}

//为tabBarController添加控制器
- (void)addChildControllersToTabBarController:(UITabBarController *)tabBar {
    //消息界面
    _chatsViewController = [[ChatsViewController alloc] init];
    [self tabBarController:tabBar addChildViewController:_chatsViewController withTitle:@"聊天" withImageName:@"聊天"];
    //联系人界面
    _contactsViewController = [[ContactsViewController alloc] init];
    [self tabBarController:tabBar addChildViewController:_contactsViewController withTitle:@"联系人" withImageName:@"联系人"];
    
    //朋友圈界面
    _discoverViewController = [[DiscoverViewController alloc] init];
    [self tabBarController:tabBar addChildViewController:_discoverViewController withTitle:@"朋友圈" withImageName:@"朋友圈"];
    
    //个人界面
    _meViewController = [[MeViewController alloc] init];
    [self tabBarController:tabBar addChildViewController:_meViewController withTitle:@"我" withImageName:@"我"];
}

//每个界面控制器添加导航栏 设置在tabBar上的title和图片
- (void)tabBarController:(UITabBarController *)tabBarController
  addChildViewController:(UIViewController *)viewController
               withTitle:(NSString *)title
           withImageName:(NSString *)imageName {
    //创建导航栏
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    //设置标题 图片
    viewController.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:imageName];
    
    [tabBarController addChildViewController:nav];
}

@end
