//
//  ImageCollectionViewCell.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/14.
//

#import <UIKit/UIKit.h>
#import "UnreadRedPointView.h"

NS_ASSUME_NONNULL_BEGIN
@class ImageCollectionViewCell;
@protocol ImageCollectionViewCellDelegate <NSObject>

- (void)updateChooseNumber:(ImageCollectionViewCell *)cell;

@end

@interface ImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UnreadRedPointView *pointView;

@property (nonatomic, strong) UIButton *clearButton;

@property (nonatomic, weak) id<ImageCollectionViewCellDelegate> delegate;

//是否处在选中状态
@property (nonatomic, getter = isChoosed) BOOL choose;

@end

NS_ASSUME_NONNULL_END
