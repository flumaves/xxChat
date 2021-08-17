//
//  InputView.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import "InputView.h"

@implementation InputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1];
        
        //一条细细的分割线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
        view.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        [self addSubview:view];
        
        self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 7, [UIScreen mainScreen].bounds.size.width - 100, 40)];
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
