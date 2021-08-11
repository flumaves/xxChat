//
//  InformationCell.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/10.
//


///该cell用于 ** 个人界面** 中显示个人信息

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InformationCell : UITableViewCell

//头像
@property (nonatomic, strong)UIImageView *iconImgView;

//昵称
@property (nonatomic, strong)UILabel *userNameLbl;

//账号
@property (nonatomic, strong)UILabel *accountLbl;

@end

NS_ASSUME_NONNULL_END
