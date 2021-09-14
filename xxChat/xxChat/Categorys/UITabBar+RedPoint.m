//
//  UITabBar+RedPoint.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/14.
//

#import "UITabBar+RedPoint.h"

@implementation UITabBar (UITabBar_RedPoint)

//展示红点
- (void)showRedPointAtIndex:(int)index withUnreadCount:(int)unreadCount{
    [self removeRedPointAtIndex:index];
    
    CGFloat space = 20;
    CGFloat redPointWidth = 20;
    CGFloat redPointHeight = redPointWidth;
    CGFloat redPointX = (self.frame.size.width / self.items.count) * (index + 1) - redPointWidth - space;
    CGFloat redPointY = 5;
    UnreadRedPointView *redPoint = [[UnreadRedPointView alloc] initWithFrame:CGRectMake(redPointX, redPointY, redPointWidth, redPointHeight)];
    redPoint.unreadCount = unreadCount;
    redPoint.tag = index + 1234;
    [self addSubview:redPoint];
}

//隐藏红点
- (void)hideRedPointAtIndex:(int)index {
    [self removeRedPointAtIndex:index];
}

//移除红点
- (void)removeRedPointAtIndex:(int)index {
    for (UIView *subView in self.subviews) {
        if (subView.tag == index + 1234) {
            [subView removeFromSuperview];
        }
    }
}
@end
