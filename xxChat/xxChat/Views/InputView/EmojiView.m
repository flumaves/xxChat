//
//  EmojiView.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/14.
//

#import "EmojiView.h"

@implementation EmojiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //item的大小
        CGFloat space = 0;
        layout.minimumLineSpacing = space;
        layout.minimumInteritemSpacing = space;
        //每行四个元素
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 4;
        layout.itemSize = CGSizeMake(width, width);
        
        //表情包的collectionView
        CGFloat collectionViewX = 0;
        CGFloat collectionViewY = 0;
        CGFloat collectionViewWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat collectionViewHeight = frame.size.height;
        self.emojiCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(collectionViewX,
                                                                                      collectionViewY,
                                                                                      collectionViewWidth,
                                                                                      collectionViewHeight)
                                                      collectionViewLayout:layout];
        _emojiCollectionView.alwaysBounceVertical = YES;
        [_emojiCollectionView registerClass:[EmojiCollectionViewCell class] forCellWithReuseIdentifier:@"emojiCell"];
        _emojiCollectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_emojiCollectionView];
    }
    return self;
}

@end
