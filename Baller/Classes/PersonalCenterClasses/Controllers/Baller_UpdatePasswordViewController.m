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
    [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"]];
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
