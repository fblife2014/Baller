//
//  Baller_CreateBallTeamViewController.m
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_CreateBallTeamViewController.h"

@interface Baller_CreateBallTeamViewController ()

@end

@implementation Baller_CreateBallTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建球队";
    [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"]];
    
    self.createTeamCardView = [[Baller_CardView alloc]initWithFrame:CGRectMake(TABLE_SPACE_INSET, TABLE_SPACE_INSET, ScreenWidth-2*TABLE_SPACE_INSET, self.view.frame.size.height-2*TABLE_SPACE_INSET) playerCardType:kBallerCardType_CreateBasketBallTeam];
    if (self.basketBallCreatedBlock) {
        self.createTeamCardView.bottomButtonClickedBlock = [_basketBallCreatedBlock copy];
    }
    [self.view addSubview:self.createTeamCardView];
    // Do any additional setup after loading the view.
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
