//
//  ChatCell.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/11.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
#import "UnreadRedPointView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell

//头像
@property (nonatomic, strong)UIImageView *icon;

//头像右上方的红点
@property (nonatomic, strong)UnreadRedPointView *redPoint;

//名称
@property (nonatomic, strong)UILabel *name;

//最新的一条聊天记录
@property (nonatomic, strong)UILabel *message;

//时间
@property (nonatomic, strong)UILabel *time;

//行高
@property (nonatomic, assign)CGFloat rowHeight;

//数据
@property (nonatomic, strong)JMSGConversation *conversation;

@end

NS_ASSUME_NONNULL_END
