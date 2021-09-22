//
//  ImageCollectionViewCell.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/14.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        CGFloat space = 10;
        CGFloat pointViewWidth = 25;
        CGFloat pointViewHeight = pointViewWidth;
        CGFloat pointViewX = self.frame.size.width - pointViewWidth - space;
        CGFloat pointViewY = space;
        self.pointView = [[UnreadRedPointView alloc] initWithFrame:CGRectMake(pointViewX,
                                                                              pointViewY,
                                                                              pointViewWidth,
                                                                              pointViewHeight)];
        _pointView.backgroundColor = [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1];
        _pointView.unreadLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_pointView];
        
        //添加一个透明的按钮
        self.clearButton = [[UIButton alloc] initWithFrame:self.pointView.frame];
        _clearButton.backgroundColor = [UIColor clearColor];
        [_clearButton addTarget:self action:@selector(clearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _clearButton.layer.cornerRadius = _clearButton.frame.size.width / 2;
        _clearButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _clearButton.layer.borderWidth = 3;
        [self addSubview:_clearButton];
        
        self.choose = NO;
    }
    return self;
}

- (void)clearButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(updateChooseNumber:)]) {
        [self.delegate updateChooseNumber:self];
    }
}
@end
