//
//  MessageCell.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import <UIKit/UIKit.h>
#import "MessageFrame.h"
#import "Message.h"
#import "MessageButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MessageCellDelegate <NSObject>

- (void)playVoice:(NSData *)data;

- (void)showImageBrowserWithImageTag:(int)imageTag;

@end

@interface MessageCell : UITableViewCell
//内容
@property (nonatomic, strong) MessageButton *contentBtn;

@property (nonatomic, strong) MessageFrame *messageFrame;

@property (nonatomic, weak) id<MessageCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
