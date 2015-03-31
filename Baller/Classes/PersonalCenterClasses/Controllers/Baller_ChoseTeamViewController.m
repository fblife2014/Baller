//
//  Baller_ChoseTeamViewController.m
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_ChoseTeamViewController.h"
#import "Baller_BasketBallTeamTableViewCell.h"

@interface Baller_ChoseTeamViewController ()<UITableViewDelegate>

@end

@implementation Baller_ChoseTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择球队";
    [self.tableView registerNib:[UINib nibWithNibName:@"Baller_BasketBallTeamTableViewCell" bundle:nil] forCellReuseIdentifier:@"Baller_BasketBallTeamTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.items = [NSMutableArray array];
    self.tableViewDataSource = [[TableViewDataSource alloc] initWithItems:self.items cellIdentifier:@"Baller_BasketBallTeamTableViewCell" tableViewConfigureBlock:^(Baller_BasketBallTeamTableViewCell * cell, Baller_BallParkAttentionTeamListModel * item) {
        cell.textLabel.text = item.team_name;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.team_logo] placeholderImage:[UIImage imageNamed:@"ballPark_default"]];
        cell.courtName.text = item.court_name;
    }];
    self.tableView.dataSource = self.tableViewDataSource;
    [self reloadTableView];
}




- (void)reloadTableView
{
    CLLocationCoordinate2D location = {39.91549069,116.38086026};
    __WEAKOBJ(weakSelf, self);
    NSInteger per_page = 10;
    NSDictionary *paras = @{
                            @"authcode" : [USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],
                            @"latitude" : @(location.latitude),
                            @"longitude" : @(location.longitude),
                            @"page" : @(self.page),
                            @"per_page" : @(per_page)
                            };
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_nearby_teams
                                parameters:paras
                             responseBlock:^(id result, NSError *error) {
                                 __STRONGOBJ(strongSelf, weakSelf);
                                 if ([result longForKey:@"errorcode"] == 0){
                                     if (strongSelf.page == 1) {
                                         [strongSelf.items removeAllObjects];
                                     }
                                     
                                     for (NSDictionary * teamInfo in [result arrayForKey:@"list"]) {
                                         [strongSelf.items addObject:[Baller_BallParkAttentionTeamListModel shareWithServerDictionary:teamInfo]];
                                     }
                                     
                                     if (strongSelf.items.count == 0 || strongSelf.items.count%10) {
                                         [strongSelf.tableView.footer noticeNoMoreData];
                                     }
                                     
                                     [strongSelf.tableView reloadData];
                                     
                                 }else if ([result longForKey:@"errorcode"] == 1) {
                                     [Baller_HUDView bhud_showWithTitle:[result stringForKey:@"msg"]];
                                 }else if (error) {
                                     [Baller_HUDView bhud_showWithTitle:error.domain];
                                 }
                            
                             }];
    
}

#pragma mark - Table view data delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Baller_BallParkAttentionTeamListModel * chosedTeam = self.items[indexPath.row];
    __WEAKOBJ(weakSelf, self);
    [AFNHttpRequestOPManager getWithSubUrl:Baller_team_join_team parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"team_id":chosedTeam.team_id} responseBlock:^(id result, NSError *error) {
        if (error) {
            [Baller_HUDView bhud_showWithTitle:error.domain];
            return ;
        };
        __STRONGOBJ(strongSelf, weakSelf);
        if ([result longForKey:@"errorcode"] == 0) {
            [Baller_HUDView bhud_showWithTitle:@"请求已发送！"];
            strongSelf.choseTeamBlock(chosedTeam);
        }
        [strongSelf PopToLastViewController];
        [Baller_HUDView bhud_showWithTitle:[result valueForKey:@"msg"]];

    }];
}

#pragma mark - override

- (void)headerRereshing
{
    [super headerRereshing];
    self.page = 1;
    [self reloadTableView];
}

- (void)footerRereshing
{
    [super footerRereshing];
    if (self.items.count%10 == 0) {
        self.page = self.items.count/10+1;
        [self reloadTableView];
    }
}

@end
