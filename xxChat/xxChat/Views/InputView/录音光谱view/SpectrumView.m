//
//  SpectrumView.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/10/13.
//

#import "SpectrumView.h"

@interface SpectrumView ()

/// item的高度数组
@property (nonatomic, strong) NSMutableArray *levelsArray;

/// item的shapeLayer数组
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *itemsLayers;

/// 刷新计时器
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation SpectrumView
#pragma mark - setters
- (void)setItemColor:(UIColor *)itemColor {
    _itemColor = itemColor;
    for (CAShapeLayer *shapeLayer in self.itemsLayers) {
        shapeLayer.strokeColor = self.itemColor.CGColor;
    }
}

- (void)setNumberOfItems:(NSUInteger)numberOfItems {
    if (_numberOfItems == numberOfItems) {
        return;
    }
    _numberOfItems = numberOfItems;
    
    self.levelsArray = [NSMutableArray array];
    for (int i = 0; i < _numberOfItems / 2; i++) {
        [self.levelsArray addObject:@(0)];
    }
    
    self.itemsLayers = [NSMutableArray array];
    for (int i = 0; i < _numberOfItems; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.lineCap = kCALineCapButt;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.strokeColor = _itemColor ? _itemColor.CGColor : [UIColor clearColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = self.itemWidth;
        
        [self.layer addSublayer:shapeLayer];
        [self.itemsLayers addObject:shapeLayer];
    }
}

- (void)setItemWidth:(CGFloat)itemWidth {
    if (_itemWidth != itemWidth) {
        _itemWidth = itemWidth;
        for (CAShapeLayer *layer in self.itemsLayers) {
            layer.lineWidth = itemWidth;
        }
    }
}

- (void)setItemLevelCallBack:(void (^)(void))itemLevelCallBack {
    _itemLevelCallBack = itemLevelCallBack;
    
    [self start];
}


- (void)setLevel:(CGFloat)level {
    level = (level + 37.5) * 3;
    if (level < 0) {
        level = 0;
    }
    [self.levelsArray removeLastObject];
    [self.levelsArray insertObject:@(level / 6.f) atIndex:0];
    
    [self updateItems];
}

/// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.8;
        self.backgroundColor = [UIColor blackColor];
        self.hidden = YES;
    }
    return self;
}

- (void)updateItems {
    UIGraphicsBeginImageContext(self.frame.size);
    CGFloat itemInterval = _itemWidth * 2;  //item之间的间隔

    //从中间开始往两边画线
    CGFloat lineLeftX = (self.frame.size.width - itemInterval - _itemWidth) / 2;
    CGFloat lineRightX = (self.frame.size.width + itemInterval + _itemWidth) / 2;

    for (int i = 0; i < self.numberOfItems / 2; i++) {
        CGFloat lineHeigth = 2 * self.itemWidth + [self.levelsArray[i] floatValue] * 3;
        CGFloat lineTop = (self.frame.size.height - lineHeigth) / 2;
        CGFloat lineBottom = (self.frame.size.height + lineHeigth) / 2;

        UIBezierPath *lineLeftPath = [UIBezierPath bezierPath];
        [lineLeftPath moveToPoint:CGPointMake(lineLeftX, lineTop)];
        [lineLeftPath addLineToPoint:CGPointMake(lineLeftX, lineBottom)];
        CAShapeLayer *layerLeft = [self.itemsLayers objectAtIndex:(self.numberOfItems / 2 - i -1)];
        layerLeft.path = lineLeftPath.CGPath;
        
        lineLeftX -= itemInterval;

        UIBezierPath *lineRightPath = [UIBezierPath bezierPath];
        [lineRightPath moveToPoint:CGPointMake(lineRightX, lineTop)];
        [lineRightPath addLineToPoint:CGPointMake(lineRightX, lineBottom)];
        CAShapeLayer *layerRight = [self.itemsLayers objectAtIndex:self.numberOfItems / 2 + i];
        layerRight.path = lineRightPath.CGPath;
        
        lineRightX += itemInterval;
    }
    
    UIGraphicsEndImageContext();
}


/// 录音开始时操作
- (void)start {
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:_itemLevelCallBack selector:@selector(invoke)];
        self.displayLink.preferredFramesPerSecond = 6.f;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }

}

/// 录音结束时操作
- (void)stop {
    [self.displayLink invalidate];
    self.displayLink = nil;
}
@end
