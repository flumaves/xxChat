//
//  MoreFunctionSubView.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/4.
//

#import "MoreFunctionSubView.h"

@implementation MoreFunctionSubView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = width;
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _button.layer.cornerRadius = 15;
        [_button addTarget:self action:@selector(viewClick) forControlEvents:UIControlEventTouchUpInside];
        _button.backgroundColor = [UIColor whiteColor];
        [self addSubview:_button];
        
        CGFloat lblHeigth = frame.size.height - height;
        CGFloat lblY = height;
        _lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, lblY, width, lblHeigth)];
        _lbl.textAlignment = NSTextAlignmentCenter;
        _lbl.font = [UIFont systemFontOfSize:14];
        _lbl.textColor = [UIColor grayColor];
        [self addSubview:_lbl];
    }
    return self;
}

- (void)viewClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"moreFunctionSubViewClick" object:self];
}

@end
