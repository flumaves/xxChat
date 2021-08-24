//
//  Message.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//


#import "Message.h"

@implementation Message

///在设置JMSGMessage的时候 就分析JMSGMessage并对属性进行设置
- (void)setMessage:(JMSGMessage *)message {
    _message = message;
    
    //判断消息的类型
    JMSGTextContent *textContent =  (JMSGTextContent *)message.content;
    _text = textContent.text;
    //判断是谁发送的消息
    JMSGUser *user = message.target;    //获取消息发送的对象
    if (_userName != user.username) {
        //发送的目标不是自己 （即自己发的消息）
        _type = MessageType_ME;
    } else {
        _type = MessageType_Other;
    }
    //时间
    NSNumber *timer = message.timestamp;
    NSTimeInterval interval = [timer doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    //设置日期格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *str = [formatter stringFromDate:date];
    _time = str;
}

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
