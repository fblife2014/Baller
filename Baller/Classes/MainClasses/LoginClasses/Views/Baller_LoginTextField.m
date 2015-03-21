//
//  Baller_LoginTextField.m
//  Baller
//
//  Created by malong on 15/2/26.
//  Copyright (c) 2015年 malong. All rights reserved.
//


#import "Baller_LoginTextField.h"

@interface  Baller_LoginTextField()
{
    float kLoginTextField_Width;
    
    CALayer * _grayLine;
    
    NSString * _rightTitle;
    int countdownNumber;
    NSTimer * _timer;
    
    __weak UIButton * _rightButton;
    
}

@end


@implementation Baller_LoginTextField


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEARCOLOR;
        kLoginTextField_Width = ScreenWidth-2*NUMBER(64.0, 56.0, 46.0, 46.0); //输入框宽度
        
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:17.0];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.keyboardAppearance = UIKeyboardAppearanceAlert;
        [self addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
        
        _grayLine = [[CALayer alloc]init];
        _grayLine.backgroundColor = UIColorFromRGB(0Xb2b2b2).CGColor;
        _grayLine.frame = CGRectMake(0.0, frame.size.height-0.5, frame.size.width, 0.5);
        [self.layer addSublayer:_grayLine];

    }
    return self;
    
}

/*!
 *  @brief  通过监听编辑状态，改变键盘颜色
 *
 *  @param textField 当前编辑输入框
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for(UIView * window in windows){
        NSArray *views = [window subviews];
        for(UIView * view in views){
            if([[NSString stringWithUTF8String:object_getClassName(view)] isEqualToString:@"UIPeripheralHostView"]){
                view.backgroundColor = [UIColor darkGrayColor];
            }
        }
    }
}

- (void)setRightButtonAllwaysShow:(BOOL)rightButtonAllwaysShow{
    if (_rightButtonAllwaysShow == rightButtonAllwaysShow) {
        return;
    }
    _rightButtonAllwaysShow = rightButtonAllwaysShow;
    _rightButton.hidden = rightButtonAllwaysShow?NO:(self.text.length);
}

- (void)setRightButtonAllwaysHide:(BOOL)rightButtonAllwaysHide{
    if (_rightButtonAllwaysHide == rightButtonAllwaysHide) {
        return;
    }
    _rightButtonAllwaysHide = rightButtonAllwaysHide;
    _rightButton.hidden = rightButtonAllwaysHide?YES:(self.text.length);
}


/*!
 *  @brief  text变化后的执行方法
 *
 *  @param textFeild 响应方法的输入框
 */
- (void)textFielddidChange:(UITextField *)textFeild
{
    if (_rightButton) {
        _rightButton.hidden = _rightButtonAllwaysShow?NO:(self.text.length);
        _rightButton.hidden = _rightButtonAllwaysHide?YES:(self.text.length);
        
    }
    if (!_rightButtonAllwaysShow) {
        if (self.text.length == 0) {
            _grayLine.backgroundColor = UIColorFromRGB(0Xb2b2b2).CGColor;
            return;
        }
        if (self.text.length < 4) {
            _grayLine.backgroundColor = [UIColor redColor].CGColor;
            
            return;
        }
        
        if (self.text.length < 7) {
            _grayLine.backgroundColor = [UIColor yellowColor].CGColor;
            
            return;
        }
        
        _grayLine.backgroundColor = [UIColor greenColor].CGColor;
        
    }
}

- (void)drawPlaceholderInRect:(CGRect)rect{
    
    [self.placeholder drawWithRect:CGRectMake(rect.origin.x, rect.origin.y+4, rect.size.width, rect.size.height-4.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0Xa4a4a4),NSForegroundColorAttributeName,SYSTEM_FONT_S(17.0), NSFontAttributeName, nil] context:NULL];
}



/*!
 *  @return 忘记密码按钮
 */
- (void)showRightButtonWithTarget:(id)target
                           action:(SEL)selector
                            title:(NSString *)buttonTitle
{
    if (!_rightButton) {
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_rightButton = rightButton];
    }
    float fontSize = 14.0;
    
    _rightButton.titleLabel.font = SYSTEM_FONT_S(fontSize);
    
    [_rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    _rightTitle = buttonTitle;
    [_rightButton setTitle:buttonTitle forState:UIControlStateNormal];
    [_rightButton setTitle:buttonTitle forState:UIControlStateHighlighted];
    
    float titleWidth = [NSStringManager sizeOfCurrentString:buttonTitle font:fontSize contentSize:CGSizeMake(kLoginTextField_Width, self.frame.size.height-0.5)].width;
    
    _rightButton.frame = CGRectMake(self.frame.size.width-titleWidth, 2.0, titleWidth, self.frame.size.height-0.5);
    
}

/*!
 *  @brief  开始倒计时
 */
- (void)showCountdown
{
    countdownNumber = 60;
    _rightButton.frame = CGRectMake(self.frame.size.width-30, 2.0, 30.0, self.frame.size.height-0.5);
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    [_timer fire];
    
}

/*!
 *  @brief  停止倒计时
 */
- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}

/*!
 *  @brief  验证码倒计时计算
 */
- (void)countdown{
    
    _rightButton.enabled = NO;
    [_rightButton setTitle:$str(@"%ds",countdownNumber) forState:UIControlStateNormal];
    countdownNumber--;
    if (0 == countdownNumber) {
        [self stopTimer];
        _rightButton.enabled = YES;
        countdownNumber = 60;
        [_rightButton setTitle:_rightTitle forState:UIControlStateNormal];
        [_rightButton setTitle:_rightTitle forState:UIControlStateHighlighted];
        float titleWidth = [NSStringManager sizeOfCurrentString:_rightTitle font:14.0 contentSize:CGSizeMake(kLoginTextField_Width, self.frame.size.height-0.5)].width;
        _rightButton.frame = CGRectMake(self.frame.size.width-titleWidth, 2.0, titleWidth, self.frame.size.height-0.5);
    }
    
}


@end


