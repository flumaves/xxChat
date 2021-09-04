//
//  User.m
//  xxChat
//
//  Created by 谢恩平 on 2021/8/9.
//

#import "User.h"

@implementation User

#pragma mark - 字典转模型
//字典转模型的方法
- (instancetype)initWithDic: (NSDictionary*)dic
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return  self;
}

///字典转模型的类方法
+ (instancetype)userWithDic: (NSDictionary*)dic
{
    return [[self alloc]initWithDic:dic];
}

//防止模型属性不足，程序崩溃的方法，用来跳过没有对应属性的key。
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    不用填东西的
}

#pragma mark - 模型转字典
+ (NSDictionary*)dicWithUser:(User *)user
{
 
    NSMutableDictionary* tempDic = [[NSMutableDictionary alloc]init];
    //给字典设键和值
    [tempDic setValue:user.account forKey:@"account"];
    [tempDic setValue:user.password forKey:@"password"];
    [tempDic setValue:user.nickname forKey:@"nickName"];
    [tempDic setValue:user.birthday forKey:@"birthday"];

    //将可变字典转成普通字典返回
    NSDictionary* dic = tempDic;
    return dic;
}

#pragma mark - 字典数组转模型数组
+ (NSMutableArray*)usersArrayWithDictionaryArray: (NSMutableArray*)dicArray
{
    
    NSMutableArray* tempArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary* userDic in dicArray)
    {
        [tempArray addObject: [User userWithDic:userDic]];
    }
    return tempArray;
}

#pragma mark - 模型数组转字典数组
+ (NSMutableArray*)dicsArrayWithUserArray: (NSMutableArray*)userArray
{
    
    NSMutableArray* tempArray = [[NSMutableArray alloc]init];
    
    for (User* user in userArray)
    {
        [tempArray addObject: [User dicWithUser:user]];
    }
    return tempArray;
}

#pragma  mark - 将数组写入本地的方法
+ (void) writeToFileWithUsersDicArray:(NSMutableArray*)mutArray AndFileName:(NSString*)name
{
   NSArray* array = mutArray;
   NSString* docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];//返回的是一个文件数组
   NSString* filepath = [docpath stringByAppendingPathComponent:name];
   [array writeToFile:filepath atomically:YES];
}

#pragma mark - 从本地拿字典数组
+ (NSMutableArray*)getDictionaryFromPlistWithFileName:(NSString*)name
{
    NSString* docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* filepath = [docpath stringByAppendingPathComponent:name];
    NSMutableArray* array = [NSMutableArray arrayWithContentsOfFile:filepath];
    
    return array;
}


@end
