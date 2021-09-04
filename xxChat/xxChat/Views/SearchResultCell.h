//
//  SearchResultCell.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultCell : UITableViewCell

//头像
@property (nonatomic, strong)UIImageView *icon;

//名称
@property (nonatomic, strong)UILabel *name;

//ID
@property (nonatomic, strong)UILabel *ID;

//行高
@property (nonatomic, assign)CGFloat rowHeight;

@end

NS_ASSUME_NONNULL_END
