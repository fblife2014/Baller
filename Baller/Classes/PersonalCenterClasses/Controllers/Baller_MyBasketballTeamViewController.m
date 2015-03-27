//
//  Baller_MyBasketballTeamViewController.m
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyBasketballTeamViewController.h"
#import "Baller_ChoseTeamViewController.h"
#import "Baller_CreateBallTeamViewController.h"
#import "Baller_PlayerCardViewController.h"

#import "Baller_MyBasketballTeamTableViewHeaderView.h"
#import "Baller_MyBasketBallTeamTableViewCell.h"
#import "UIView+ML_BlurView.h"
#import "Baller_BallTeamInfo.h"
#import "Baller_BallTeamMemberInfo.h"
#import "RCIM.h"
#import "RCChatViewController.h"

@interface Baller_MyBasketballTeamViewController () <UITableViewDelegate,RCIMGroupInfoFetcherDelegate>
{
    NSMutableArray *myTeamNumbers; //我的队友
    RCGroup *teamGroup;
}
@property (nonatomic, strong) Baller_BallTeamInfo *teamInfo;
@end

@implementation Baller_MyBasketballTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的球队";
    [self.tableView registerNib:[UINib nibWithNibName:@"Baller_MyBasketBallTeamTableViewCell" bundle:nil] forCellReuseIdentifier:@"Baller_MyBasketBallTeamTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIBarButtonItem *rightItem = [ViewFactory getABarButtonItemWithImage:@"qunliao" imageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -15) target:self selection:@selector(goToGroupChat)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [[AppDelegate sharedDelegate]connectRC];
 
    [self setupTableHeaderViewAndFooterView];
}

/*!
 *  @brief 设置已经加入球队后的headerview和footerview
 */
- (void)setupTableHeaderViewAndFooterView {
    self.tableView.tableHeaderView = nil;
    self.tableView.tableFooterView = nil;
    
    [self getBasketballTeamInfo:^() {
        
        if (self.teamInfo.teamID) {
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
            Baller_MyBasketballTeamTableViewHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"Baller_MyBasketballTeamTableViewHeaderView" owner:nil options:nil] firstObject];
            headerView.memberCount.text = [NSString stringWithFormat:@"%ld", (long)self.teamInfo.memberNumber];
            headerView.courtName.text = self.teamInfo.teamName;
            headerView.captainName.text = self.teamInfo.teamLeaderUserName;
            [headerView.headImageView showBlurWithDuration:0.5 blurStyle:kUIBlurEffectStyleLight belowView:nil];
            self.tableView.tableHeaderView = headerView;
            
            UIView *footerView = [ViewFactory clearViewWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 107.0)];
            UIButton *quitTeamButton = [ViewFactory getAButtonWithFrame:CGRectMake(ScreenWidth / 2.0 - 125.0, 27.0, 250.0, 50.0) nomalTitle:@"退出球队" hlTitle:@"退出球队" titleColor:[UIColor whiteColor] bgColor:UIColorFromRGB(0X611b1b) nImage:nil hImage:nil action:@selector(quitTeamButtonAction) target:self buttonTpye:UIButtonTypeCustom];
            quitTeamButton.titleLabel.font = DEFAULT_BOLDFONT(17.0);
            quitTeamButton.layer.cornerRadius = 7.5;
            [footerView addSubview:quitTeamButton];
            self.tableView.tableFooterView = footerView;
            [self.tableView reloadData];
        }else{
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
            UIView *hasNoTeamHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenWidth)];
            UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 43.0)];
            whiteView.backgroundColor = [UIColor whiteColor];
            [hasNoTeamHeaderView addSubview:whiteView];
            
            [ViewFactory addAlabelForAView:hasNoTeamHeaderView withText:@"选择加入球队或者创建球队，找到自己的梦想之队" frame:CGRectMake(10.0, 15.0, ScreenWidth - 20.0, 13.0) font:SYSTEM_FONT_S(13.0) textColor:UIColorFromRGB(0x282828)];
            hasNoTeamHeaderView.backgroundColor = CLEARCOLOR;
            
            UIButton *jionTeamButton = [ViewFactory getAButtonWithFrame:CGRectMake(ScreenWidth / 2.0 - 125.0, 56.0, 250.0, 50.0) nomalTitle:@"加入球队" hlTitle:@"加入球队" titleColor:[UIColor whiteColor] bgColor:BALLER_CORLOR_NAVIGATIONBAR nImage:nil hImage:nil action:@selector(jionTeamButtonAction) target:self buttonTpye:UIButtonTypeCustom];
            jionTeamButton.titleLabel.font = DEFAULT_BOLDFONT(17.0);
            jionTeamButton.layer.cornerRadius = 7.5;
            [hasNoTeamHeaderView addSubview:jionTeamButton];
            
            UIButton *createTeamButton = [ViewFactory getAButtonWithFrame:CGRectMake(ScreenWidth / 2.0 - 125.0, CGRectGetMaxY(jionTeamButton.frame) + 38.0, 250.0, 50.0) nomalTitle:@"创建球队" hlTitle:@"创建球队" titleColor:[UIColor whiteColor] bgColor:BALLER_CORLOR_NAVIGATIONBAR nImage:nil hImage:nil action:@selector(createTeamButtonAction) target:self buttonTpye:UIButtonTypeCustom];
            createTeamButton.titleLabel.font = DEFAULT_BOLDFONT(17.0);
            createTeamButton.layer.cornerRadius = 7.5;
            [hasNoTeamHeaderView addSubview:createTeamButton];
            
            self.tableView.tableHeaderView = hasNoTeamHeaderView;
        }
        
    }];

}

- (void)getBasketballTeamInfo:(void (^)())completion {
    NSDictionary *paras = @{ @"authcode": [USER_DEFAULT valueForKey:Baller_UserInfo_Authcode] };
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_my_team
                                parameters:paras
                             responseBlock:^(id result, NSError *error) {
                                 if (error) {
                                     return;
                                 }
                                 self.teamInfo = [Baller_BallTeamInfo shareWithServerDictionary:result];
                                 if (completion) {
                                     completion();
                                 }
                             }];
}

#pragma mark 按钮方法
/*!
 *  @brief  前往群聊
 */
- (void)goToGroupChat {
    if (!self.teamInfo.group_id) {
        [Baller_HUDView bhud_showWithTitle:@"尚未开通"];
        return;
    }
    if (!teamGroup) {
        teamGroup = [[RCGroup alloc]init];
        teamGroup.groupId = self.teamInfo.group_id;
        teamGroup.groupName = self.teamInfo.teamName;
        
        [RCIM setGroupInfoFetcherWithDelegate:self];
        [[RCIMClient sharedRCIMClient]syncGroups:@[teamGroup] completion:^{
            NSLog(@"同步成功");
        } error:^(RCErrorCode status) {
            DLog(@"同步群数据status%d",(int)status);
        }];
        
        [[RCIMClient sharedRCIMClient]joinGroup:self.teamInfo.group_id groupName:self.teamInfo.group_name completion:^{
            
        } error:^(RCErrorCode status) {
            
        }];
        
    }


    RCChatViewController *groupChatVC = [[RCChatViewController alloc]init];
    groupChatVC.currentTarget = teamGroup.groupId;
    groupChatVC.conversationType = ConversationType_GROUP;
    groupChatVC.currentTargetName = teamGroup.groupName;
    [self.navigationController pushViewController:groupChatVC animated:YES];
    
}

/*!
 *  @brief  退出球队
 */
- (void)quitTeamButtonAction {
    
    [AFNHttpRequestOPManager getWithSubUrl:Baller_team_out parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode]} responseBlock:^(id result, NSError *error) {
        if (error) return ;
        
        if ([result longForKey:@"errorcode"] == 0) {
            [self setupTableHeaderViewAndFooterView];
        }
    }];
    

}

/*!
 *  @brief  加入球队
 */
- (void)jionTeamButtonAction {

    Baller_ChoseTeamViewController *choseTeamVC = [[Baller_ChoseTeamViewController alloc] init];
    __WEAKOBJ(weakSelf, self)
    choseTeamVC.choseTeamBlock = ^(NSString * chosenTeamId) {
        if (chosenTeamId) {
            [weakSelf setupTableHeaderViewAndFooterView];
        }
    };
    [self.navigationController pushViewController:choseTeamVC animated:YES];
}

/*!
 *  @brief  创建球队
 */
- (void)createTeamButtonAction {
    Baller_CreateBallTeamViewController *createTeamVC = [[Baller_CreateBallTeamViewController alloc] init];
    __WEAKOBJ(weakSelf, self);
    createTeamVC.basketBallTeamCreatedBlock = ^(NSDictionary *resultDic) {
        [MLViewConrollerManager popToLastViewController];
        [weakSelf setupTableHeaderViewAndFooterView];
    };
    [self.navigationController pushViewController:createTeamVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.teamInfo.memberNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Baller_MyBasketBallTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Baller_MyBasketBallTeamTableViewCell" forIndexPath:indexPath];
    [self configUIForCell:cell indexPath:indexPath];
    return cell;
}

#pragma mark - Table view data delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   Baller_BallTeamMemberInfo * memberInfo =  self.teamInfo.members[indexPath.row];
    Baller_PlayerCardViewController * playCardVC = [[Baller_PlayerCardViewController alloc]init];
    playCardVC.uid = memberInfo.uid;
    if ([memberInfo.uid isEqualToString:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"]]) {
        playCardVC.ballerCardType = kBallerCardType_MyPlayerCard;
        
    }else{
        playCardVC.ballerCardType = kBallerCardType_OtherBallerPlayerCard;
        playCardVC.userName = memberInfo.user_name;
    }
    [self.navigationController pushViewController:playCardVC animated:YES];
    
}

#pragma mark - Private

- (void)configUIForCell:(Baller_MyBasketBallTeamTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Baller_BallTeamMemberInfo *teamMemberInfo = [self.teamInfo.members objectAtIndex:indexPath.row];
    [cell.memberImage sd_setImageWithURL:[NSURL URLWithString:teamMemberInfo.photo]];
    cell.memberName.text = teamMemberInfo.user_name;
    
    cell.partnerType = [teamMemberInfo.state integerValue];
    if (indexPath.row == 0) {
        cell.backgroundType = BaseCellBackgroundTypeUpWhite;
    } else if (indexPath.row == 9) {
        cell.backgroundType = (indexPath.row % 2) ? BaseCellBackgroundTypeDownGrey : BaseCellBackgroundTypeDownWhite;
    } else {
        cell.backgroundType = indexPath.row % 2 ? BaseCellBackgroundTypeMiddleGrey : BaseCellBackgroundTypeMiddleWhite;
    }
}

#pragma mark - RCIMGroupInfoFetcherDelegate method
-(void)getGroupInfoWithGroupId:(NSString*)groupId completion:(void (^)(RCGroup *group))completion
{
    
    return completion(teamGroup);
}

@end
