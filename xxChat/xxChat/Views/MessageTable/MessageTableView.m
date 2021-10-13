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

@end
