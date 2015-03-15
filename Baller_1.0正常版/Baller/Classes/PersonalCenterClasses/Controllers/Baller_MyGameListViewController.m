//
//  Baller_MyJoinedViewController.m
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyGameListViewController.h"
#import "Baller_GameListTableViewCell.h"

@interface Baller_MyGameListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView * gameListTableView;
@end

@implementation Baller_MyGameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.gameListType) {
        case GameListType_MyOriginate:
            self.navigationItem.title = @"我发起的比赛";

            break;
        case GameListType_MyCollected:
            self.navigationItem.title = @"我收藏的比赛";

            break;
        case GameListType_MyJoined:
            self.navigationItem.title = @"我参加的比赛";

            break;
        case GameListType_MyEvaluated:
            self.navigationItem.title = @"我评价的比赛";

            break;
            
        default:
            break;
    }
    [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"]];
    [self gameListTableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)gameListTableView
{
    if (!_gameListTableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(TABLE_SPACE_INSET, TABLE_SPACE_INSET, ScreenWidth-2*TABLE_SPACE_INSET, 1100.0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = NO;
        [tableView registerNib:[UINib nibWithNibName:@"Baller_GameListTableViewCell" bundle:nil] forCellReuseIdentifier:@"Baller_GameListTableViewCell"];
        tableView.backgroundColor = CLEARCOLOR;
        tableView.layer.cornerRadius = TABLE_CORNERRADIUS;
        tableView.layer.borderColor = UIColorFromRGB(0xb2b2b2).CGColor;
        tableView.layer.borderWidth = 0.5;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.bottomScrollView addSubview: _gameListTableView = tableView];
    }
    self.bottomScrollView.contentSize = CGSizeMake(ScreenWidth, 1200);

    return _gameListTableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Baller_GameListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Baller_GameListTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = (indexPath.row%2)?BALLER_CORLOR_CELL:[UIColor whiteColor];
    [cell setGameStadus:(indexPath.row)%3];
    return cell;
    
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
