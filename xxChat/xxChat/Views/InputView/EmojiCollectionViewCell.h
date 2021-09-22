//
//  EmojiCollectionViewCell.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EmojiType) {
    EmojiType_JPG = 1234,
    EmojiType_GIF
};

@interface EmojiCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *emojiImageView;

@property (nonatomic, assign) EmojiType emojiType;

@property (nonatomic, strong) NSString *emojiPath;

@end

NS_ASSUME_NONNULL_END
