//
//  UIImage+YCHUD.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/15.
//


///纯复制的
///用于把nsdata加载成gif图片

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YCHUD)

+ (UIImage *)YCHUDImageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
