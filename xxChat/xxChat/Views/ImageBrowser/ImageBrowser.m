//
//  ImageBrowser.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/24.
//

#import "ImageBrowser.h"
#import "ImageBrowserCollectionViewCell.h"

@implementation ImageBrowser

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,
                                     [UIScreen mainScreen].bounds.size.height);
        
        _imageBrowserCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                        [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
        _imageBrowserCollectionView.bounces = NO;
        [_imageBrowserCollectionView registerClass:[ImageBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"ImageBrowserCell"];
        _imageBrowserCollectionView.pagingEnabled = YES;
        [self addSubview:_imageBrowserCollectionView];
    }
    return self;
}
@end
