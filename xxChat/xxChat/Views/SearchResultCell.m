//
//  SearchResultCell.m
//  xxChat
//
//  Created by 谢恩平 on 2021/8/30.
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
        self.message = [[UILabel alloc] initWithFrame:CGRectMake(messageX, messageY, messageW, messageH)];
        self.message.text = @"这是ID";
        self.message.font = [UIFont systemFontOfSize:15];
        self.message.textColor = [UIColor grayColor];
        [self addSubview:_message];
        
//        //时间
//        CGFloat timeW = 100;
//        CGFloat timeX = [UIScreen mainScreen].bounds.size.width - timeW - space;
//        CGFloat timeH = 20;
//        CGFloat timeY = nameY;
//        self.time = [[UILabel alloc] initWithFrame:CGRectMake(timeX, timeY, timeW, timeH)];
//        self.time.text = @"2021/7/9";
//        self.time.font = [UIFont systemFontOfSize:13];
//        self.time.textColor = [UIColor grayColor];
//        //设置为右对齐
//        self.time.textAlignment = NSTextAlignmentRight;
//        [self addSubview:_time];
        
        self.rowHeight = CGRectGetMaxY(_icon.frame) + space;
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
