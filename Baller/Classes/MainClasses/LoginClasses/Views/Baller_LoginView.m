//
//  Baller_LoginView.m
//  Baller
//
//  Created by malong on 15/1/9.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_LoginView.h"
#import "UIView+ML_BlurView.h"
#import "Baller_LoginTextField.h"
#import "FlatButton.h"
#import "Baller_AlertLabel.h"
#import <POP/POP.h>

#import "UMSocial.h"



//登录类型 normal为正常手机登陆，sweibo、qq、weixin分别代表新浪微博、qq、微信登陆
typedef enum{
    Login_Normal = 0,
    Login_Sweibo,
    Login_QQ,
    Login_Weixin
}Login_Type;

//性别
typedef enum{
    Gender_Girl = 1,
    Gender_Boy
}Gender;

@interface Baller_LoginView()

{
    __weak UIImageView * _backImageView;
    
    __weak LoginScrollView * _loginScrollView;  //滑动登录界面
    
}

@property (nonatomic, copy)DismissBlock dismissBlock;

@end

@implementation Baller_LoginView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEARCOLOR;
        self.userInteractionEnabled = YES;
        [self backImageView];
        [self loginScrollView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame dismissBlock:(DismissBlock)block{
    self = [self initWithFrame:frame];
    if (self) {
        self.dismissBlock = [block copy];
    }
    return self;
}
#pragma mark 加载背景和登录滑动图
/*!
 *  @brief  背景图设置
 *
 *  @return 背景图片
 */
- (UIImageView *)backImageView{
    
    if (!_backImageView) {
        
       UIImageView * backImageView = [[UIImageView alloc]initWithImage:IMAGE_FILE($str(IPHONE6P?@"login_back@3x":@"login_back@2x"), @"jpg")];
        backImageView.frame = self.bounds;
        [self addSubview:_backImageView = backImageView];
    }
    return _backImageView;
    
}

/*!
 *  @brief 滚动控件管理视图，可通过调整它的contentsize和contentoffsize来处理效果
 *
 *  @return 滚动控件管理视图
 */
- (LoginScrollView *)loginScrollView{
    if (!_loginScrollView) {
        LoginScrollView * loginScroll = [[LoginScrollView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight)];
        [self addSubview:_loginScrollView = loginScroll];
    }
    
    _loginScrollView.targetViewController = self.targetViewController;
    return _loginScrollView;
}

@end



#pragma mark ------------LoginScrollView--------------

@interface LoginScrollView()<UITextFieldDelegate>
{
    //坐标体系
    float kLoginTextField_OriginX;
    float kLoginTextField_Width;
    float kLoginTextField_Height;
    float kLoginTextField_LineHeight;
    float kLoginTextField_Space;
    float kLoginTextField_UserNameTF_OriginY;
    float kLoginTextField_PasswordTF_OriginY;
    float kLoginButton_OriginY;
    float kThirdLoginButton_OriginY;
    float kThirdLoginButton_Space;
    float kRegisterButton_WH;
    float kLoginScrollView_OffsetY;
    
    __weak UIImageView * _ballerImageView;  //顶部logo图
    
    __weak Baller_LoginTextField * _userNameTF;  //登录时的用户名输入框；注册时为手机号输入框
    
    Baller_LoginTextField * _authCodeTF;  //验证码输入框
    
    __weak Baller_LoginTextField * _passwordNameTF;
    
     FlatButton * _loginButton;
    
    __weak UIButton * _wechatLoginButton;
    __weak UIButton * _tencentLoginButton;
    __weak UIButton * _weiboLoginButton;

    __weak UIButton * _registerButton;
}

@property (nonatomic,strong)Baller_AlertLabel * alertLabel;

@end

@implementation LoginScrollView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        kLoginTextField_OriginX = NUMBER(64.0, 56.0, 46.0, 46.0); //输入框起始x坐标
        kLoginTextField_Width = ScreenWidth-2*(kLoginTextField_OriginX); //输入框宽度
        kLoginTextField_Height = 31.0; //输入框高度
        kLoginTextField_LineHeight = 0.5; //输入框下边线高度
        kLoginTextField_Space = 20.0; //输入框间隔
        kLoginTextField_UserNameTF_OriginY = NUMBER(287.0, 270, 220, 190); //用户输入框起始y坐标
        kLoginTextField_PasswordTF_OriginY = (kLoginTextField_UserNameTF_OriginY) + kLoginTextField_Space + kLoginTextField_Height; //密码输入框起始y坐标
        kLoginButton_OriginY = (kLoginTextField_PasswordTF_OriginY) + 1.5*kLoginTextField_Space + kLoginTextField_Height;//登录按钮起始y坐标
        kThirdLoginButton_OriginY = (kLoginButton_OriginY)+kLoginTextField_Height+40.0; //第三方登录按钮起始y坐标
        kThirdLoginButton_Space = 20.0; //第三方登录按钮间隔
        kRegisterButton_WH = 60.0; //注册按钮宽高
        
        kLoginScrollView_OffsetY = NUMBER(50, 50, 55, 75); //登录滑动视图y坐标偏移量

        
        self.backgroundColor = CLEARCOLOR;
        self.exclusiveTouch = YES;
        
        [self ballerImageView];
        [self userNameTF];
        [self passwordNameTF];
        [self addButtons];
        [self registerButton];
        
        [self thirdLoginButton];
        
        
//        UIButton *btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(10, 300, 200, 50) normalTitle:@"hahha" image:nil backgroudImage:nil superView:self target:self action:@selector(setBufferIndex:)];
//        
//        [self addSubview:btn];
        
    }
    return self;
}

#pragma mark 子页面加载
/*!
 *  @brief  baller logo
 *
 *  @return
 */
- (UIImageView *)ballerImageView{
    if (!_ballerImageView) {
        UIImageView * ballerIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_baller"]];
        [self addSubview:_ballerImageView = ballerIV];
        float width = NUMBER(175.0, 174.0, 125.0, 124.0);
        float height = NUMBER(66.0, 65.0, 46.0, 45.0);
        _ballerImageView.frame = CGRectMake(ScreenWidth/2.0-width/2.0, NUMBER(150.0, 140.0, 115.0, 100.0), width, height);
    }
    return _ballerImageView;
}

/*!
 *  @brief  调整baller图片的宽高
 *
 *  @param width  宽
 *  @param height 高
 */
- (void)setBallerImageViewWithWidth:(CGFloat)width
                             height:(CGFloat)height{
    
    float originY = NUMBER(150.0, 140.0, 115.0, 100.0);
    if(self.loginStatus == kWaitingForRegister) originY = NUMBER(120.0, 110.0, 85.0, 70.0);
    _ballerImageView.frame = CGRectMake(ScreenWidth/2.0-width/2.0, originY, width, height);
    
}

/*!
 *  @brief  用户名
*/
- (Baller_LoginTextField *)userNameTF{
    
    if (!_userNameTF) {
        Baller_LoginTextField * usernameTF = [[Baller_LoginTextField alloc]initWithFrame:CGRectMake(kLoginTextField_OriginX,kLoginTextField_UserNameTF_OriginY, kLoginTextField_Width, kLoginTextField_Height)];
        usernameTF.placeholder = NSLocalizedString(@"UserName", nil);
        usernameTF.delegate = self;
        usernameTF.returnKeyType = UIReturnKeyNext;
        [self addSubview:_userNameTF = usernameTF];
    }
    
    return _userNameTF;
}

- (Baller_LoginTextField *)authCodeTF{
    if (!_authCodeTF) {
        Baller_LoginTextField * authCodeTF = [[Baller_LoginTextField alloc]initWithFrame:CGRectMake(kLoginTextField_OriginX,kLoginTextField_UserNameTF_OriginY, kLoginTextField_Width, kLoginTextField_Height)];
        authCodeTF.placeholder = NSLocalizedString(@"AuthCode", nil);
        authCodeTF.delegate = self;
        authCodeTF.keyboardType = UIKeyboardTypeNumberPad;
        [authCodeTF showRightButtonWithTarget:self action:@selector(getSMSCAPTCHA) title:NSLocalizedString(@"GetSMSAuthCode", nil)];
        authCodeTF.returnKeyType = UIReturnKeyNext;
        _authCodeTF.rightButtonAllwaysShow = YES;
        [self addSubview:_authCodeTF = authCodeTF];
        
    }
    
    return _authCodeTF;
}

/*!
 *  @brief  密码输入框
 */
- (Baller_LoginTextField *)passwordNameTF{
    if (!_passwordNameTF) {
        Baller_LoginTextField * passwordNameTF = [[Baller_LoginTextField alloc]initWithFrame:CGRectMake(kLoginTextField_OriginX,kLoginTextField_PasswordTF_OriginY, kLoginTextField_Width, kLoginTextField_Height)];
        passwordNameTF.placeholder = NSLocalizedString(@"Password", nil);
        passwordNameTF.returnKeyType = UIReturnKeyGo;
        passwordNameTF.secureTextEntry = YES;
        [passwordNameTF showRightButtonWithTarget:self action:@selector(forgetPasswordClickAction) title:NSLocalizedString(@"ForgetPassword", nil)];
        passwordNameTF.delegate = self;
        [self addSubview:_passwordNameTF = passwordNameTF];
    }
    
    return _passwordNameTF;
}
/**
 *  三方登录按钮
 */
- (void)thirdLoginButton
{
    //添加第三方登录按钮
    UIImage * tencentImage = [UIImage imageNamed:@"login_qq"];
    CGFloat thirdLoginWidth = tencentImage.size.width+kThirdLoginButton_Space;
    CGFloat thirdLoginHeight = tencentImage.size.height;
    
    _wechatLoginButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake((ScreenWidth-thirdLoginWidth)/2.0-thirdLoginWidth, kThirdLoginButton_OriginY, thirdLoginWidth, thirdLoginHeight) normalTitle:nil image:[UIImage imageNamed:@"login_wechat"] backgroudImage:nil superView:self target:self action:@selector(wechatLogin)];
    
    [self addSubview:_wechatLoginButton];
    
    
    _tencentLoginButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake((ScreenWidth-thirdLoginWidth)/2.0, kThirdLoginButton_OriginY, thirdLoginWidth, thirdLoginHeight) normalTitle:nil image:[UIImage imageNamed:@"login_qq"] backgroudImage:nil superView:self target:self action:@selector(tencentLogin)];
    
    [self addSubview:_tencentLoginButton];
       
    _wechatLoginButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake((ScreenWidth-thirdLoginWidth)/2.0+thirdLoginWidth, kThirdLoginButton_OriginY, thirdLoginWidth, thirdLoginHeight) normalTitle:nil image:[UIImage imageNamed:@"login_weibo"] backgroudImage:nil superView:self target:self action:@selector(weiboLogin)];
    [self addSubview:_weiboLoginButton];
}

- (UIButton *)addButtons{
    
    if (!_loginButton) {
        
        _loginButton = [[FlatButton alloc]initWithFrame:CGRectMake(kLoginTextField_OriginX, kLoginButton_OriginY, kLoginTextField_Width, kLoginTextField_Height)];
        [_loginButton setTitleColor:UIColorFromRGB(0X696969) forState:UIControlStateNormal];
        [_loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loginButton];
        [_loginButton setFrame:CGRectMake(kLoginTextField_OriginX, kLoginButton_OriginY, kLoginTextField_Width, kLoginTextField_Height)];
        
//        //添加第三方登录按钮
//        UIImage * tencentImage = [UIImage imageNamed:@"login_qq"];
//        CGFloat thirdLoginWidth = tencentImage.size.width+kThirdLoginButton_Space;
//        CGFloat thirdLoginHeight = tencentImage.size.height;
//
//        
//        _wechatLoginButton = [ViewFactory getAButtonWithFrame:CGRectMake((ScreenWidth-thirdLoginWidth)/2.0-thirdLoginWidth, kThirdLoginButton_OriginY, thirdLoginWidth, thirdLoginHeight) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nImage:@"login_wechat" hImage:@"login_wechat" action:@selector(wechatLogin) target:self buttonTpye:UIButtonTypeCustom];
//        [self addSubview:_wechatLoginButton];
//        
//        
//        _tencentLoginButton = [ViewFactory getAButtonWithFrame:CGRectMake((ScreenWidth-thirdLoginWidth)/2.0, kThirdLoginButton_OriginY, thirdLoginWidth, thirdLoginHeight) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nImage:@"login_qq" hImage:@"login_qq" action:@selector(tencentLogin) target:self buttonTpye:UIButtonTypeCustom];
//        [self addSubview:_tencentLoginButton];
//        
//        _weiboLoginButton = [ViewFactory getAButtonWithFrame:CGRectMake((ScreenWidth-thirdLoginWidth)/2.0+thirdLoginWidth, kThirdLoginButton_OriginY, thirdLoginWidth, thirdLoginHeight) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nImage:@"login_weibo" hImage:@"login_weibo" action:@selector(weiboLogin) target:self buttonTpye:UIButtonTypeCustom];
//        [self addSubview:_weiboLoginButton];
        
    }
    
    return _loginButton;
}

/*!
 *  @return 警示标签
 */
- (Baller_AlertLabel *)alertLabel
{
    if (!_alertLabel) {
        _alertLabel = [Baller_AlertLabel new];
        [self insertSubview:_alertLabel belowSubview:_loginButton];
        _alertLabel.aboveView = _loginButton;
        _alertLabel.frame  = CGRectMake(kLoginTextField_OriginX, kLoginButton_OriginY, kLoginTextField_Width, kLoginTextField_Height);
    }
    return _alertLabel;
}


/*!
 *  @brief 注册按钮
 */
- (UIButton *)registerButton{
    if (!_registerButton) {
        UIButton * registerButton = [ViewFactory getAButtonWithFrame:CGRectMake((ScreenWidth-kRegisterButton_WH)/2.0, ScreenHeight-kRegisterButton_WH-NUMBER(40.0, 30.0, 20.0, 10.0), kRegisterButton_WH, kRegisterButton_WH) nomalTitle:NSLocalizedString(@"Register", nil) hlTitle:NSLocalizedString(@"Register", nil) titleColor:[UIColor whiteColor] bgColor:nil nImage:nil hImage:nil action:@selector(registerButtonAction) target:self buttonTpye:UIButtonTypeCustom];
        registerButton.titleLabel.font = DEFAULT_BOLDFONT(17.0);
        [self addSubview:_registerButton = registerButton];
        
        
    }
    return _registerButton;
}

#pragma mark - 第三方授权

- (void)loginToPlat:(NSString *)snsPlatName
{
    //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
    
    __weak typeof(self)weakSelf = self;
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *rootVc = delegate.window.rootViewController;
    
//    rootVc = [[((UINavigationController *)rootVc) viewControllers] lastObject];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsPlatName];
    snsPlatform.loginClickHandler(rootVc,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        NSLog(@"login response is %@",response);
        
        //获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatName];
            NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,[UMSocialAccountManager socialAccountDictionary]);
            
            Login_Type type;
            if ([snsPlatName isEqualToString:UMShareToSina]) {
                type = Login_Sweibo;
            }else if ([snsPlatName isEqualToString:UMShareToQQ]) {
                type = Login_QQ;
            }else if ([snsPlatName isEqualToString:UMShareToWechatSession]) {
                type = Login_Weixin;
            }
            
            NSLog(@"name %@ photo %@",snsAccount.userName,snsAccount.iconURL);
            [weakSelf loginType:type thirdId:snsAccount.usid nickName:snsAccount.userName thirdphoto:snsAccount.iconURL gender:Gender_Girl password:nil mobile:nil];
        }else
        {
            NSLog(@"hhaha 三方登录错误");
        }
        
    });
}

/**
 *  @param type       (登录方式，normal为正常手机登录，s_weibo、qq、weixin分别代表新浪微博、qq、微信登录) string
 *  @param thirdId    (第三方id，若为第三方登录需要该参数)
 *  @param nickName   (第三方昵称，若为第三方登录需要该参数)
 *  @param thirdphoto (第三方头像，若为第三方登录需要该参数)
 *  @param gender     (性别，若第三方登录可填写，也可不填写，1=》男 2=》女 默认为女) int
 */

- (void)loginType:(Login_Type)loginType
          thirdId:(NSString *)thirdId
         nickName:(NSString *)nickName
       thirdphoto:(NSString *)thirdphoto
           gender:(Gender)gender
         password:(NSString *)password
           mobile:(NSString *)mobile
{
    NSString *type;
    switch (loginType) {
        case Login_Normal:
        {
            type = @"normal";
        }
            break;
        case Login_Sweibo:
        {
            type = @"s_weibo";
        }
            break;
        case Login_QQ:
        {
            type = @"qq";
        }
            break;
        case Login_Weixin:
        {
            type = @"weixin";
        }
            break;
            
        default:
            break;
    }
    
    
    __WEAKOBJ(weakSelf, self);
    
    int gender_id = gender == Gender_Boy ? 2 : 1;
    
    NSString *genderString = [NSString stringWithFormat:@"%d",gender_id];
    
    
    [AFNHttpRequestOPManager getWithSubUrl:Baller_login parameters:@{@"type":type,@"mobile":$safe(mobile),@"password":$safe(password),@"thirdid":$safe(thirdId),@"nickname":$safe(nickName),@"third_photo":$safe(thirdphoto),@"gender":$safe(genderString),@"devicetoken":[USER_DEFAULT valueForKey:Baller_UserInfo_Devicetoken]?:@"",@"login_source":@"ios"} responseBlock:^(id result, NSError *error) {
        if (error) {
            
        }else
        {
            if (0 == [[result valueForKey:@"errorcode"] intValue])
            {
                [self saveUserInfo:(NSDictionary *)result];
                [self dismiss:YES];
                
            }else{
                [self shakeView:_loginButton];
                self.alertLabel.text =[result valueForKey:@"msg"];
                [self.alertLabel showLabel];
            }
        }
    }
     ];
     

    
//    __weak typeof(self)weakSelf = self;
//    
//    NSString *token = [LTools cacheForKey:USER_DEVICE_TOKEN];
//    
//    NSString *url = [NSString stringWithFormat:USER_LOGIN_ACTION,type,password,thirdId,nickName,thirdphoto,gender,token,mobile];
//    
//    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
//    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
//        
//        NSLog(@"result %@ erro %@",result,erro);
//        
//        UserInfo *user = [[UserInfo alloc]initWithDictionary:result];
//        
//        //保存用户信息
//        
//        [LTools cache:user.user_name ForKey:USER_NAME];
//        [LTools cache:user.uid ForKey:USER_UID];
//        [LTools cache:user.authcode ForKey:USER_AUTHOD];
//        [LTools cache:user.photo ForKey:USER_HEAD_IMAGEURL];
//        
//        //保存登录状态 yes
//        
//        [LTools cacheBool:YES ForKey:LOGIN_SERVER_STATE];
//        
//        [LTools showMBProgressWithText:result[RESULT_INFO] addToView:self.view];
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN object:nil];
//        
//        [weakSelf performSelector:@selector(leftButtonTap:) withObject:nil afterDelay:0.2];
//        
//        
//    } failBlock:^(NSDictionary *failDic, NSError *erro) {
//        
//        NSLog(@"failDic %@ erro %@",failDic,erro);
//        
//        [LTools showMBProgressWithText:failDic[RESULT_INFO] addToView:self.view];
//    }];
}


#pragma mark 点击 方法

/*!
 *  @brief  设置当前的登录界面状态
 *
 *  @param loginStatus
 */
- (void)setLoginStatus:(LoginStatus)loginStatus{
    if (_loginStatus == loginStatus) return;
    _loginStatus = loginStatus;
    
    switch (loginStatus) {
        case kWaitingForLogin:
        {
            _passwordNameTF.rightButtonAllwaysHide = NO;
            [_userNameTF setPlaceholder:NSLocalizedString(@"UserName", nil)];
            _userNameTF.keyboardType = UIKeyboardTypeDefault;
            [_loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
            [_loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateHighlighted];
            [_registerButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
            [_registerButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateHighlighted];
            
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:4
                                options:0
                             animations:^{
                                 
                                 [self setBallerImageViewWithWidth:NUMBER(175.0, 174.0, 125.0, 124.0) height:NUMBER(66.0, 65.0, 46.0, 45.0)];
                                 _userNameTF.frame  = CGRectMake(kLoginTextField_OriginX, kLoginTextField_UserNameTF_OriginY, kLoginTextField_Width, kLoginTextField_Height);
                                 
                                 _wechatLoginButton.alpha = 1;
                                 _weiboLoginButton.alpha = 1;
                                 _tencentLoginButton.alpha = 1;
                                 if (_authCodeTF) {
                                     _authCodeTF.alpha = 0;
                                 }
                                 
                                 [self layoutIfNeeded];
                             } completion:NULL];
            
        }
            break;
        case kLoginSuccess:
        {
            [self dismiss:YES];
        }
            break;
        case kWaitingForRegister:
        case kResetPassword:

        {
            [self authCodeTF];
            _passwordNameTF.rightButtonAllwaysHide = YES;
            [_userNameTF setPlaceholder:NSLocalizedString(@"PhoneNumber", nil)];
            _userNameTF.keyboardType = UIKeyboardTypeNumberPad;
            [_registerButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
            [_registerButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateHighlighted];
            
            if (loginStatus == kWaitingForRegister) {
                [_loginButton setTitle:NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
                [_loginButton setTitle:NSLocalizedString(@"Sumbit", nil) forState:UIControlStateHighlighted];
            }else{
                [_loginButton setTitle:@"重置密码" forState:UIControlStateNormal];
                [_loginButton setTitle:@"重置密码" forState:UIControlStateHighlighted];
            }

            
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:4
                                options:0
                             animations:^{
                                 
                                 _userNameTF.frame  = CGRectMake(kLoginTextField_OriginX, kLoginTextField_UserNameTF_OriginY-kLoginTextField_Height-kLoginTextField_Space, kLoginTextField_Width, kLoginTextField_Height);
                                 [self setBallerImageViewWithWidth:NUMBER(125.0, 124.0, 105.0, 104.0) height:NUMBER(46.0, 45.0, 39.0, 38.0)];
                                 _wechatLoginButton.alpha = 0;
                                 _weiboLoginButton.alpha = 0;
                                 _tencentLoginButton.alpha = 0;
                                 _authCodeTF.alpha = 1;
                                 
                                 [self layoutIfNeeded];
                             } completion:NULL];
 
            
        }
            break;
        case kRegisterSuccess:
        {
            [self dismiss:NO];
        }
            break;

    }
}

/*!
 *  @brief  登录界面消失,在登录、注册成功或消失后
 */
- (void)dismiss:(BOOL)isLogin{
    
    __WEAKOBJ(weakSelf, self);
    
    Baller_LoginView * baller_LoginView = (Baller_LoginView *)weakSelf.superview;

    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        baller_LoginView.alpha = 0.0;
        baller_LoginView.dismissBlock(isLogin);

    } completion:^(BOOL finished) {
        if (_authCodeTF) {
            [_authCodeTF stopTimer];
        }
        [baller_LoginView removeFromSuperview];
        [[AppDelegate sharedDelegate]getTokenFromRC];
        [[AppDelegate sharedDelegate]connectRC];
    }];
}

/*!
 *  @brief  忘记按钮点击方法
 */
- (void)forgetPasswordClickAction{
    DLog(@"%s",__FUNCTION__);
    self.loginStatus = kResetPassword;
    
}


/*!
 *  @brief  获取短信验证码方法
 */
- (void)getSMSCAPTCHA{
    DLog(@"%s",__FUNCTION__);
    __WEAKOBJ(weakSelf, self);
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_code parameters:@{@"mobile":_userNameTF.text,@"type":(_loginStatus==kResetPassword)?@"3":@"1"} responseBlock:^(id result, NSError *error) {
        if (error) {
            
        }else{
            if (0 == [[result valueForKey:@"errorcode"] intValue]) {
                [_authCodeTF showCountdown];
                [Baller_HUDView bhud_showWithTitle:@"成功发送验证码！"];
            }else{
                [weakSelf shakeView:_authCodeTF];
                weakSelf.alertLabel.text =[result valueForKey:@"msg"];
                [weakSelf.alertLabel showLabel];
            }
        }
    }];
    
}

/*!
 *  @brief  登录
 */
- (void)loginButtonAction:(FlatButton *)button{
    DLog(@"%s",__FUNCTION__);
    if (_alertLabel) {
        [self.alertLabel hideLabel];
    }
    
    button.userInteractionEnabled = NO;
    _passwordNameTF.rightButtonAllwaysHide = NO;

    //判断输入的内容
    if ([LTools isValidateMobile:_userNameTF.text] && [LTools isValidatePwd:_passwordNameTF.text]) {
        
        button.userInteractionEnabled = YES;
        switch (_loginStatus) {
            case kWaitingForLogin:
            {
                [self userLogin];
            }
                break;
            case kWaitingForRegister:
            {
                [self userRegister];
            }
                break;
            case kResetPassword:
            {
                [self userResetPassword];
            }
                break;
                
            default:
                break;
        }

    }else{
        __WEAKOBJ(weakSelf, self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [weakSelf shakeView:_loginButton];
            weakSelf.alertLabel.text = @"用户名或密码有误";
            [weakSelf.alertLabel showLabel];
            
        });
    }

}

#pragma mark 网络请求
//用户注册
- (void)userRegister{
    [AFNHttpRequestOPManager postWithSubUrl:Baller_register parameters:@{@"mobile":_userNameTF.text,@"code":_authCodeTF.text,@"password":_passwordNameTF.text} responseBlock:^(id result, NSError *error) {
        
        if (error) {
            
        }else{
            if (0 == [[result valueForKey:@"errorcode"] intValue])
            {
                [self saveUserInfo:(NSDictionary *)result];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismiss:NO];
                });
                
            }else{
                [self shakeView:_loginButton];
                self.alertLabel.text =[result valueForKey:@"msg"];
                [self.alertLabel showLabel];
            }
        }
    }];
}

//用户登录
- (void)userLogin
{
    [AFNHttpRequestOPManager postWithSubUrl:Baller_login parameters:@{@"type":@"normal",@"mobile":_userNameTF.text,@"password":_passwordNameTF.text,@"devicetoken":[USER_DEFAULT valueForKey:Baller_UserInfo_Devicetoken]?:@""} responseBlock:^(id result, NSError *error) {
        
        if (error) {
            
        }else{
            if (0 == [[result valueForKey:@"errorcode"] intValue])
            {
                [self saveUserInfo:(NSDictionary *)result];
                [self dismiss:YES];
                
            }else{
                [self shakeView:_loginButton];
                self.alertLabel.text =[result valueForKey:@"msg"];
                [self.alertLabel showLabel];
            }
        }
        
    }];

}

//用户重置密码
- (void)userResetPassword{
    
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_back_password parameters:@{@"mobile":_userNameTF.text,@"code":_authCodeTF.text,@"new_password":_passwordNameTF.text} responseBlock:^(id result, NSError *error) {
        
        if (error) {
            
        }else{
            if (0 == [[result valueForKey:@"errorcode"] intValue])
            {
                [self saveUserInfo:(NSDictionary *)result];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismiss:NO];
                });
                
            }else{
                [self shakeView:_loginButton];
                self.alertLabel.text =[result valueForKey:@"msg"];
                [self.alertLabel showLabel];
            }
        }
    }];
}

#pragma mark 保存用户信息

- (void)saveUserInfo:(NSDictionary *)userInfo{
    
    BACKGROUND_BLOCK(^{
        [USER_DEFAULT setValue:userInfo forKey:Baller_UserInfo];
        [USER_DEFAULT setValue:[userInfo valueForKey:@"photo"] forKey:Baller_UserInfo_HeadImage];
        [USER_DEFAULT setValue:[userInfo valueForKey:@"authcode"] forKey:Baller_UserInfo_Authcode];
        [USER_DEFAULT setValue:[userInfo valueForKey:@"user_name"] forKey:Baller_UserInfo_Username];
        [USER_DEFAULT synchronize];
        
    });
}


/*!
 *  @brief  微信登录
 */
- (void)wechatLogin{
    DLog(@"%s",__FUNCTION__);

    NSLog(@"微信");
    [self loginToPlat:UMShareToWechatSession];

}

/*!
 *  @brief  QQ登录
 */
- (void)tencentLogin{
    DLog(@"%s",__FUNCTION__);
    [self loginToPlat:UMShareToQQ];

}

/*!
 *  @brief  新浪微博登录
 */
- (void)weiboLogin{
    DLog(@"%s",__FUNCTION__);
    [self loginToPlat:UMShareToSina];

}

/*!
 *  @brief  注册按钮方法
 */
- (void)registerButtonAction{
    DLog(@"%s",__FUNCTION__);
    if (self.loginStatus == kWaitingForLogin) {
        
        self.loginStatus = kWaitingForRegister;
        [_passwordNameTF addTarget:_passwordNameTF action:@selector(textFielddidChange:) forControlEvents:UIControlEventEditingChanged];
        ;
        
    }else{
        self.loginStatus = kWaitingForLogin;
        [_passwordNameTF removeTarget:_passwordNameTF action:@selector(textFielddidChange:) forControlEvents:UIControlEventEditingChanged];
    }
}

#pragma mark Animations
/*!
 *  @brief  晃动按钮动画
 */
- (void)shakeView:(UIView *)aView
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    __WEAKOBJ(weakLoginView, aView)
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        weakLoginView.userInteractionEnabled = YES;
    }];
    [aView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

#pragma mark  触摸方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self downContentOffsetY];
    [self endEditing:YES];
}

/*!
 *  @brief  升高scrollview
 */
- (void)upContentOffsetY{
    
    if (self.contentOffset.y != kLoginScrollView_OffsetY) {
        __WEAKOBJ(weakSelf, self);
        
        float width = NUMBER(125.0, 124.0, 105.0, 104.0);
        float height = NUMBER(46.0, 45.0, 39.0, 38.0);
        
        if (self.loginStatus == kWaitingForRegister) {
            width =  NUMBER(105.0, 104.0, 85.0, 84.0);
            height = NUMBER(37.0, 36, 32.5, 32.0);
        }
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.contentOffset = CGPointMake(0.0, kLoginScrollView_OffsetY);
            [weakSelf setBallerImageViewWithWidth:width height:height];
        } completion:NULL];

    }
}

/*!
 *  @brief  下降scrollview
 */
- (void)downContentOffsetY{
    
    __WEAKOBJ(weakSelf, self);
    
    float width = NUMBER(175.0, 174.0, 125.0, 124.0);
    float height = NUMBER(66.0, 65.0, 46.0, 45.0);
    if (self.loginStatus == kWaitingForRegister) {
        width =  NUMBER(125.0, 124.0, 105.0, 104.0);
        height = NUMBER(46.0, 45.0, 39.0, 38.0);
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        weakSelf.contentOffset = CGPointMake(0.0, 0.0);
        [weakSelf setBallerImageViewWithWidth:width height:height];
        
    } completion:NULL];

}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self upContentOffsetY];

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    if ($eql(textField,_userNameTF)) {
        [_passwordNameTF becomeFirstResponder];
    }else if ($eql(textField,_passwordNameTF)){
        [self loginButtonAction:_loginButton];
    }
    return YES;
}

@end
