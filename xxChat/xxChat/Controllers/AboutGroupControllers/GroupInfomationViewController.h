//
//  GroupInfomationViewController.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/16.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupInfomationViewController : UIViewController

//group信息
@property (nonatomic, strong) JMSGGroup* group;

//储存会话列表 （array中是 JMSGConversation）
@property (nonatomic, strong)NSMutableArray *conversationsArray;
@end

NS_ASSUME_NONNULL_END
