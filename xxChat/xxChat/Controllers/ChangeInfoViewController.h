//
//  ChangeInfoViewController.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/3.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeInfoViewController : UIViewController

@property (nonatomic, strong)NSString *infoType;

@property (nonatomic, strong)JMSGUser *user;

@end

NS_ASSUME_NONNULL_END
