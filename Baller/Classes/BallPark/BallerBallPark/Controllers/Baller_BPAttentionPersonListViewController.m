//
//  Baller_BPAttentionPersonListViewController.m
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BPAttentionPersonListViewController.h"

#import "Baller_BallParkListModel.h"
#import "Baller_BallTeamInfo.h"

#import "TableViewDataSource.h"

#import "Baller_BPAttentionPersonListHeader.h"
#import "Baller_BPAttentionPersonCollectionViewCell.h"
#import "Baller_BPAttentionPersonCellFlowLayout.h"
#import "Baller_BPAttentionTeamTableViewCell.h"

@interface Baller_BPAttentionPersonListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate>
{
    Baller_BPAttentionPersonListHeader * bpHeaderView;
    UICollectionView * ballerCollectionView;
    UITableView * teamTableView;
    TableViewDataSource * tableViewDataSource;
}
@property (nonatomic,strong)NSMutableArray * ballers;
@property (nonatomic,strong)NSMutableArray * teams;
@end

@implementation Baller_BPAttentionPersonListViewController

- (void)loadView{
    [super loadView];
    
    //1、顶部分栏
    bpHeaderView = [[Baller_BPAttentionPersonListHeader alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 40.0)];
    bpHeaderView.target = self;
    bpHeaderView.leftClickedAction = @selector(bpAttention_ShowBaller);
    bpHeaderView.rightClickedAction = @selector(bpAttention_ShowBallTeam);
    [bpHeaderView leftButtonClicked:bpHeaderView.leftButton];
    [self.view addSubview:bpHeaderView];
    
}

/*!
 *  @brief  显示网格视图
 */
- (void)showBallerCollectionView{
    if (teamTableView) {
        [teamTableView removeFromSuperview];
    }
    
    if (!ballerCollectionView) {
        
        Baller_BPAttentionPersonCellFlowLayout * layout = [[Baller_BPAttentionPersonCellFlowLayout alloc] init];
        
       ballerCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0.0, 40.0, ScreenWidth, ScreenHeight-NavigationBarHeight-40.0) collectionViewLayout:layout];
        ballerCollectionView.showsHorizontalScrollIndicator = NO;

        ballerCollectionView.backgroundColor = UIColorFromRGB(0xe7e7e7);
        
        [ballerCollectionView registerNib:[UINib nibWithNibName:@"Baller_BPAttentionPersonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Baller_BPAttentionPersonCollectionViewCellId"];
        ballerCollectionView.delegate = self;
        ballerCollectionView.dataSource = self;
    }
    [self.view addSubview:ballerCollectionView];
    
}

/*!
 *  @brief  显示球队列表
 */
- (void)showTeamTableView{
    if (ballerCollectionView) {
        [ballerCollectionView removeFromSuperview];
    }
    
    if(!teamTableView){
        teamTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 40.0, ScreenWidth, ScreenHeight-NavigationBarHeight-40.0) style:UITableViewStylePlain];
        teamTableView.backgroundColor = CLEARCOLOR;
        teamTableView.backgroundView = nil;
        teamTableView.delegate = self;
        teamTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [teamTableView registerNib:[UINib nibWithNibName:@"Baller_BPAttentionTeamTableViewCell" bundle:nil] forCellReuseIdentifier:@"Baller_BPAttentionTeamTableViewCellId"];
        self.teams = $marrnew;
        
        for (int i = 0; i < 10; i++) {
            Baller_BallTeamInfo * teamInfo = [[Baller_BallTeamInfo alloc]init];
            teamInfo.teamName = $str(@"北大勇士队%d",i);
            teamInfo.teamNumber = i+1;
            teamInfo.logoImageUrl = @"";
            [_teams addObject:teamInfo];
        }
        
        tableViewDataSource = [[TableViewDataSource alloc] initWithItems:self.teams cellIdentifier:@"Baller_BPAttentionTeamTableViewCellId" tableViewConfigureBlock:^(Baller_BPAttentionTeamTableViewCell * cell, Baller_BallTeamInfo * item) {
            cell.teamInfo = item;
        }];
        teamTableView.dataSource = tableViewDataSource;
        
    }
    [self.view addSubview:teamTableView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.ballParkModel.court_name;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark header action

- (void)bpAttention_ShowBaller{
    [self showBallerCollectionView];
}

- (void)bpAttention_ShowBallTeam{
    [self showTeamTableView];
}

#pragma mark - Table view delegate

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

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 16.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Baller_BPAttentionPersonCollectionViewCell * bpAttentionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Baller_BPAttentionPersonCollectionViewCellId" forIndexPath:indexPath];
    return bpAttentionCell;
}



#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    
}

#pragma mark UICollectionViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NUMBER(110.0, 100, 90, 90);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
