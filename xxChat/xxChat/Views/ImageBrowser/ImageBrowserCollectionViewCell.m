//
//  ImageBrowserCollectionViewCell.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/24.
//

#import "ImageBrowserCollectionViewCell.h"

@implementation ImageBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 3.5;
        _scrollView.minimumZoomScale = 0.5;
        [self addSubview:_scrollView];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _imgView.center = _scrollView.center;
        _imgView.backgroundColor = [UIColor blackColor];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        //添加手势
        UITapGestureRecognizer *oneTimeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTimeTap:)];
        oneTimeTap.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:oneTimeTap];
        
        [_scrollView addSubview:_imgView];
        
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat imageScaleWidth = scrollView.zoomScale * self.self.bounds.size.width;
    CGFloat imageScaleHeight = scrollView.zoomScale * self.bounds.size.height - 200;

    CGFloat imageX = 0;
    CGFloat imageY = 0;
    imageX = floorf((self.frame.size.width - imageScaleWidth) / 2.0);
    imageY = floorf((self.frame.size.height - imageScaleHeight) / 2.0);
    self.imgView.frame = CGRectMake(imageX, imageY, imageScaleWidth, imageScaleHeight);
}

- (void)oneTimeTap:(UITapGestureRecognizer *)sender {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageBrowserOneTimeTap" object:nil];
}
@end
