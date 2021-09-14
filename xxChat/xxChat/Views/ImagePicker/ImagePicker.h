//
//  ImagePicker.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/14.
//

///模拟的一个照片选择器

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImagePickerDelegate <NSObject>

- (void)didFinishingPickImage;

- (void)didCancelPickImage;

@end

@interface ImagePicker : UIView

@property (nonatomic, strong) UICollectionView *imageCollectionView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *chooseButton;

@property (nonatomic, weak) id<ImagePickerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
