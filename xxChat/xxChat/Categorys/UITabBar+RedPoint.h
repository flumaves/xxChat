//
//  UITableViewController+UITabBar_RedPoint.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/11.
//

#import <UIKit/UIKit.h>
#import "UnreadRedPointView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (UITabBar_RedPoint)

- (void)showRedPointAtIndex:(int)index withUnreadCount:(int)unreadCount;
- (void)hideRedPointAtIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
