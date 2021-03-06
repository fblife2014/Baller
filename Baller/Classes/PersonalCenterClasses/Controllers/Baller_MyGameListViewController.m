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
    [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"]];
    [self gameListTableView];
    [self setupMJRefreshTableView];
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
    }

    return _gameListTableView;
}

/*!
 *  @brief  设置列表的可刷新性
 */
- (void)setupMJRefreshTableView{
    [self.gameListTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [self.gameListTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.gameListTableView.header endRefreshing];
    });
    self.page = 1;
    [self getGameLists];
}

- (void)footerRereshing{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.gameListTableView.footer endRefreshing];
    });
    self.page = 1+self.gameLists.count/10;
    [self getGameLists];
}


#pragma mark 网络请求

- (void)getGameLists{
    __WEAKOBJ(weakSelf, self);
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_special_activities parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"action":actionString,@"page":$str(@"%ld",(long)self.page),@"per_page":@"10"} responseBlock:^(id result, NSError *error) {
        
        if (error)return;
        
        if ([[result valueForKey:@"errorcode"] integerValue] == 0)
        {
            __STRONGOBJ(strongSelf, weakSelf);
            if (self.page == 1) [strongSelf.gameLists removeAllObjects];
            for (NSDictionary * activityDic in [result valueForKey:@"list"]) {
                Baller_BallParkActivityListModel * activityModel = [[Baller_BallParkActivityListModel alloc]initWithAttributes:activityDic];
                [strongSelf.gameLists addObject:activityModel];
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
