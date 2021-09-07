//
//  InputView.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//


/**
    该view封装用于聊天界面底部的聊天框
 */

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>

NS_ASSUME_NONNULL_BEGIN

/**
    inputView的编辑状态
 */
typedef NS_ENUM(NSInteger, InputViewStatus) {
    InputViewStatusNothing = 100,      //无状态
    InputViewStatusShowVoice,    //录音
    InputViewStatusShowEmoji,     //表情
    InputViewStatusShowMore,     //更多
    InputViewStatusShowKeyboard, //键盘
};

@protocol InputViewDelegate <NSObject>

- (void)sendMessage:(JMSGVoiceContent *)voiceContent;

- (void)changeInputViewFromStatus:(InputViewStatus)fromStatus ToStatus:(InputViewStatus)toStatus;
@end

@interface InputView : UIView

//文本输入框
@property (nonatomic, strong) UITextField *inputTextField;

//录音按钮
@property (nonatomic, strong) UIButton *recordBtn;

//点击录音按钮后将文本输入框替换成按钮
@property (nonatomic, strong) UIButton *beginRecordBtn;

//表情包按钮
@property (nonatomic, strong) UIButton *emojiBtn;

//更多按钮
@property (nonatomic, strong) UIButton *moreBtn;

//inputView的编辑状态
@property (nonatomic, assign) InputViewStatus fromStatus;   //老的编辑状态
@property (nonatomic, assign) InputViewStatus toStatus;     //新的编辑状态

//delegate
@property(nonatomic, weak) id<InputViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
