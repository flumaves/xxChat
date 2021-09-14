//
//  EmojiView.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/14.
//

/// 该view封装用于inputview中表情包的view

#import <UIKit/UIKit.h>
#import "EmojiCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface EmojiView : UIView

@property (nonatomic, strong) UICollectionView *emojiCollectionView;

@end

NS_ASSUME_NONNULL_END
