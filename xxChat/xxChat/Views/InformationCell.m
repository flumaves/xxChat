//
//  InformationCell.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/10.
//

#import "InformationCell.h"

@implementation InformationCell

#pragma mark - 初始化控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        CGFloat iconX = 20;
        CGFloat iconY = 50;
        CGFloat iconL = 70;
        self.iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconL, iconL)];
        self.iconImgView.backgroundColor = [UIColor grayColor];
        self.iconImgView.layer.cornerRadius = 10;
        [self addSubview:_iconImgView];
        
        //账户
        CGFloat accountX = CGRectGetMaxX(self.iconImgView.frame) + 20;
        CGFloat accountY = 55;
        CGFloat accountW = 200;
        CGFloat accountH = 30;
        self.accountLbl = [[UILabel alloc] initWithFrame:CGRectMake(accountX, accountY, accountW, accountH)];
        self.accountLbl.text = @"show account there";
        [self addSubview:_accountLbl];
        
        //用户名
        CGFloat userNameX = accountX;
        CGFloat userNameY = CGRectGetMaxY(self.accountLbl.frame) + 5;
        CGFloat userNameW = 200;
        CGFloat userNameH = 30;
        self.userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(userNameX, userNameY, userNameW, userNameH)];
        self.userNameLbl.textColor = [UIColor grayColor];
        self.userNameLbl.text = @"ID :xxxxxx";
        [self addSubview:_userNameLbl];
        
        //右边的箭头
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
