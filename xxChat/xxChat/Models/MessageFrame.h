//
//  MessageFrame.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Message.h"


///该类用于聊天消息frame的封装

NS_ASSUME_NONNULL_BEGIN

@interface MessageFrame : NSObject

//数据模型
@property (nonatomic, strong)Message *message;

//时间frame
@property (nonatomic, assign)CGRect timeFrame;

//头像frame
@property (nonatomic, assign)CGRect iconFrame;

//正文frame
@property (nonatomic, assign)CGRect textFrame;

//cell的高度
@property (nonatomic, assign)CGFloat rowHeight;

@end

NS_ASSUME_NONNULL_END
