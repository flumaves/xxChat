//
//  MessageCell.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import "MessageCell.h"
#import <AVFoundation/AVFoundation.h>

@interface MessageCell ()

//时间
@property (nonatomic, strong) UILabel *timeLabel;

//内容
@property (nonatomic, strong) UIButton *contentBtn;

//头像
@property (nonatomic, strong) UIImageView *iconImgView;

//语音消息的image
@property (nonatomic, strong) UIImageView *voiceImgView;

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
        _contentBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_contentBtn];
        _contentBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _contentBtn.titleLabel.numberOfLines = 0;
        [_contentBtn addTarget:self action:@selector(playVoice) forControlEvents:UIControlEventTouchUpInside];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置内边距
        CGFloat edgeInsets = 20;
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(edgeInsets, edgeInsets, edgeInsets, edgeInsets);
        
        //语音消息的图片
        _voiceImgView = [[UIImageView alloc] init];
        _voiceImgView.image = [UIImage imageNamed:@"语音消息"];
        _voiceImgView.hidden = YES;
        [self.contentBtn addSubview:_voiceImgView];
        
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
    
    if (message.message.contentType == kJMSGContentTypeVoice) {
        _voiceImgView.frame = messageFrame.voiceImgFrame;
        _voiceImgView.hidden = NO;
    } else {
        _voiceImgView.hidden = YES;
    }
    
    [_contentBtn setTitle:message.text forState:UIControlStateNormal];
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
