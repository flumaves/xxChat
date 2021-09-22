//
//  ImagePicker.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/14.
//

#import "ImagePicker.h"

@implementation ImagePicker

- (NSMutableArray *)choosePhotoArray {
    if (!_choosePhotoArray) {
        _choosePhotoArray = [NSMutableArray array];
    }
    return _choosePhotoArray;
}

- (int)maxPhotoNumber {
    if (!_maxPhotoNumber) {
        _maxPhotoNumber = 1;
    }
    return _maxPhotoNumber;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //item的大小
        CGFloat space = 2;
        layout.minimumLineSpacing = space;
        layout.minimumInteritemSpacing = space;
        //每行3个元素
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - (3 * space)) / 3;
        layout.itemSize = CGSizeMake(width, width);
        
        //图片的collectionView
        CGFloat collectionViewX = 0;
        CGFloat collectionViewY = 0;
        CGFloat collectionViewWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat collectionViewHeight = [UIScreen mainScreen].bounds.size.height - 90;
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(collectionViewX,
                                                                                  collectionViewY,
                                                                                  collectionViewWidth,
                                                                                  collectionViewHeight)
                                                  collectionViewLayout:layout];
        [_imageCollectionView registerClass:[ImageCollectionViewCell class]
                 forCellWithReuseIdentifier:@"imageCell"];
        [self addSubview:_imageCollectionView];
        
        //取消按钮
        CGFloat cancelButtonWidth = 50;
        CGFloat cancelButtonHeight = 30;
        CGFloat cancelButtonX = 40;
        CGFloat cancelButtonY = CGRectGetMaxY(_imageCollectionView.frame) + 20;
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(cancelButtonX,
                                                                   cancelButtonY,
                                                                   cancelButtonWidth,
                                                                   cancelButtonHeight)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(cancelButtonClick)
                forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.backgroundColor = [UIColor systemGrayColor];
        _cancelButton.layer.cornerRadius = 5;
        [self addSubview:_cancelButton];
        
        //选择按钮
        CGFloat chooseButtonX = [UIScreen mainScreen].bounds.size.width - cancelButtonWidth - 40;
        CGFloat chooseButtonY = cancelButtonY;
        CGFloat chooseButtonWidth = 50;
        CGFloat chooseButtonHeight = 30;
        _chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(chooseButtonX,
                                                                   chooseButtonY,
                                                                   chooseButtonWidth,
                                                                   chooseButtonHeight)];
        _chooseButton.backgroundColor = [UIColor systemGrayColor];
        _chooseButton.layer.cornerRadius = 5;
        [_chooseButton addTarget:self
                          action:@selector(chooseButtonClick)
                forControlEvents:UIControlEventTouchUpInside];
        [_chooseButton setTitle:@"传送" forState:UIControlStateNormal];
        [_chooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_chooseButton];
    }
    return self;
}

- (void)chooseButtonClick {
    if ([self.delegate respondsToSelector:@selector(didFinishingPickImage)]) {
        [self.delegate didFinishingPickImage];
    }
}

- (void)cancelButtonClick {
    if ([self.delegate respondsToSelector:@selector(didCancelPickImage)]) {
        [self.delegate didCancelPickImage];
    }
}

//每选择一张图片 刷新圆圈里的数字
- (void)updateChooseNumber:(ImageCollectionViewCell *)cell {
    if ([cell isChoosed]) {
        cell.choose = NO;
        cell.pointView.hidden = YES;
        [self.choosePhotoArray removeObject:cell];
        for (int i = 0; i < self.choosePhotoArray.count; i++) {
            ImageCollectionViewCell *cell = _choosePhotoArray[i];
            cell.pointView.unreadCount = i + 1;
        }
    } else {
        cell.choose = YES;
        [self.choosePhotoArray addObject:cell];
        cell.pointView.unreadCount = (int)self.choosePhotoArray.count;
    }
}
@end
