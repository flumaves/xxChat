//
//  MessageButton.h
//  xxChat
//
//  Created by little_Fking_cute on 2021/9/4.
//

///该uibutton的封装用于聊天界面中每个cell中具体的聊天内容的加载和显示

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageButton : UIButton

//显示秒数的lbl
@property (nonatomic, strong) UILabel *durationLbl;

//显示语音图片的imageView
@property (nonatomic, strong) UIImageView *voiceImgView;
@end

NS_ASSUME_NONNULL_END
