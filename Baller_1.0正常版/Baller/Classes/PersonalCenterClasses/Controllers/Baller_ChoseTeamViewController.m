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
{
    NSMutableArray * teams;
}
@end

@implementation Baller_ChoseTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择球队";
    [self.tableView registerNib:[UINib nibWithNibName:@"Baller_BasketBallTeamTableViewCell" bundle:nil] forCellReuseIdentifier:@"Baller_BasketBallTeamTableViewCell"];
    teams = [NSMutableArray array];
    [teams addObjectsFromArray:@[@"北大小牛1队",@"北大小牛2队",@"北大小牛3队",@"北大小牛4队",@"北大小牛5队",@"北大小牛6队",@"北大小牛7队",@"北大小牛8队",@"北大小牛9队",@"北大小牛10队"]];
    self.tableViewDataSource = [[TableViewDataSource alloc]initWithItems:teams cellIdentifier:@"Baller_BasketBallTeamTableViewCell" tableViewConfigureBlock:^(Baller_BasketBallTeamTableViewCell * cell, NSString * item) {
        cell.textLabel.text = item;
    }];
    self.tableView.dataSource = self.tableViewDataSource;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.choseTeamBlock(nil);
    [self.navigationController popViewControllerAnimated:YES];
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
