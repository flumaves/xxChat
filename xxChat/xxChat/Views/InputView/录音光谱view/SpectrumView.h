//
//  SpectrumView.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/10/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 录音光谱view的封装 ，一条光谱是一个item
@interface SpectrumView : UIView

@property (nonatomic, copy) void (^itemLevelCallBack)(void);

/// 光谱的条数
@property (nonatomic, assign) NSUInteger numberOfItems;

/// 光谱的颜色
@property (nonatomic, strong) UIColor *itemColor;

/// 光谱的强度
@property (nonatomic, assign) CGFloat level;

/// item的宽度
@property (nonatomic, assign) CGFloat itemWidth;


- (void)start;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
