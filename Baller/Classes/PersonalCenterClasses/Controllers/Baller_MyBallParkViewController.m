//
//  Baller_MyBallParkViewController.m
//  Baller
//
//  Created by malong on 15/1/25.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyBallParkViewController.h"
#import "Baller_MineBallParkTableViewCell.h"
#import "Baller_MyAttentionBallPark.h"
@interface Baller_MyBallParkViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataSourceArray;
    UITableView *myTableView;
    NSInteger   currentPage;
}
@property (nonatomic,strong) UITableView * ballParkTableView;

@end

@implementation Baller_MyBallParkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([soureVC intValue] == 1)
    {
    self.navigationItem.title = @"我的球场";
    }
    if([soureVC intValue] == 2)
    {
        self.navigationItem.title = @"选择球场";
    }
    self.view.backgroundColor = UIColorFromRGB(0xe7e7e7);
  
    self.bottomScrollView.contentSize = CGSizeMake(ScreenWidth, self.ballParkTableView.frame.size.height+30.0+NavigationBarHeight+StatusBarHeight);
    [self ballParkTableView];
    dataSourceArray = [NSMutableArray arrayWithCapacity:1];
    currentPage = 1;
    [self getNewNetData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)ballParkTableView
{
    if (!_ballParkTableView) {
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(TABLE_SPACE_INSET, TABLE_SPACE_INSET, ScreenWidth-2*TABLE_SPACE_INSET, 1270.0) style:UITableViewStylePlain];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        [myTableView registerNib:[UINib nibWithNibName:@"Baller_MineBallParkTableViewCell" bundle:nil] forCellReuseIdentifier:@"Baller_MineBallParkTableViewCell"];
        myTableView.backgroundColor = CLEARCOLOR;
        myTableView.layer.cornerRadius = TABLE_CORNERRADIUS;
        myTableView.layer.borderColor = UIColorFromRGB(0xb2b2b2).CGColor;
        myTableView.layer.borderWidth = 0.5;
        myTableView.scrollEnabled = YES;
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview: _ballParkTableView = myTableView];
        [self setupMJRefreshTableView];
    }
    return _ballParkTableView;
}
- (void)setupMJRefreshTableView{
    [myTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getNewNetData)];
}
-(void)getNewNetData
{
    currentPage = 1;
    [dataSourceArray removeAllObjects];
    NSDictionary *dicParmter = [NSDictionary dictionaryWithObjectsAndKeys:[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"authcode",@"1",@"page",@"10",@"per_page",nil];
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_attend_courts parameters:dicParmter responseBlock:^(id result, NSError *error) {
        [myTableView.header endRefreshing];
        NSArray *array = [result objectForKey:@"list"];
        if(array.count == 10)
        {
            [myTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getAddNetData)];
        }

        if(!error)
        {
            for(NSDictionary *dic in [result objectForKey:@"list"])
            {
                Baller_MyAttentionBallPark *myAttentionBallPark = [[Baller_MyAttentionBallPark alloc] initWithAttributes:dic];
                [dataSourceArray addObject:myAttentionBallPark];
                [myTableView reloadData];
            }
        }
    }];
}
-(void)getAddNetData
{
    currentPage ++;
    NSDictionary *dicParmter = [NSDictionary dictionaryWithObjectsAndKeys:[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"authcode",[NSString stringWithFormat:@"%ld",currentPage],@"page",@"10",@"per_page",nil];
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_attend_courts parameters:dicParmter responseBlock:^(id result, NSError *error) {
        [myTableView.header endRefreshing];
        if(!error)
        {
            NSArray *array = [result objectForKey:@"list"];
            if(array.count < 10)
            {
                [myTableView.footer noticeNoMoreData];
            }
            for(NSDictionary *dic in [result objectForKey:@"list"])
            {
                Baller_MyAttentionBallPark *myAttentionBallPark = [[Baller_MyAttentionBallPark alloc] initWithAttributes:dic];
                [dataSourceArray addObject:myAttentionBallPark];
                [myTableView reloadData];
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
    if ([currentModel.my_home_court intValue] == 1) {
        cell.isHomeCourt = YES;
    }else{
        cell.isHomeCourt = NO;
    }
    cell.ballParkNameLabel.text = currentModel.court_name;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Baller_MyAttentionBallPark *currentModel = (Baller_MyAttentionBallPark *)[dataSourceArray objectAtIndex:indexPath.row];
    if( [soureVC integerValue] == 2)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseZhuChang" object:currentModel];
        [self.navigationController popViewControllerAnimated:YES];
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
