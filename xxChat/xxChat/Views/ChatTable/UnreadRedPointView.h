//
//  UnreadRedPointView.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/11.
//


///该view封装用于未读消息之类所需的小红点
///内含一个label 和 作为背景的redView

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnreadRedPointView : UIView

@property (nonatomic, strong) UILabel *unreadLabel;

@property (nonatomic, assign) int unreadCount;

@end

NS_ASSUME_NONNULL_END
