//
//  SearchResultCell.h
//  xxChat
//
//  Created by 谢恩平 on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultCell : UITableViewCell

//头像
@property (nonatomic, strong)UIImageView *icon;

//名称
@property (nonatomic, strong)UILabel *name;

//最新的一条聊天记录
@property (nonatomic, strong)UILabel *message;

//时间
@property (nonatomic, strong)UILabel *time;

//行高
@property (nonatomic, assign)CGFloat rowHeight;

@end

NS_ASSUME_NONNULL_END
