//
//  Baller_ChoseTeamViewController.m
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_ChoseTeamViewController.h"
#import "Baller_BasketBallTeamTableViewCell.h"
#import "Baller_BallTeamInfo.h"

@interface Baller_ChoseTeamViewController ()<UITableViewDelegate>
@property (nonatomic, strong) NSArray *teams;
@end

@implementation Baller_ChoseTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择球队";
    [self.tableView registerNib:[UINib nibWithNibName:@"Baller_BasketBallTeamTableViewCell" bundle:nil] forCellReuseIdentifier:@"Baller_BasketBallTeamTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self reloadTableView:self.teams];
}

- (void)reloadTableView:(NSArray *)teams
{
    CLLocationCoordinate2D location = {39.91549069,116.38086026};
    __WEAKOBJ(weakSelf, self);
    [self getTeamInfoWithLocation:location array:teams completion:^(NSArray *newData){
        __STRONGOBJ(strongSelf, weakSelf);
        strongSelf.teams = newData;
        strongSelf.tableViewDataSource = [[TableViewDataSource alloc] initWithItems:strongSelf.teams cellIdentifier:@"Baller_BasketBallTeamTableViewCell" tableViewConfigureBlock:^(Baller_BasketBallTeamTableViewCell * cell, Baller_BallTeamInfo * item) {
            cell.textLabel.text = item.teamName;
            NSLog(@"%@",item.logoImageUrl);
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.logoImageUrl] placeholderImage:[UIImage imageNamed:@"ballPark_default"]];
            cell.courtName.text = item.court_name;
        }];
        strongSelf.tableView.dataSource = strongSelf.tableViewDataSource;
        [strongSelf.tableView reloadData];
    }];
}

- (void)getTeamInfoWithLocation:(CLLocationCoordinate2D)location array:(NSArray *)teams completion:(void (^)(NSArray *))completion
{
    if (!teams) {
        teams = @[];
    }
    NSInteger per_page = 10;
    NSInteger currentCount = teams.count;
    NSDictionary *paras = @{
                            @"authcode" : [USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],
                            @"latitude" : @(location.latitude),
                            @"longitude" : @(location.longitude),
                            @"page" : @(currentCount / per_page),
                            @"per_page" : @(per_page)
                            };
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_nearby_teams
                                parameters:paras
                             responseBlock:^(id result, NSError *error) {
                                 NSMutableArray *array = teams.mutableCopy;
                                 if ([result longForKey:@"errorcode"] == 0){
                                     [array addObjectsFromArray:[Baller_BallTeamInfo teamsWithArray:[result arrayForKey:@"list"]]];
                                 }else if ([result longForKey:@"errorcode"] == 1) {
                                     [Baller_HUDView bhud_showWithTitle:[result stringForKey:@"msg"]];
                                 }else if (error) {
                                     [Baller_HUDView bhud_showWithTitle:error.domain];
                                 }
                                 if (completion) {
                                     completion([NSArray arrayWithArray:array]);
                                 }
                             }];
}

#pragma mark - Table view data delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.choseTeamBlock(nil);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - override

- (void)headerRereshing
{
    [self reloadTableView:@[]];
}

- (void)footerRereshing
{
    [self reloadTableView:self.teams];
}

@end
