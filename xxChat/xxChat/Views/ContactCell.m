//
//  ContactCell.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/2.
//

#import "ContactCell.h"

@implementation ContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //控件间隔为20
        CGFloat space = 20;
        
        //头像
        CGFloat iconX = space;
        CGFloat iconY = 10;
        CGFloat iconL = 35;
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconL, iconL)];
        self.icon.backgroundColor = [UIColor grayColor];
        self.icon.layer.cornerRadius = 3;
        [self addSubview:_icon];
        
        //小红点
        CGFloat pointX = iconL-5;
        CGFloat pointY = -5;
        CGFloat pointL = 10;
        self.redPoint = [[UIView alloc]initWithFrame:CGRectMake(pointX, pointY, pointL, pointL)];
        self.redPoint.backgroundColor = [UIColor redColor];
        self.redPoint.layer.cornerRadius = 5;
        self.redPoint.hidden = YES;
        [self.icon addSubview:_redPoint];
        
        //名称
        CGFloat nameX = CGRectGetMaxX(_icon.frame) + space;
        CGFloat nameY = iconY + 8;
        CGFloat nameW = 150;
        CGFloat nameH = 20;
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
        self.name.font = [UIFont systemFontOfSize:16];
        self.name.text = @"这是一个名字";
        [self addSubview:_name];
        
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
