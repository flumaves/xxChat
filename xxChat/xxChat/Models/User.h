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
///昵称
@property (nonatomic,copy) NSString* nickname;
///头像数据
@property (nonatomic,copy) NSString* birthday;

///字典转模型方法
+ (instancetype)userWithDic: (NSDictionary*)dic;

///模型转字典方法
+ (NSDictionary*)dicWithUser: (User*)user;

///字典数组转模型数组方法
+ (NSMutableArray*)usersArrayWithDictionaryArray: (NSMutableArray*)dicArray;

///模型数组转字典数组方法
+ (NSMutableArray*)dicsArrayWithUserArray: (NSMutableArray*)userArray;

///写入本地
+ (void) writeToFileWithUsersDicArray:(NSMutableArray*)mutArray AndFileName:(NSString*)name;

///在本地取出
+ (NSMutableArray*)getDictionaryFromPlistWithFileName:(NSString*)name;

@end

NS_ASSUME_NONNULL_END
