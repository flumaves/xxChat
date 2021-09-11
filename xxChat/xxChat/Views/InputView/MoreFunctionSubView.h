//
//  MoreFunctionSubView.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/4.
//

///该封装用于moreFunctionView中的每一个subVIew
///包含一个UILabel 和 一个UIButton

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoreFunctionSubView : UIView

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *lbl;

@end

NS_ASSUME_NONNULL_END
