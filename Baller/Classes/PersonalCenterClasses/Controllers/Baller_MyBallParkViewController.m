//
//  Baller_MyBallParkViewController.m
//  Baller
//
//  Created by malong on 15/1/25.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyBallParkViewController.h"
#import "Baller_BallParkHomepageViewController.h"
#import "Baller_MineBallParkTableViewCell.h"
#import "Baller_MyAttentionBallPark.h"

#import "MJRefresh.h"


@interface Baller_MyBallParkViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __block NSMutableArray *dataSourceArray;
    Baller_MyAttentionBallPark * opretionBallPark; //正在操作的模型
}
@property (nonatomic,strong) UITableView * ballParkTableView;

@end

@implementation Baller_MyBallParkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [self ballParkTableView];
    dataSourceArray = [NSMutableArray arrayWithCapacity:1];
    if([soureVC intValue] == 1)
    {
        self.navigationItem.title = @"我的球场";
        [self getNewNetData];

    }
    if([soureVC intValue] == 2)
    {
        self.navigationItem.title = @"选择球场";
        [self getNearbyCourts];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)ballParkTableView
{
    if (!_ballParkTableView) {
        _ballParkTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight-NavigationBarHeight) style:UITableViewStylePlain];
        _ballParkTableView.delegate = self;
        _ballParkTableView.dataSource = self;
        [_ballParkTableView registerNib:[UINib nibWithNibName:@"Baller_MineBallParkTableViewCell" bundle:nil] forCellReuseIdentifier:@"Baller_MineBallParkTableViewCell"];
        _ballParkTableView.backgroundColor = CLEARCOLOR;
        _ballParkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview: _ballParkTableView];
        [self setupMJRefreshScrollView:_ballParkTableView];
    }
    return _ballParkTableView;
}


- (void)headerRereshing{
    [super headerRereshing];
    self.page = 1;
    if ([soureVC integerValue] == 1) {
        [self getNewNetData];

    }else if ([soureVC integerValue] == 2){
        [self getNearbyCourts];
    }
}

- (void)footerRereshing{
    [super footerRereshing];
    if (self.total_num > dataSourceArray.count) {
        self.page = dataSourceArray.count/10+1;
        if ([soureVC integerValue] == 1) {
            [self getNewNetData];
            
        }else if ([soureVC integerValue] == 2){
            [self getNearbyCourts];
        }
    }
}

#pragma mark 网络请求
/*!
 *  @brief  获取我关注的球场
 */
-(void)getNewNetData
{
    NSDictionary *dicParmter = [NSDictionary dictionaryWithObjectsAndKeys:[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"authcode",$str(@"%ld",self.page),@"page",@"10",@"per_page",nil];
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_attend_courts parameters:dicParmter responseBlock:^(id result, NSError *error) {

        if(!error)
        {
            if (self.page == 1) {
                [dataSourceArray removeAllObjects];
            }
            for(NSDictionary *dic in [result objectForKey:@"list"])
            {
                Baller_MyAttentionBallPark *myAttentionBallPark = [[Baller_MyAttentionBallPark alloc] initWithAttributes:dic];
                [dataSourceArray addObject:myAttentionBallPark];
                [_ballParkTableView reloadData];
            }
            if(dataSourceArray.count == 0 || dataSourceArray.count%10)
            {
                [_ballParkTableView.footer noticeNoMoreData];
            }
        }
    }];
}

/*!
 *  @brief  获取附近认证了的球场
 */
- (void)getNearbyCourts
{
    CLLocationCoordinate2D currentLocation = [[AppDelegate sharedDelegate] currentLocation];
    
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_nearby_courts parameters:@{@"page":$str(@"%ld",self.page),@"per_page":@"10",@"type":@"authed",@"latitude":$str(@"%lf",currentLocation.latitude),@"longitude":$str(@"%lf",currentLocation.longitude)} responseBlock:^(id result, NSError *error) {
        
        if(!error)
        {
            if (self.page == 1) {
                [dataSourceArray removeAllObjects];
            }
            self.total_num = [result integerForKey:@"total_num"];
            
            for(NSDictionary *dic in [result objectForKey:@"list"])
            {
                Baller_MyAttentionBallPark *myAttentionBallPark = [[Baller_MyAttentionBallPark alloc] initWithAttributes:dic];
                [dataSourceArray addObject:myAttentionBallPark];
                [_ballParkTableView reloadData];
            }
            if(dataSourceArray.count>=self.total_num)
            {
                [_ballParkTableView.footer noticeNoMoreData];
            }else{
                [_ballParkTableView.footer setState:MJRefreshFooterStateIdle];
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSourceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Baller_MineBallParkTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Baller_MineBallParkTableViewCell" forIndexPath:indexPath];
    Baller_MyAttentionBallPark *currentModel = (Baller_MyAttentionBallPark *)[dataSourceArray objectAtIndex:indexPath.row];
    cell.ballParkModel = currentModel;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    opretionBallPark = (Baller_MyAttentionBallPark *)[dataSourceArray objectAtIndex:indexPath.row];
    if( [soureVC integerValue] == 2)
    {
        [AFNHttpRequestOPManager getWithSubUrl:Baller_select_my_court parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"court_id":@(opretionBallPark.court_id)} responseBlock:^(id result, NSError *error) {
            if (error) return ;
            if ([[result valueForKey:@"errorcode"] integerValue] == 0) {
                
                NSMutableDictionary * userinfo = [NSMutableDictionary dictionaryWithDictionary:[USER_DEFAULT valueForKey:Baller_UserInfo]];
                [userinfo setValue:$str(@"%ld",opretionBallPark.court_id) forKey:@"court_id"];
                [userinfo setValue:opretionBallPark.court_name forKey:@"court_name"];

                [USER_DEFAULT setValue:userinfo forKey:Baller_UserInfo];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseZhuChang" object:opretionBallPark];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        Baller_BallParkHomepageViewController * ballParkHomePageVc = [[Baller_BallParkHomepageViewController alloc]init];
        ballParkHomePageVc.court_id = [NSString stringWithFormat:@"%ld",opretionBallPark.court_id];
        ballParkHomePageVc.court_name = opretionBallPark.court_name;
        ballParkHomePageVc.cancelAttentionBlock = ^(NSString * courtId,BOOL isCanceledAttention){

            if (isCanceledAttention) {
                [dataSourceArray removeObject:opretionBallPark];
            }else{
                [dataSourceArray addObject:opretionBallPark];
            }
            [_ballParkTableView reloadData];
            
        };
        ballParkHomePageVc.isCloseMJRefresh = YES;
        [self.navigationController pushViewController:ballParkHomePageVc animated:YES];
        
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
