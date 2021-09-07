//
//  Message.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMessage.h>

NS_ASSUME_NONNULL_BEGIN

///该模型用于封装消息
///提供给messageCell使用

typedef enum {
    MessageType_ME = 0, //自己发送的
    MessageType_Other   //别人发送的
} MessageType;

@interface Message : NSObject

//用户的userName (用来判断是谁发送的消息)
@property (nonatomic, strong) NSString *userName;

//消息
@property (nonatomic ,strong) JMSGMessage *message;

//正文 (JMSGContentTypeText 使用)
@property (nonatomic, strong) NSString *text;

//录音的秒数 (JMSGContentTypeVoice 使用）
@property (nonatomic, strong) NSNumber *duration;

//发布的时间戳
@property (nonatomic, strong) NSString *time;

//消息类型
@property (nonatomic, assign) MessageType type;

//是否显示时间
@property (nonatomic, assign) BOOL timeHidden;

+(instancetype)messageWithDict:(NSDictionary *)dict;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
