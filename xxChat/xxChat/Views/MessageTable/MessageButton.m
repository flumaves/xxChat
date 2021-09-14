//
//  MessageButton.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/4.
//

#import "MessageButton.h"

@implementation MessageButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.numberOfLines = 0;
        
        _durationLbl = [[UILabel alloc] init];
        _durationLbl.font = [UIFont systemFontOfSize:15];
        [self addSubview:_durationLbl];
        
        _voiceImgView = [[UIImageView alloc] init];
        _voiceImgView.image = [UIImage imageNamed:@"语音消息"];
        _voiceImgView.hidden = YES;
        [self addSubview:_voiceImgView];
        
        _photoImgView = [[UIImageView alloc] init];
        _photoImgView.hidden = YES;
        [self addSubview:_photoImgView];
    }
    return self;
}

@end
