//
//  ImageBrowserCollectionViewCell.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageBrowserCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imgView;

@end

NS_ASSUME_NONNULL_END
