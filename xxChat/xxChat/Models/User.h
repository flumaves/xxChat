/***************************************************
 
 
 
 
 ******************************************************/

#import <Foundation/Foundation.h>
#import <JMessage/JMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
///账号
@property (nonatomic,copy) NSString* account;
///密码
@property (nonatomic,copy) NSString* password;

//============================================  下面的可通过JMSUserInfo获取

///用户名
@property (nonatomic, strong) NSString* nickname;
///头像
@property (nonatomic, strong) NSData * avatarData;
///生日
@property (nonatomic, strong) NSNumber *birthday;


///字典转模型方法
+ (instancetype)userWithDic: (NSDictionary*)dic;

///模型转字典方法
+ (NSDictionary*)dicWithUser: (User*)user;

///字典数组转模型数组方法
+ (NSArray*)usersArrayWithDictionaryArray: (NSArray*)dicArray;

@end

NS_ASSUME_NONNULL_END
