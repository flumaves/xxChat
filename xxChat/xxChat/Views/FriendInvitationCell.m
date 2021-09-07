//
//  FriendInvitationCell.m
//  xxChat
//
//  Created by 谢恩平 on 2021/9/3.
//

#import "FriendInvitationCell.h"

@implementation FriendInvitationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //控件间隔为10
        CGFloat space = 10;
        
        //头像
        CGFloat iconX = space;
        CGFloat iconY = 10;
        CGFloat iconL = 60;
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconL, iconL)];
        self.icon.backgroundColor = [UIColor grayColor];
        self.icon.layer.cornerRadius = 10;
        [self addSubview:_icon];
        
        //名称
        CGFloat nameX = CGRectGetMaxX(_icon.frame) + space;
        CGFloat nameY = iconY ;
        CGFloat nameW = 100;
        CGFloat nameH = 20;
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
        self.name.font = [UIFont systemFontOfSize:16];
        self.name.text = @"这是一个名字";
        [self addSubview:_name];
        
        //ID
        CGFloat IDX = CGRectGetMaxX(_name.frame);
        CGFloat IDY = nameY;
        CGFloat IDW = 100;
        CGFloat IDH = 20;
        self.xxChatID = [[UILabel alloc] initWithFrame:CGRectMake(IDX, IDY, IDW, IDH)];
        self.xxChatID.font = [UIFont systemFontOfSize:15];
        self.xxChatID.text = @"这是一个ID";
        self.xxChatID.textColor = [UIColor lightGrayColor];
        [self addSubview:_xxChatID];
        
        //对方留言
        CGFloat reasonX = nameX;
        CGFloat reasonY = CGRectGetMaxY(_name.frame) + 5;
        CGFloat reasonW = ScreenWidth-reasonX-100;//留100的空间给button
        CGFloat reasonH = 60;
        self.reason = [[UITextView alloc] initWithFrame:CGRectMake(reasonX, reasonY, reasonW, reasonH)];
        self.reason.text = @"对方留言：搞快点，快加你爹，别磨磨唧唧的";
        self.reason.font = [UIFont systemFontOfSize:14];
        self.reason.textColor = [UIColor grayColor];
        self.reason.editable = NO;
        [self addSubview:_reason];
        
        //同意按钮
        CGFloat acptBtnX = CGRectGetMaxX(_reason.frame)+10;
        CGFloat acptBtnY = nameY+5;
        CGFloat acptBtnW = 60;
        CGFloat acptBtnH = 20;
        self.acceptButton = [[UIButton alloc]initWithFrame:CGRectMake(acptBtnX, acptBtnY, acptBtnW, acptBtnH)];
        [self.acceptButton setTitle:@"同意" forState:UIControlStateNormal];
        [self.acceptButton setBackgroundColor:MainColor];
        self.acceptButton.layer.cornerRadius = 10;
        self.acceptButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.acceptButton addTarget:self action:@selector(clickAcceptButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_acceptButton];
        
        //拒绝按钮
        CGFloat rejctBtnX = acptBtnX;
        CGFloat rejctBtnY = acptBtnY+30+15;
        CGFloat rejctBtnW = 60;
        CGFloat rejctBtnH = 20;
        self.rejectButton = [[UIButton alloc]initWithFrame:CGRectMake(rejctBtnX, rejctBtnY, rejctBtnW, rejctBtnH)];
        [self.rejectButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [self.rejectButton setBackgroundColor:[UIColor redColor]];
        self.rejectButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.rejectButton.layer.cornerRadius = 10;
        [self.rejectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rejectButton addTarget:self action:@selector(clickRejectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rejectButton];

    }
    return self;
}


//点击接受按钮的方法
- (void)clickAcceptButton: (UIButton*)button{
    [self.delegate acceptInvitation:self.indexPath];
    
    
}

//点击拒绝按钮的方法
- (void)clickRejectButton: (UIButton*)button{
    [self.delegate rejectInvitation:self.indexPath];
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
