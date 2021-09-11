//
//  MoreFunctionView.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/4.
//

#import "MoreFunctionView.h"

@implementation MoreFunctionView

- (NSMutableArray *)subViewNameArray {
    if (_subViewNameArray == nil) {
        _subViewNameArray = [NSMutableArray arrayWithObjects:@"相片", @"拍照", @"语音通话", @"位置", @"收藏",nil];
    }
    return _subViewNameArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1];
        
        ///一条细细的分割线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
        view.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        [self addSubview:view];
        
        //九宫格算法
        CGFloat margin = 30;
        CGFloat marginToTop = 20;
        int columns = 4;
        CGFloat viewWidth = ([UIScreen mainScreen].bounds.size.width - (margin * (columns + 1))) / columns;
        CGFloat viewHeight = viewWidth + 20;    //20是lbl的高度
        
        CGFloat viewX = 0;
        CGFloat viewY = 0;
        for (int i = 0; i < self.subViewNameArray.count; i++) {
            NSString *subViewName = [_subViewNameArray objectAtIndex:i];
            viewX = margin + (margin + viewWidth) * (i % columns);
            viewY = marginToTop + (margin + viewHeight) * (i / columns);
            MoreFunctionSubView *subView = [[MoreFunctionSubView alloc] initWithFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)];
            subView.lbl.text = subViewName;
            [subView.button setImage:[UIImage imageNamed:subViewName] forState:UIControlStateNormal];
            
            [self addSubview:subView];
            [self.subViewsArray addObject:subView];
        }
    }
    return self;
}

@end
