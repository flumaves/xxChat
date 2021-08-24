//
//  InputView.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

///该view封装用于聊天界面底部的聊天框

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputView : UIView

//文本输入框
@property (nonatomic, strong) UITextField *inputTextField;

//录音按钮
@property (nonatomic, strong) UIButton *recordBtn;

//表情包按钮
@property (nonatomic, strong) UIButton *emojiBtn;

//更多按钮
@property (nonatomic, strong) UIButton *moreBtn;

@end

NS_ASSUME_NONNULL_END
