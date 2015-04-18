//
//  Baller_CreateBallTeamViewController.m
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_CreateBallTeamViewController.h"

#import "Baller_BallerFriendListModel.h"

@interface Baller_CreateBallTeamViewController ()

@end

static NSString * const CreateTeamSuccessNotification = @"CreateTeamSuccessNotification";


@implementation Baller_CreateBallTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建球队";
    
    self.createTeamCardView = [[Baller_CardView alloc]initWithFrame:CGRectMake(TABLE_SPACE_INSET, TABLE_SPACE_INSET, ScreenWidth-2*TABLE_SPACE_INSET, self.view.frame.size.height-2*TABLE_SPACE_INSET) playerCardType:kBallerCardType_CreateBasketBallTeam];
    
    if ([USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]) {
        UIImage * headImage = [UIImage imageWithData:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]];
        
        [self showBlurBackImageViewWithImage:headImage belowView:nil];
        [[self.createTeamCardView headImageButton]setBackgroundImage:headImage forState:UIControlStateNormal];
        
    }else{
        int gender = [[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"gender"] intValue];
        BOOL isMan = gender == 1;

        [[self.createTeamCardView headImageButton] setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImage]] placeholderImage:[UIImage imageNamed:isMan?@"manHead":@"womenHead"]];
        
    }
    __WEAKOBJ(weakSelf, self);
    self.createTeamCardView.bottomButtonClickedBlock = ^(BallerCardType cardType){
        [weakSelf createBallerTeam];
    };
    
    [self.view addSubview:self.createTeamCardView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 创建球场
/*!
 *  @brief  创建球场
 */
- (void)createBallerTeam{
    
    NSString * teamName = self.createTeamCardView.createTeamView.teamNameTextfield.text;
    if (![LTools isValidateName:teamName]) {
        [Baller_HUDView bhud_showWithTitle:@"请输入合适的球队名"];
        return;
    }
    
    if (!self.createTeamCardView.createTeamView.teamLogoData) {
        [Baller_HUDView bhud_showWithTitle:@"请设置球队logo"];
        return;
    }
    
    if (![[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"court_id"] intValue]) {
        [Baller_HUDView bhud_showWithTitle:@"请先选择主场，再创建球队"];

        return;
    }
    
    NSString * uids = @"";
    for (Baller_BallerFriendListModel * friendModel in [[[self createTeamCardView] createTeamView] invitedFriends]) {
        if (uids.length) {
            uids = $str(@"%@,%@",uids,friendModel.friend_uid);
        }else{
            uids = friendModel.friend_uid;
        }
    };
    
    
    [AFNHttpRequestOPManager postImageWithSubUrl:Baller_team_create parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"team_name":teamName,@"uids":uids,@"court_id":[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"court_id"]?:@""} fileName:@"logo" fileData:self.createTeamCardView.createTeamView.teamLogoData fileType:nil responseBlock:^(id result, NSError *error)
    {
        if (error) return ;
        if ([[result valueForKey:@"errorcode"] integerValue] == 0) {
            self.basketBallTeamCreatedBlock(result);
        }
        [Baller_HUDView bhud_showWithTitle:[result valueForKey:@"msg"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:CreateTeamSuccessNotification object:nil];
    }];
    
}

@end
