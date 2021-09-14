//
//  MessageFrame.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import "MessageFrame.h"

@implementation MessageFrame

//在给frame的message属性赋值的时候顺便就把frame计算了
- (void)setMessage:(Message *)message {
    _message = message;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat space = 10; //控件间的间隔
    //时间
    if (_message.timeHidden == NO) {        //不隐藏时间条
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeH = 15;
        CGFloat timeW = screenWidth;
        _timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    //头像
    CGFloat iconL = 40;
    CGFloat iconX = 0;
    CGFloat iconY = CGRectGetMaxY(_timeFrame) + space;
    if (_message.type == MessageType_ME) {  //自己发的消息
        iconX = screenWidth - space - iconL;
    } else {                                //别人发的消息
        iconX = space;
    }
    _iconFrame = CGRectMake(iconX, iconY, iconL, iconL);
    
    if (_message.message.contentType == kJMSGContentTypeText) { ///文本消息
        //文本消息
        //聊天消息最大的尺寸
        CGFloat maxWidth = 200;     //(随便给的)
        CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
        CGSize textSize = [_message.text
       boundingRectWithSize:maxSize
                    options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
                    context:nil].size;
        // NSStringDrawingUsesFontLeading //行间距计算
        // NSStringDrawingUsesLineFragmentOrigin // 每行为矩形框计算
        
        //聊天框内边距
        CGFloat edgeInsets = 20;
        CGFloat textW = textSize.width + 2 * edgeInsets;
        CGFloat textH = textSize.height + 2 * edgeInsets;
        CGFloat textY = iconY;
        CGFloat textX = 0;
        if (_message.type == MessageType_ME) {
            textX = screenWidth - space * 2 - iconL - textW;
        } else {
            textX = CGRectGetMaxX(_iconFrame) + space;
        }
        _contentFrame = CGRectMake(textX, textY, textW, textH);
        
    } else if (_message.message.contentType == kJMSGContentTypeVoice) { ///语音消息
        //语音消息
        //消息的宽度 （最少20 最多200）根据语音的时长计算宽度
        CGFloat edgeInsets = 20;
        CGFloat voiceWidth = (message.duration.doubleValue / 30) * 200;
        voiceWidth = MAX(voiceWidth, 50) + 2 * edgeInsets;
        CGFloat voiceHeight = 20 + 2 * edgeInsets;
        CGFloat voiceY = iconY;
        CGFloat voiceX = 0;
        if (_message.type == MessageType_ME) {
            voiceX = screenWidth - space * 2 - iconL - voiceWidth;
        } else {
            voiceX = CGRectGetMaxX(_iconFrame) + space;
        }
        _contentFrame = CGRectMake(voiceX, voiceY, voiceWidth, voiceHeight);
        
        //语音消息的图片
        CGFloat imgWidth = 20;
        CGFloat imgHeight = 20;
        CGFloat imgX = (voiceWidth - imgWidth) - 20;
        CGFloat imgY = (voiceHeight - imgHeight) / 2;
        _voiceImgFrame = CGRectMake(imgX, imgY, imgWidth, imgHeight);
        
        //语音消息的秒数
        CGFloat durationLblWidth = 20;
        CGFloat durationLblHeight = 20;
        CGFloat durationLblX = imgX - durationLblWidth;
        CGFloat durationLblY = imgY;
        _durationLblFrame = CGRectMake(durationLblX, durationLblY, durationLblWidth, durationLblHeight);
        
    } else if (_message.message.contentType == kJMSGContentTypeImage) { ///图片消息
        CGSize imageSize = _message.imageSize;
        //消息的宽度 （最大200 * 200）
        CGFloat edgeInsets = 20;
        CGFloat imageWidth = imageSize.width;
        imageWidth = imageWidth > 200 ? 200 : imageWidth;
        CGFloat contentWidth = imageWidth + 2 * edgeInsets;
        CGFloat imageHeight = imageSize.height;
        imageHeight = imageHeight > 200 ? (imageSize.height / imageSize.width) * imageWidth : imageHeight;
        CGFloat contentHeight = imageHeight + 2 * edgeInsets;
        CGFloat contentY = iconY;
        CGFloat contentX = 0;
        if (_message.type == MessageType_ME) {
            contentX = screenWidth - contentWidth - iconL - space * 2;
        } else {
            contentX = iconL + 2 * space;
        }
        _contentFrame = CGRectMake(contentX, contentY, contentWidth, contentHeight);
        
        CGFloat imageX = edgeInsets;
        CGFloat imageY = edgeInsets;
        _photoImgFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
    }
    
    //cell的高度
    CGFloat maxIconY = CGRectGetMaxY(_iconFrame);
    CGFloat maxTextY = CGRectGetMaxY(_contentFrame);
    _rowHeight = MAX(maxIconY, maxTextY) + space;
}

@end
