//
//  Baller_UpdatePasswordViewController.m
//  Baller
//
//  Created by malong on 15/1/28.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_UpdatePasswordViewController.h"

@interface Baller_UpdatePasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITextField *originPasswordTF;

@property (weak, nonatomic) IBOutlet UITextField * freshPasswordTextFeild;

@property (weak, nonatomic) IBOutlet UITextField *surePasswordTF;

@end

@implementation Baller_UpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"密码修改";
    UIImage * image = nil;
    if ([USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]) {
        image = [UIImage imageWithData:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]];
    }
    [self showBlurBackImageViewWithImage:image?image:[UIImage imageNamed:@"ballPark_default"] belowView:nil];
    
    self.bottomView.layer.cornerRadius = TABLE_CORNERRADIUS;
    self.bottomView.clipsToBounds = YES;
    [self.view bringSubviewToFront:self.bottomView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)makeSureUpdate:(id)sender {
    NSString *origionPassword = _originPasswordTF.text;
    if (!origionPassword.length) {
        [Baller_HUDView bhud_showWithTitle:@"请输入原密码"];
        return;
    }
    NSString *freshPassword = _freshPasswordTextFeild.text;
    NSString *surePassword = _surePasswordTF.text;
    if (!freshPassword.length) {
        [Baller_HUDView bhud_showWithTitle:@"请输入修改后密码"];
        return;
    }
    if (!surePassword.length) {
        [Baller_HUDView bhud_showWithTitle:@"请输入确认密码"];
        return;
    }
    if (![freshPassword isEqualToString:surePassword]) {
        [Baller_HUDView bhud_showWithTitle:@"新密码和确认密码不一致"];
        return;
    }
    NSString *authcode = [USER_DEFAULT valueForKey:Baller_UserInfo_Authcode];
    if (!authcode) {
        return;
    }
    NSDictionary *paras = @{
                            @"authcode" : authcode,
                            @"old_password" : origionPassword,
                            @"new_password":freshPassword,@"confirm_password":surePassword
                            };
    [AFNHttpRequestOPManager getWithSubUrl:Baller_change_password
                                parameters:paras
                             responseBlock:^(id result, NSError *error) {
                                 if (error){
                                     [Baller_HUDView bhud_showWithTitle:error.description];
                                     return;
                                 }
                                 if (0 == [[result valueForKey:@"errorcode"] integerValue]) {
                                     [Baller_HUDView bhud_showWithTitle:@"修改成功"];
                                 }else{
                                     [Baller_HUDView bhud_showWithTitle:[result valueForKey:@"msg"]];
                                 }
                             }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
