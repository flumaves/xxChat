//
//  InputView.m
//  xxChat
//
//  Created by little_Fking_cute on 2021/8/17.
//

#import "InputView.h"
#import "UIImage+ChangeImage.h"
#import <AVFoundation/AVFoundation.h>
#import "SpectrumView.h"

@interface InputView () <UITextFieldDelegate,AVAudioRecorderDelegate>
//录音机
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

//录音存放目录
@property (nonatomic, strong) NSString *recorderSavePath;

/// 录音光谱的view
@property (nonatomic, strong) SpectrumView *spectrumView;

@end

@implementation InputView

#pragma mark - 录音机
//录音的储存路径
- (NSString *)recorderSavePath {
    if (_recorderSavePath == nil) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        self.recorderSavePath = [path stringByAppendingPathComponent:@"record.caf"];
        
        NSLog(@"%@",self.recorderSavePath);
    }
    return _recorderSavePath;
}

- (AVAudioRecorder *)audioRecorder {
    if (_audioRecorder == nil) {
        NSURL *url = [NSURL URLWithString:self.recorderSavePath];
        //创建录音格式
        NSDictionary *setting = [self getAudioRecorderSetting];
        //创建录音机
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:nil];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;
    }
    return _audioRecorder;
}

//录音机的setting
- (NSDictionary *)getAudioRecorderSetting {
    NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
    //编码格式
    [setting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //采样率
    [setting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    //通道数
    [setting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //采样质量
    [setting setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    return setting;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _fromStatus = InputViewStatusNothing;
        _toStatus = InputViewStatusNothing;
        self.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1];
        
        ///一条细细的分割线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
        view.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        [self addSubview:view];
        
        //光谱view
        CGFloat spectrumX = 0;
        CGFloat spectrumWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat spectrumHeight = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        CGFloat spectrumY = -spectrumHeight;
        _spectrumView = [[SpectrumView alloc] initWithFrame:CGRectMake(spectrumX,
                                                                       spectrumY,
                                                                       spectrumWidth,
                                                                       spectrumHeight)];
        _spectrumView.itemColor = [UIColor whiteColor];
        _spectrumView.itemWidth = 10;
        _spectrumView.numberOfItems = 16;
        [self addSubview:_spectrumView];
        
        CGFloat y = 7; //控件离顶部的距离
        CGFloat space = 5;//控件之间的距离
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        ///几个btn (左一个 右两个）
        CGFloat BtnWidth = 40;
        //录音
        CGFloat recordBtnX = space;
        _recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(recordBtnX, y, BtnWidth, BtnWidth)];
        [_recordBtn setImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(recordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_recordBtn];
        
        //更多
        CGFloat moreBtnX = screenWidth - space - BtnWidth;
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(moreBtnX, y, BtnWidth, BtnWidth)];
        [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
        [self addSubview:_moreBtn];
        
        //表情
        CGFloat emojiBtnX = moreBtnX - space - BtnWidth;
        _emojiBtn = [[UIButton alloc] initWithFrame:CGRectMake(emojiBtnX, y, BtnWidth, BtnWidth)];
        [_emojiBtn addTarget:self action:@selector(emojiBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
        
        
        ///与输入框位置相同的开始录音按钮
        self.beginRecordBtn = [[UIButton alloc] initWithFrame:self.inputTextField.frame];
        [self.beginRecordBtn setTitle:@"按下录音" forState:UIControlStateNormal];
        self.beginRecordBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _beginRecordBtn.layer.cornerRadius = 5;
        _beginRecordBtn.layer.borderColor = [UIColor grayColor].CGColor;
        _beginRecordBtn.layer.borderWidth = 0.5f;
        _beginRecordBtn.hidden = YES;
        _beginRecordBtn.backgroundColor = [UIColor whiteColor];
        [_beginRecordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_beginRecordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        //为录音按钮添加一个长按的手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(beginRecordBtnPress:)];
        [longPress setMinimumPressDuration:0.01];
        [_beginRecordBtn addGestureRecognizer:longPress];
        [self addSubview:_beginRecordBtn];
        
    }
    return self;
}

//长按开始录音按钮的方法
- (void)beginRecordBtnPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"录音开始");
        
        if ([self.audioRecorder isRecording]) {
            [self.audioRecorder stop];
        }
        //清除录音文件
        [self.audioRecorder deleteRecording];
        //创建音频回话对象
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //设置category
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [self.audioRecorder record];
        
        [self.beginRecordBtn setTitle:@"松开结束" forState:UIControlStateNormal];
        __weak InputView *weakSelf = self;
        __weak SpectrumView *weakSpectrumView = self.spectrumView;
        self.spectrumView.itemLevelCallBack = ^() {
            [weakSelf.audioRecorder updateMeters];
            
            float power = [weakSelf.audioRecorder averagePowerForChannel:0];
            weakSpectrumView.level = power;
        };
        self.spectrumView.hidden = NO;
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"终止录音");
        
        [self.audioRecorder stop];

        [self.beginRecordBtn setTitle:@"按下录音" forState:UIControlStateNormal];
        self.spectrumView.hidden = YES;
        //发送语音消息
        [self sendMessage];
    }
}

//发送消息
- (void)sendMessage {
    //获取录音
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_recorderSavePath] error:nil];
    NSData *data = [NSData dataWithContentsOfFile:_recorderSavePath];
    
    JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:data voiceDuration:[NSNumber numberWithDouble:player.duration]];
    //让messageViewController执行代理方法
    if ([self.delegate respondsToSelector:@selector(sendMessage:)]) {
        [self.delegate sendMessage:voiceContent];
    }
}

//点击录音按钮的方法
- (void)recordBtnClick {
    if (_toStatus == InputViewStatusShowVoice) {
        //已经在录音状态 点击recordBtn后展示键盘
        [self.recordBtn setImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
        _fromStatus = _toStatus;
        _toStatus = InputViewStatusShowKeyboard;
        _beginRecordBtn.hidden = YES;
        _inputTextField.hidden = NO;
        [self.inputTextField becomeFirstResponder];
    } else {
        //点击recordBtn后变成录音状态
        [self.recordBtn setImage:[UIImage imageNamed:@"键盘"] forState:UIControlStateNormal];
        //当此时正在展示表情包的时候 把emojiBtn的键盘Image 变成 表情Image
        if (_toStatus == InputViewStatusShowEmoji) {
            [_emojiBtn setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
        }
        _fromStatus = _toStatus;
        _toStatus = InputViewStatusShowVoice;
        _beginRecordBtn.hidden = NO;
        _inputTextField.hidden = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeInputViewFromStatus:ToStatus:)]) {
        [self.delegate changeInputViewFromStatus:_fromStatus ToStatus:_toStatus];
    }
}

//点击表情按钮的方法
- (void)emojiBtnClick {
    if (_toStatus == InputViewStatusShowEmoji) {
        //此时正在显示表情包 点击emojiBtn后展示键盘
        [self.emojiBtn setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
        [self.inputTextField becomeFirstResponder];
        _fromStatus = _toStatus;
        _toStatus = InputViewStatusShowKeyboard;
    } else {
        //点击emojiBtn 后显示表情包
        [self.emojiBtn setImage:[UIImage imageNamed:@"键盘"] forState:UIControlStateNormal];
        //当此时正在录音的时候 把recordBtn的 键盘Image 变成 录音Image
        if (_toStatus == InputViewStatusShowVoice) {
            [_recordBtn setImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
            _beginRecordBtn.hidden = YES;
            _inputTextField.hidden = NO;
        }
        _fromStatus = _toStatus;
        _toStatus = InputViewStatusShowEmoji;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeInputViewFromStatus:ToStatus:)]) {
        [self.delegate changeInputViewFromStatus:_fromStatus ToStatus:_toStatus];
    }
}

//点击更多按钮的方法
- (void)moreBtnClick {
    if (_toStatus == InputViewStatusShowMore) {
        //此时已经显示moreFunctionView 点击后展示键盘
        _fromStatus = _toStatus;
        _toStatus = InputViewStatusShowKeyboard;
        [self.inputTextField becomeFirstResponder];
    } else {
        //点击moreBtn后 显示moreFunctionView
        //此时在 录音状态 或 表情包状态 都重新设置他们的图片
        if (_toStatus == InputViewStatusShowEmoji) {
            [_emojiBtn setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
        } else if (_toStatus == InputViewStatusShowVoice) {
            [_recordBtn setImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
            _beginRecordBtn.hidden = YES;
            _inputTextField.hidden = NO;
        }
        _fromStatus = _toStatus;
        _toStatus = InputViewStatusShowMore;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeInputViewFromStatus:ToStatus:)]) {
        [self.delegate changeInputViewFromStatus:_fromStatus ToStatus:_toStatus];
    }
}

@end
