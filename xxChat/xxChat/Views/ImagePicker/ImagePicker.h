//
//  ImagePicker.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/14.
//

///模拟的一个照片选择器

#import <UIKit/UIKit.h>
#import "ImageCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ImagePickerDelegate <NSObject>

- (void)didFinishingPickImage;

- (void)didCancelPickImage;

@end

@interface ImagePicker : UIView <ImageCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *imageCollectionView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *chooseButton;

@property (nonatomic, weak) id<ImagePickerDelegate> delegate;

//一次最多选择的图片数量 (默认是1)
@property (nonatomic, assign) int maxPhotoNumber;

//选中的图片cell数组
@property (nonatomic, strong) NSMutableArray *choosePhotoArray;
@end

NS_ASSUME_NONNULL_END
