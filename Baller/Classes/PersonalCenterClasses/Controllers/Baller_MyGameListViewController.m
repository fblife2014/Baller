//
//  Baller_MyJoinedViewController.m
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyGameListViewController.h"
#import "Baller_GameListTableViewCell.h"
#import "Baller_BallParkActivityListModel.h"
#import "Baller_ActivityDetailViewController.h"
#import "Baller_WaitingEvaluateBallersViewController.h"

@interface Baller_MyGameListViewController ()<UITableViewDelegate>
{
    NSString * actionString; //create/favo/join/marked/no_marked 分别表示 我创建的/收藏的/加入的/评价过的/待评价的
}
@property (nonatomic,strong)UITableView * gameListTableView;
@property (nonatomic,strong)NSMutableArray * gameLists;

@end

@implementation Baller_MyGameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.gameListType) {
        case GameListType_MyOriginate:
            self.navigationItem.title = @"我发起的比赛";
            actionString = @"create";
            break;
        case GameListType_MyCollected:
            self.navigationItem.title = @"我收藏的比赛";
            actionString = @"favo";

            break;
        case GameListType_MyJoined:
            self.navigationItem.title = @"我参加的比赛";
            actionString = @"join";

            break;
        case GameListType_MyEvaluated:
            self.navigationItem.title = @"我评价的比赛";
            actionString = @"marked";

            break;
        case GameListType_WaitEvaluated:
            self.navigationItem.title = @"待评价的比赛";
            actionString = @"no_marked";

            break;
            
        default:
            break;
    }
    UIImage * image = nil;
    if ([USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]) {
        image = [UIImage imageWithData:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]];
        
    }
    [self showBlurBackImageViewWithImage:image?image:[UIImage imageNamed:@"ballPark_default"] belowView:nil];
    [self gameListTableView];

    [self getGameLists];

}

- (NSMutableArray *)gameLists
{
    if (!_gameLists) {
        _gameLists = [NSMutableArray new];
    }
    return _gameLists;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)gameListTableView
{
    if (!_gameListTableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight-NavigationBarHeight) style:UITableViewStylePlain];
        tableView.delegate = self;
        [tableView registerNib:[UINib nibWithNibName:@"Baller_GameListTableViewCell" bundle:nil] forCellReuseIdentifier:@"Baller_GameListTableViewCell"];

        self.tableViewDataSource = [[TableViewDataSource alloc]initWithItems:self.gameLists cellIdentifier:@"Baller_GameListTableViewCell" tableViewConfigureBlock:^(Baller_GameListTableViewCell * cell, Baller_BallParkActivityListModel *item) {
            [cell setActivityModel:item];
        }];
        tableView.dataSource = self.tableViewDataSource;
        tableView.backgroundColor = CLEARCOLOR;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview: _gameListTableView = tableView];
        [self setupMJRefreshScrollView:_gameListTableView];
    }

    return _gameListTableView;
}



- (void)headerRereshing{
    
    [super headerRereshing];
    self.page = 1;
    [self getGameLists];
}

- (void)footerRereshing{
    
    [super footerRereshing];
    if (self.gameLists.count < self.total_num) {
        self.page = 1+self.gameLists.count/10;
        [self getGameLists];
    }
}


#pragma mark 网络请求

- (void)getGameLists{
    __WEAKOBJ(weakSelf, self);
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_special_activities parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"action":actionString,@"page":$str(@"%ld",(long)self.page),@"per_page":@"10"} responseBlock:^(id result, NSError *error) {
        
        if (error)return;
        self.total_num = [result integerForKey:@"total_num"];
        if ([[result valueForKey:@"errorcode"] integerValue] == 0)
        {
            __STRONGOBJ(strongSelf, weakSelf);
            if (self.page == 1) [strongSelf.gameLists removeAllObjects];
            for (NSDictionary * activityDic in [result valueForKey:@"list"]) {
                Baller_BallParkActivityListModel * activityModel = [[Baller_BallParkActivityListModel alloc]initWithAttributes:activityDic];
                [strongSelf.gameLists addObject:activityModel];
            }
            if(strongSelf.gameLists.count >= self.total_num)
            {
                [strongSelf.gameListTableView.footer noticeNoMoreData];
            }else{
                [strongSelf.gameListTableView.footer setState:MJRefreshFooterStateIdle];

            }
            [strongSelf.gameListTableView reloadData];
        }
        
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Baller_BallParkActivityListModel * activityListModel = _gameLists[indexPath.row];
    if (activityListModel.status == 2) {
        [Baller_HUDView bhud_showWithTitle:@"该活动已解散，看看其它的吧👀"];
        return;
    }
    if (_gameListType == GameListType_WaitEvaluated) {
        Baller_WaitingEvaluateBallersViewController * evaluateBallersVC = [[Baller_WaitingEvaluateBallersViewController alloc]init];
        evaluateBallersVC.activityID = activityListModel.activity_id;
        [self.navigationController pushViewController:evaluateBallersVC animated:YES];
    }else{
        Baller_ActivityDetailViewController * activityDVC = [[Baller_ActivityDetailViewController alloc]init];
        activityDVC.activityID = activityListModel.activity_id;
        activityDVC.activity_CreaterID = activityListModel.uid;
        [self.navigationController pushViewController:activityDVC animated:YES];
    }
    
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
