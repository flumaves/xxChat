//
//  MoreFunctionView.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/4.
//

///moreFunctionView封装用于inputview中最右侧的 更多按钮 点击后展开的view

#import <UIKit/UIKit.h>
#import "MoreFunctionSubView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoreFunctionView : UIView
//所有subView
@property (nonatomic, strong) NSMutableArray *subViewsArray;

//subview的名称
@property (nonatomic, strong) NSMutableArray *subViewNameArray;
@end

NS_ASSUME_NONNULL_END
