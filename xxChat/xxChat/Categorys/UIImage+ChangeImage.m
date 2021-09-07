//
//  UIImage+ChangeImage.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/4.
//

#import "UIImage+ChangeImage.h"

@implementation UIImage (ChangeImage)

//处理图片大小
- (UIImage *)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaleImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImg;
}

@end
