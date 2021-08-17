//
//  xxChatDelegate.h
//  xxChat
//
//  Created by 谢恩平 on 2021/8/16.
//

#import <Foundation/Foundation.h>
enum AccountType {
    Register_Account, //完整的填好注册账号与密码
    Login_Account,    //完整的填好登陆账号和密码
    No_Account,       //缺少账号
    No_Password,      //缺少密码
    Password_NotEqual, //两次密码不相等
};

typedef enum AccountType AccountType;

NS_ASSUME_NONNULL_BEGIN

@protocol xxChatDelegate <NSObject>
- (void)passAccount: (NSString*)account WithPassword: (NSString*)password WithAccountType: (AccountType)type;


@end

NS_ASSUME_NONNULL_END
