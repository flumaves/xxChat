//
//  UnreadRedPointView.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/11.
//

#import "UnreadRedPointView.h"

@implementation UnreadRedPointView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = frame.size.width / 2;
        self.hidden = YES;
        
        CGFloat labelWidth = frame.size.width;
        CGFloat labelHeight = frame.size.height;
        CGFloat labelX = (frame.size.width - labelWidth) / 2;
        CGFloat labelY = (frame.size.height - labelHeight) / 2;
        self.unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
        _unreadLabel.font = [UIFont systemFontOfSize:14];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.textColor = [UIColor whiteColor];
        [self addSubview:_unreadLabel];
    }
    return self;
}

- (void)setUnreadCount:(int)unreadCount {
    _unreadCount = unreadCount;
    if (_unreadCount > 0) {
        self.hidden = NO;
        if (_unreadCount > 99) {
            _unreadLabel.text = @"...";
        } else {
            _unreadLabel.text = [NSString stringWithFormat:@"%d", _unreadCount];
        }
    } else {
        self.hidden = YES;
    }
}

@end
