//
//  MessageCell.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import "MessageCell.h"
#import <AVFoundation/AVFoundation.h>
#import "MessageButton.h"

@interface MessageCell ()

//时间
@property (nonatomic, strong) UILabel *timeLabel;

//内容
@property (nonatomic, strong) MessageButton *contentBtn;

//头像
@property (nonatomic, strong) UIImageView *iconImgView;

@end

@implementation MessageCell

//重写init方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //tableView旋转180度后 内容要正过来则要再旋转180度
        self.transform = CGAffineTransformMakeRotation(M_PI);
        
        //时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLabel];
        
        //内容
        _contentBtn = [[MessageButton alloc] init];
        [self.contentView addSubview:_contentBtn];
        [_contentBtn addTarget:self action:@selector(playVoice) forControlEvents:UIControlEventTouchUpInside];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置内边距
        CGFloat edgeInsets = 20;
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(edgeInsets, edgeInsets, edgeInsets, edgeInsets);

        //头像
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.layer.cornerRadius = 5;
        [self.contentView addSubview:_iconImgView];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//在设置frame属性的同时就赋值给各个控件
- (void)setMessageFrame:(MessageFrame *)messageFrame {
    _messageFrame = messageFrame;               //frame模型
    Message *message = _messageFrame.message;   //message模型
    
    //设置时间
    _timeLabel.frame = messageFrame.timeFrame;
    _timeLabel.text = message.time;
    
    //判断MessageType
    if (message.type == MessageType_ME) {
        //设置头像
        _iconImgView.backgroundColor = [UIColor grayColor];
        //设置聊天框背景
        UIImage *image = [UIImage imageNamed:@"message_send_nor"];
        [_contentBtn setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.width / 2.0, image.size.width / 2.0, image.size.height / 2.0, image.size.height / 2.0 + 1)] forState:UIControlStateNormal];
    } else {
        //头像
        _iconImgView.backgroundColor = [UIColor grayColor];
        //聊天框背景
        UIImage *image = [UIImage imageNamed:@"message_recive_nor"];
        [_contentBtn setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.width/2.0, image.size.width/2.0, image.size.height/2.0, image.size.height/2.0 + 1)] forState:UIControlStateNormal];
    }
    
    _iconImgView.frame = messageFrame.iconFrame;
    _contentBtn.frame = messageFrame.contentFrame;
    
    if (message.message.contentType == kJMSGContentTypeVoice) { //语音消息
        _contentBtn.voiceImgView.frame = messageFrame.voiceImgFrame;
        _contentBtn.durationLbl.frame = messageFrame.durationLblFrame;
        _contentBtn.durationLbl.text = [NSString stringWithFormat:@"%d''",message.duration.intValue];
        _contentBtn.voiceImgView.hidden = NO;
        _contentBtn.durationLbl.hidden = NO;
    } else {
        _contentBtn.voiceImgView.hidden = YES;
        _contentBtn.durationLbl.hidden = YES;
    }
    
    if (message.message.contentType == kJMSGContentTypeText) {  //文本消息
        [_contentBtn setTitle:message.text forState:UIControlStateNormal];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        //设置为btn的label透明颜色 防止复用时出现bug （设置hidden属性不起作用）
        [_contentBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
    
    if (message.message.contentType == kJMSGContentTypeImage) { //图片消息
        _contentBtn.photoImgView.frame = messageFrame.photoImgFrame;
        _contentBtn.photoImgView.hidden = NO;
        //加载图片
        JMSGImageContent *content = (JMSGImageContent *)message.message.content;
        [content thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                return;
            }
            self.contentBtn.photoImgView.image = [UIImage imageWithData:data];
        }];
    } else {
        _contentBtn.photoImgView.hidden = YES;
    }
}


//播放语音消息
- (void)playVoice {
    JMSGMessage *message = _messageFrame.message.message;
    if (message.contentType == kJMSGContentTypeVoice) {
        JMSGVoiceContent *voiceContent = (JMSGVoiceContent *)message.content;
        [voiceContent voiceData:^(NSData *data, NSString *objectId, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            }
            if ([self.delegate respondsToSelector:@selector(playVoice:)]) {
                [self.delegate playVoice:data];
            }
        }];
    }
}
@end