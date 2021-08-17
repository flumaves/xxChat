//
//  Message.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///该模型用于封装消息
///提供给messageCell使用

typedef enum {
    MessageType_ME = 0,
    MessageType_Other
} MessageType;

@interface Message : NSObject

//正文
@property (nonatomic, strong)NSString *text;

//时间
@property (nonatomic, strong)NSString *time;

//消息类型
@property (nonatomic, assign)MessageType type;

//是否显示时间
@property (nonatomic, assign)BOOL timeHidden;

+(instancetype)messageWithDict:(NSDictionary *)dict;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
