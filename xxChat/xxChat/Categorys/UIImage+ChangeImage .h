//
//  UIImage.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ChangeImage)

//处理图片大小
- (UIImage *)scaleToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
