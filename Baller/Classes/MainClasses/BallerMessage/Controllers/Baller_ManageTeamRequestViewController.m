//
//  Baller_ManageTeamRequestViewController.m
//  Baller
//
//  Created by malong on 15/4/5.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_ManageTeamRequestViewController.h"

@interface Baller_ManageTeamRequestViewController ()
{
    UIView * buttonBottom;
}
@end

@implementation Baller_ManageTeamRequestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = nil;

    buttonBottom = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2.0-60.0, 7.0, 120, 30)];
    buttonBottom.layer.cornerRadius = 6;
    buttonBottom.layer.masksToBounds = YES;

    UIButton * agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeButton.titleLabel.font = SYSTEM_FONT_S(15.0);
    agreeButton.titleLabel.textColor = [UIColor whiteColor];
    agreeButton.backgroundColor = UIColorFromRGB(0x51d3b7);
    agreeButton.frame = CGRectMake(0.0, 0.0, 60.0, 30);
    [agreeButton addTarget:self action:@selector(agreeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [agreeButton setTitle:@"同意" forState:UIControlStateNormal];
    [buttonBottom addSubview:agreeButton];
    
    UIButton * rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rejectButton.titleLabel.font = SYSTEM_FONT_S(15.0);
    rejectButton.titleLabel.textColor = [UIColor whiteColor];
    rejectButton.backgroundColor = UIColorFromRGB(0xf07d8a);
    rejectButton.frame = CGRectMake(60.0, 0.0, 60.0, 30);
    [rejectButton addTarget:self action:@selector(rejectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [rejectButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [buttonBottom addSubview:rejectButton];
    self.navigationItem.titleView = buttonBottom;
    
    // Do any additional setup after loading the view.
}

- (void)agreeButtonAction
{
    
    [AFNHttpRequestOPManager getWithSubUrl:Baller_team_check_join parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"tm_id":_tm_id,@"action":@"pass"} responseBlock:^(id result, NSError *error) {
        if (!error) {
            if ([result intForKey:@"errorcode"] == 0) {
                self.navigationItem.titleView = nil;

            }
            [Baller_HUDView bhud_showWithTitle:[result stringForKey:@"msg"]];
        }
    }];
}

- (void)rejectButtonAction
{
    
    [AFNHttpRequestOPManager getWithSubUrl:Baller_team_check_join parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"tm_id":_tm_id,@"action":@"no_pass"} responseBlock:^(id result, NSError *error) {
        if (!error) {
            if ([result intForKey:@"errorcode"] == 0) {
                self.navigationItem.titleView = nil;
            }
            [Baller_HUDView bhud_showWithTitle:[result stringForKey:@"msg"]];
        }

    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
