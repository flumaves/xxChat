//
//  FriendInvitationCell.h
//  xxChat
//
//  Created by 谢恩平 on 2021/9/2.
//

#import <UIKit/UIKit.h>
#import "xxChatDelegate.h"
#define MainColor [UIColor colorWithRed:130/255.0 green:151/255.0 blue:206/255.0 alpha:1]
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
NS_ASSUME_NONNULL_BEGIN

@interface FriendInvitationCell : UITableViewCell
//头像
@property (nonatomic, strong)UIImageView *icon;

//名称
@property (nonatomic, strong)UILabel *name;

//ID
@property (nonatomic, strong)UILabel *xxChatID;

//对方留言
@property (nonatomic, strong)UITextView *reason;

//同意按钮
@property (nonatomic,strong)UIButton *acceptButton;

//拒绝按钮
@property (nonatomic,strong)UIButton *rejectButton;



//indexPath,用来确定哪个cell的button被点击了，然后才能找到数组的对应数据
@property (nonatomic,strong)NSIndexPath* indexPath;

//delegate
@property (nonatomic,weak) id<xxChatDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
