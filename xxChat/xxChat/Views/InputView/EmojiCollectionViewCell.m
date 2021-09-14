//
//  EmojiCollectionViewCell.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/14.
//

#import "EmojiCollectionViewCell.h"

@implementation EmojiCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat emojiWidth = 60;
        CGFloat emojiHeight = emojiWidth;
        CGFloat emojiX = (frame.size.width - emojiWidth) / 2;
        CGFloat emojiY = (frame.size.height - emojiHeight) / 2;
        self.emojiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(emojiX,
                                                                            emojiY,
                                                                            emojiWidth,
                                                                            emojiHeight)];
        _emojiImageView.contentMode = UIViewContentModeScaleAspectFill;
        _emojiImageView.clipsToBounds = YES;
        [self addSubview:_emojiImageView];
    }
    return self;
}

@end
