//
//  ContactCell.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactCell : UITableViewCell
//头像
@property (nonatomic, strong)UIImageView *icon;

//名称
@property (nonatomic, strong)UILabel *name;

//小红点
@property (nonatomic,strong)UIView *redPoint;

//行高
@property (nonatomic, assign)CGFloat rowHeight;
@end

NS_ASSUME_NONNULL_END
