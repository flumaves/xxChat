//
//  MessageCell.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import "MessageCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+YCHUD.h"

@interface MessageCell ()

//时间
@property (nonatomic, strong) UILabel *timeLabel;

//头像
@property (nonatomic, strong) UIImageView *iconImgView;

/// JMSGMessage
@property (nonatomic, strong) JMSGMessage *message;

/// 图片的tag
@property (nonatomic, assign) int imageTag;

@end

@implementation MessageCell

//重写init方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLabel];
        
        //内容
        _contentBtn = [[MessageButton alloc] init];
        [self.contentView addSubview:_contentBtn];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置内边距
        CGFloat edgeInsets = 20;
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(edgeInsets, edgeInsets, edgeInsets, edgeInsets);

        //头像
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.layer.cornerRadius = 5;
        self.iconImgView.backgroundColor = [UIColor grayColor];
        [self.iconImgView setImage:[UIImage imageNamed:@"头像占位图"]];
        _iconImgView.clipsToBounds = YES;
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
    _message = message.message;
    
    //设置时间
    _timeLabel.frame = messageFrame.timeFrame;
    _timeLabel.text = message.time;
    
    //设置头像
    JMSGUser *fromUser = message.message.fromUser;
    [fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (error) {
            NSLog(@"messageCell设置头像错误：%@",error);
            [self.iconImgView setImage:[UIImage imageNamed:@"头像占位图"]];
            return;
        }
        if (data) {
            self.iconImgView.image = [UIImage imageWithData:data];
        }
    }];
    
    //判断MessageType
    if (message.type == MessageType_ME) {
        //设置聊天框背景
        UIImage *image = [UIImage imageNamed:@"message_send_nor"];
        [_contentBtn setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.width / 2.0, image.size.width / 2.0, image.size.height / 2.0, image.size.height / 2.0 + 1)] forState:UIControlStateNormal];
    } else {
        //聊天框背景
        UIImage *image = [UIImage imageNamed:@"message_recive_nor"];
        [_contentBtn setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.width/2.0, image.size.width/2.0, image.size.height/2.0, image.size.height/2.0 + 1)] forState:UIControlStateNormal];
    }
    
    _iconImgView.frame = messageFrame.iconFrame;
    _contentBtn.frame = messageFrame.contentFrame;
    
    if (_message.contentType == kJMSGContentTypeVoice) { //语音消息
        [self.contentBtn addTarget:self action:@selector(playVoice) forControlEvents:UIControlEventTouchUpInside];
        _contentBtn.voiceImgView.frame = messageFrame.voiceImgFrame;
        _contentBtn.durationLbl.frame = messageFrame.durationLblFrame;
        _contentBtn.durationLbl.text = [NSString stringWithFormat:@"%d''",message.duration.intValue];
        if (message.type == MessageType_ME) {
            _contentBtn.voiceImgView.image = [UIImage imageNamed:@"voice_left"];
        } else {
            _contentBtn.voiceImgView.image = [UIImage imageNamed:@"voice_right"];
        }
        _contentBtn.voiceImgView.hidden = NO;
        _contentBtn.durationLbl.hidden = NO;
    } else {
        [self.contentBtn removeTarget:self action:@selector(playVoice) forControlEvents:UIControlEventTouchUpInside];
        _contentBtn.voiceImgView.hidden = YES;
        _contentBtn.durationLbl.hidden = YES;
    }
    
    if (_message.contentType == kJMSGContentTypeText) {  //文本消息
        [_contentBtn setTitle:message.text forState:UIControlStateNormal];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        //设置为btn的label透明颜色 防止复用时出现bug （设置hidden属性不起作用）
        [_contentBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
    
    if (_message.contentType == kJMSGContentTypeImage) { //图片消息
        static int imageTag = 0;
        _imageTag = ++imageTag;
        _contentBtn.photoImgView.frame = messageFrame.photoImgFrame;
        _contentBtn.photoImgView.hidden = NO;
        [self.contentBtn addTarget:self action:@selector(showImageBrowser) forControlEvents:UIControlEventTouchUpInside];
        //加载图片
        JMSGImageContent *content = (JMSGImageContent *)message.message.content;
        [content largeImageDataWithProgress:nil completionHandler:^(NSData *data, NSString *objectId, NSError *error) {
            if (error) {
                NSLog(@"messageCell设置图片出错：%@",error);
                return;
            }
            self.contentBtn.photoImgView.image = [UIImage YCHUDImageWithSmallGIFData:data scale:1];
        }];
    } else {
        _contentBtn.photoImgView.hidden = YES;
        [self.contentBtn removeTarget:self action:@selector(showImageBrowser) forControlEvents:UIControlEventTouchUpInside];
    }
}


//播放语音消息
- (void)playVoice {
    JMSGMessage *message = _messageFrame.message.message;
    if (message.contentType == kJMSGContentTypeVoice) {
        JMSGVoiceContent *voiceContent = (JMSGVoiceContent *)message.content;
        [voiceContent voiceData:^(NSData *data, NSString *objectId, NSError *error) {
            if (error) {
                NSLog(@"播放语音消息错误%@",error);
            }
            if ([self.delegate respondsToSelector:@selector(playVoice:)]) {
                [self.delegate playVoice:data];
            }
        }];
    }
}

- (void)showImageBrowser {
    if ([self.delegate respondsToSelector:@selector(showImageBrowserWithImageTag:)]) {
        [self.delegate showImageBrowserWithImageTag:_imageTag];
    }
}
@end
