//
//  ChangeInfoViewController.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/18.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeInfoViewController : UIViewController

@property (nonatomic, strong)NSString *infoType;

@property (nonatomic, strong)JMSGUser *user;

@end

NS_ASSUME_NONNULL_END
