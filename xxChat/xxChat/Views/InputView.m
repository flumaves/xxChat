//
//  InputView.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import "InputView.h"
#import "UIImage+ChangeImage.h"
@implementation InputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1];
        
        ///一条细细的分割线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
        view.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        [self addSubview:view];
        
        CGFloat y = 7; //控件离顶部的距离
        CGFloat space = 5;//控件之间的距离
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        ///几个btn (左一个 右两个）
        CGFloat BtnWidth = 40;
        //录音
        CGFloat recordBtnX = space;
        _recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(recordBtnX, y, BtnWidth, BtnWidth)];
        UIImage *recordImg = [UIImage imageNamed:@"录音"];
        recordImg = [recordImg scaleToSize:CGSizeMake(30, 30)];
        [_recordBtn setImage:recordImg forState:UIControlStateNormal];
        [self addSubview:_recordBtn];
        
        //更多
        CGFloat moreBtnX = screenWidth - space - BtnWidth;
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(moreBtnX, y, BtnWidth, BtnWidth)];
        UIImage *moreImage = [UIImage imageNamed:@"更多"];
        moreImage = [moreImage scaleToSize:CGSizeMake(35, 35)];
        [_moreBtn setImage:moreImage forState:UIControlStateNormal];
        [self addSubview:_moreBtn];
        
        //表情
        CGFloat emojiBtnX = moreBtnX - space - BtnWidth;
        _emojiBtn = [[UIButton alloc] initWithFrame:CGRectMake(emojiBtnX, y, BtnWidth, BtnWidth)];
        [_emojiBtn setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
        [self addSubview:_emojiBtn];
        
        ///输入框
        CGFloat textFieldX = CGRectGetMaxX(_recordBtn.frame) + space;
        CGFloat textFieldWidth = emojiBtnX - space - textFieldX;
        self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, y, textFieldWidth, BtnWidth)];
        //添加一个左边视图
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        self.inputTextField.leftView = leftView;
        self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
        self.inputTextField.returnKeyType = UIReturnKeySend;
        self.inputTextField.layer.cornerRadius = 5;
        self.inputTextField.layer.borderColor = [UIColor grayColor].CGColor;
        self.inputTextField.layer.borderWidth = 0.5f;
        self.inputTextField.backgroundColor = [UIColor whiteColor];
        [self addSubview:_inputTextField];
    }
    return self;
}

@end
