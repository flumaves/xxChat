//
//  MessageCell.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import "MessageCell.h"

@interface MessageCell ()

//时间
@property (nonatomic, strong) UILabel *timeLabel;

//正文
@property (nonatomic, strong) UIButton *textBtn;

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
        
        //正文
        _textBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_textBtn];
        _textBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _textBtn.titleLabel.numberOfLines = 0;
        [_textBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置内边距
        CGFloat edgeInsets = 20;
        _textBtn.contentEdgeInsets = UIEdgeInsetsMake(edgeInsets, edgeInsets, edgeInsets, edgeInsets);
        
        //头像
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.layer.cornerRadius = 5;
        [self.contentView addSubview:_iconImgView];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"message";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
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
        [_textBtn setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.width / 2.0, image.size.width / 2.0, image.size.height / 2.0, image.size.height / 2.0 + 1)] forState:UIControlStateNormal];
    } else {
        //头像
        _iconImgView.backgroundColor = [UIColor grayColor];
        //聊天框背景
        UIImage *image = [UIImage imageNamed:@"message_recive_nor"];
        [_textBtn setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.width/2.0, image.size.width/2.0, image.size.height/2.0, image.size.height/2.0 + 1)] forState:UIControlStateNormal];
    }
    
    _iconImgView.frame = messageFrame.iconFrame;
    _textBtn.frame = messageFrame.textFrame;
    [_textBtn setTitle:message.text forState:UIControlStateNormal];
}

@end
