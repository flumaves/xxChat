//
//  Message.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//


#import "Message.h"

@implementation Message

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)messageWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

//防止模型属性不足，程序崩溃的方法，用来跳过没有对应属性的key。
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    不用填东西的
}
@end
