//
//  MessageTableView.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/3.
//

#import "MessageTableView.h"

@implementation MessageTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.separatorStyle = NO;
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    }
    return self;
}

//遍历子控件 找到滚动条 自定义滚动条
- (void)layoutSubviews {
    [super layoutSubviews];

    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView * imageView = [[UIImageView alloc] init];
            imageView = obj;
            imageView.backgroundColor = [UIColor redColor];
        }
    }];
    UIView *view = [self.subviews lastObject];
    CGRect frame = view.frame;
    frame.size.width = 2;
    frame.origin.x = 3;
    view.frame = frame;
}

@end
