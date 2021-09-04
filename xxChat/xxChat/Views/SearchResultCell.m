//
//  SearchResultCell.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/3.
//

#import "SearchResultCell.h"

@implementation SearchResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //控件间隔为15
        CGFloat space = 15;
        
        //头像
        CGFloat iconX = space;
        CGFloat iconY = 5;
        CGFloat iconL = 60;
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconL, iconL)];
        self.icon.backgroundColor = [UIColor grayColor];
        self.icon.layer.cornerRadius = 10;
        [self addSubview:_icon];
        
        //名称
        CGFloat nameX = CGRectGetMaxX(_icon.frame) + space;
        CGFloat nameY = iconY + 5;
        CGFloat nameW = 150;
        CGFloat nameH = 20;
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
        self.name.font = [UIFont systemFontOfSize:18];
        self.name.text = @"这是一个名字";
        [self addSubview:_name];
        
        //xxChatID 和群组的gid
        CGFloat messageX = nameX;
        CGFloat messageY = CGRectGetMaxY(_name.frame) + 10;
        CGFloat messageW = nameW;
        CGFloat messageH = 15;
        self.ID = [[UILabel alloc] initWithFrame:CGRectMake(messageX, messageY, messageW, messageH)];
        self.ID.text = @"这是ID";
        self.ID.font = [UIFont systemFontOfSize:15];
        self.ID.textColor = [UIColor grayColor];
        [self addSubview:_ID];
        
        
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
