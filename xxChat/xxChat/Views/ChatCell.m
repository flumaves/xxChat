//
//  ChatCell.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/11.
//

#import "ChatCell.h"

@interface ChatCell ()

//记录是否已经对控件进行赋值
@property (nonatomic, assign) BOOL haveConversation;

@end

@implementation ChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //控件间隔为15
        CGFloat space = 15;
        
        //头像
        CGFloat iconX = space;
        CGFloat iconY = 5;
        CGFloat iconL = 60;
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconL, iconL)];
        self.icon.backgroundColor = [UIColor grayColor];
        self.icon.layer.cornerRadius = 10;
        [self addSubview:_icon];
        
        //名称
        CGFloat nameX = CGRectGetMaxX(_icon.frame) + space;
        CGFloat nameY = iconY + 5;
        CGFloat nameW = 150;
        CGFloat nameH = 20;
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
        self.name.font = [UIFont systemFontOfSize:18];
        [self addSubview:_name];
        
        //聊天记录
        CGFloat messageX = nameX;
        CGFloat messageY = CGRectGetMaxY(_name.frame) + 10;
        CGFloat messageW = nameW;
        CGFloat messageH = 15;
        self.message = [[UILabel alloc] initWithFrame:CGRectMake(messageX, messageY, messageW, messageH)];
        self.message.font = [UIFont systemFontOfSize:15];
        self.message.textColor = [UIColor grayColor];
        [self addSubview:_message];
        
        //时间
        CGFloat timeW = 100;
        CGFloat timeX = [UIScreen mainScreen].bounds.size.width - timeW - space;
        CGFloat timeH = 20;
        CGFloat timeY = nameY;
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(timeX, timeY, timeW, timeH)];
        self.time.font = [UIFont systemFontOfSize:13];
        self.time.textColor = [UIColor grayColor];
        //设置为右对齐
        self.time.textAlignment = NSTextAlignmentRight;
        [self addSubview:_time];
        
        self.rowHeight = CGRectGetMaxY(_icon.frame) + space;
    }
    return self;
}

//在设置conversation顺带赋值
- (void)setConversation:(JMSGConversation *)conversation {
    if (conversation == nil) {
        return;
    }
    _conversation = conversation;
    //名称
    self.name.text = _conversation.title;
    //聊天记录
    if (_conversation.latestMessage.contentType == kJMSGContentTypeText) {
        JMSGTextContent *textContent = (JMSGTextContent *)_conversation.latestMessage.content;
        self.message.text = textContent.text;
        
    } else if (_conversation.latestMessage.contentType == kJMSGContentTypeVoice) {
        self.message.text = @"[语音消息]";
        
    }
    
    //时间
    NSTimeInterval timeInterval = [_conversation.latestMsgTime doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    self.time.text = [dateFormatter stringFromDate:date];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
