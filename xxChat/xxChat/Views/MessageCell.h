//
//  MessageCell.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import <UIKit/UIKit.h>
#import "MessageFrame.h"
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MessageCellDelegate <NSObject>

- (void)playVoice:(NSData *)data;

@end

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) MessageFrame *messageFrame;

@property (nonatomic, weak) id<MessageCellDelegate> delegate;

+(instancetype) cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
