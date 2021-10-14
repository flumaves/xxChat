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
    if (message.contentType == kJMSGContentTypeText) {
        JMSGTextContent *textContent =  (JMSGTextContent *)message.content;
        _text = textContent.text;
    }
    if (message.contentType == kJMSGContentTypeVoice) {
        JMSGVoiceContent *voiceContent = (JMSGVoiceContent *)message.content;
        _duration = voiceContent.duration;
    }
    if (message.contentType == kJMSGContentTypeImage) {
        JMSGImageContent *imageContent = (JMSGImageContent *)message.content;
        _imageLink = imageContent.imageLink;
        _imageSize = imageContent.imageSize;
    }
    
    //判断是谁发送的消息
    JMSGUser *user = message.fromUser;
    if (user.username == _userName) {
        _type = MessageType_ME;
    } else {
        _type = MessageType_Other;
    }
    
    //时间
    //获取当天00：00的时间戳
    NSTimeInterval todayInterval = [self getTimeofHour:0 minute:0];                 //今天
    NSTimeInterval yesterdayInterval = todayInterval - 24 * 60 * 60;                //昨天
    NSTimeInterval dayBeforeYesterdayInterval = yesterdayInterval - 24 * 60 * 60;   //前天
    NSTimeInterval lastweekInterval = todayInterval - 7 * 24 * 60 * 60;             //上星期
    //消息发送的时间戳
    NSNumber *timer = message.timestamp;
    NSTimeInterval interval = [timer doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    //设置日期格式
    if (interval > todayInterval) {     //当天发送的消息
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *str = [formatter stringFromDate:date];
        _time = str;
        
    } else if (interval > yesterdayInterval) {  //昨天发送到消息
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *str = [@"昨天 " stringByAppendingFormat:@"%@",[formatter stringFromDate:date]];
        _time = str;
        
    } else if (interval > dayBeforeYesterdayInterval) { //前天发送的消息
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *str = [@"前天 " stringByAppendingFormat:@"%@",[formatter stringFromDate:date]];
        _time = str;
        
    } else if (interval > lastweekInterval) {   //这星期内发送的消息
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"eeee HH:mm"];
        NSString *str = [formatter stringFromDate:date];
        _time = str;
        
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M-dd HH:mm"];
        NSString *str = [formatter stringFromDate:date];
        _time = str;
    }
}


- (NSTimeInterval)getTimeofHour:(NSInteger)hour minute:(NSInteger)minute {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone:timeZone];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    dateComponentsForDate.day   = dateComponents.day;
    dateComponentsForDate.month = dateComponents.month;
    dateComponentsForDate.year  = dateComponents.year;
    dateComponentsForDate.hour  = hour;
    dateComponentsForDate.minute = minute;
    
    NSDate *dateFromDateComponentsForDate = [calendar dateFromComponents:dateComponentsForDate];
    NSTimeInterval interval = [dateFromDateComponentsForDate timeIntervalSince1970];
    return interval;
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
