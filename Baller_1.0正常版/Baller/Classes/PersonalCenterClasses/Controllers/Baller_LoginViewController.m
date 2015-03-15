//
//  Baller_LoginViewController.m
//  Baller
//
//  Created by malong on 15/1/28.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_LoginViewController.h"
#import "Baller_LoginView.h"

@interface Baller_LoginViewController ()<UITextFieldDelegate>
{
    UIView * bottomView;
}
@end

@implementation Baller_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"]];
    
    __WEAKOBJ(weakSelf, self);
    Baller_LoginView * baller_loginView = [[Baller_LoginView alloc]initWithFrame:[UIScreen mainScreen].bounds dismissBlock:^(BOOL isLogin){
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:baller_loginView];
    
//    [self setUpSubViews];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpSubViews{
    float origin_x = NUMBER(30.0, 20.0, 10.0, 10.0);
    float bottomViewWidth = ScreenWidth-2*origin_x;

    bottomView = [[UIView alloc]initWithFrame:CGRectMake(origin_x, self.view.frame.size.height/5.0, bottomViewWidth, 231)];
    bottomView.backgroundColor  =[UIColor whiteColor];
    bottomView.layer.cornerRadius = TABLE_CORNERRADIUS;
    bottomView.clipsToBounds = YES;
    [self.view addSubview:bottomView];
    
    float tf_height = 47.0;
    float origin_tf_x = NUMBER(15.0, 12.0, 10.0, 10.0);
    LoginTextFeild * userNameTF = [[LoginTextFeild alloc]initWithFrame:CGRectMake(origin_tf_x, 20.0,bottomViewWidth-2*origin_tf_x , tf_height)];
    userNameTF.placeholder = @"用户名";
    userNameTF.delegate = self;
    [bottomView addSubview:userNameTF];
    
    LoginTextFeild * passwordTF = [[LoginTextFeild alloc]initWithFrame:CGRectMake(origin_tf_x, 80.0,bottomViewWidth-2*origin_tf_x , tf_height)];
    passwordTF.delegate = self;
    passwordTF.placeholder = @"密码";
    [bottomView addSubview:passwordTF];
    
    UIButton * forgetButton = [ViewFactory getAButtonWithFrame:CGRectMake(bottomViewWidth-100.0, 136.0, 100, 35) nomalTitle:@"忘记密码？" hlTitle:@"忘记密码？" titleColor:UIColorFromRGB(0x747474) bgColor:nil nImage:nil hImage:nil action:@selector(forgetButtonAction) target:self buttonTpye:UIButtonTypeCustom];
    forgetButton.titleLabel.font= DEFAULT_BOLDFONT(15.0);

    [bottomView addSubview:forgetButton];
    
    UIButton * loginButton = [ViewFactory getAButtonWithFrame:CGRectMake(0.0, 171.0, bottomViewWidth, 60) nomalTitle:@"登录" hlTitle:@"登录" titleColor:[UIColor whiteColor] bgColor:UIColorFromRGB(0x2e3d51) nImage:nil hImage:nil action:@selector(loginButtonAction) target:self buttonTpye:UIButtonTypeCustom];
    loginButton.titleLabel.font= DEFAULT_BOLDFONT(17.0);
    [bottomView addSubview:loginButton];

    
}

- (void)forgetButtonAction{
    
}

- (void)loginButtonAction{

    [self dismissViewControllerAnimated:YES completion:NULL];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



@implementation LoginTextFeild

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer * line = [CALayer layer];
        line.frame = CGRectMake(0.0, frame.size.height-1.0, frame.size.width, 1.0);
        line.backgroundColor = UIColorFromRGB(0xe7e7e7).CGColor;
        [self.layer addSublayer:line];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.font = DEFAULT_BOLDFONT(17.0);
        self.textColor = [UIColor darkGrayColor];
    }
    return  self;
}

- (void)drawPlaceholderInRect:(CGRect)rect{
        [self.placeholder drawWithRect:CGRectMake(rect.origin.x, rect.origin.y+10, rect.size.width, rect.size.height-10.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0Xced3d7),NSForegroundColorAttributeName,DEFAULT_BOLDFONT(17.0), NSFontAttributeName, nil] context:NULL];
}

@end

