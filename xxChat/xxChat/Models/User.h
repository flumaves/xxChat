/***************************************************
 
 
 
 
 ******************************************************/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
///账号
@property (nonatomic,copy) NSString* account;
///密码
@property (nonatomic,copy) NSString* password;
///用户名
@property (nonatomic,copy) NSString* userName;
///头像URLString
@property (nonatomic,copy) NSString* profilePicURLStr;


///字典转模型方法
+ (instancetype)userWithDic: (NSDictionary*)dic;

///模型转字典方法
+ (NSDictionary*)dicWithUser: (User*)user;

///字典数组转模型数组方法
+ (NSArray*)usersArrayWithDictionaryArray: (NSArray*)dicArray;



@end

NS_ASSUME_NONNULL_END
