//
//  Baller_MyBallParkViewController.m
//  Baller
//
//  Created by malong on 15/1/25.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyBallParkViewController.h"
#import "Baller_MineBallParkTableViewCell.h"
@interface Baller_MyBallParkViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * ballParkTableView;

@end

@implementation Baller_MyBallParkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的球场";
    self.view.backgroundColor = UIColorFromRGB(0xe7e7e7);
  
    self.bottomScrollView.contentSize = CGSizeMake(ScreenWidth, self.ballParkTableView.frame.size.height+30.0+NavigationBarHeight+StatusBarHeight);
    [self ballParkTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)ballParkTableView
{
    if (!_ballParkTableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(TABLE_SPACE_INSET, TABLE_SPACE_INSET, ScreenWidth-2*TABLE_SPACE_INSET, 1270.0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerNib:[UINib nibWithNibName:@"Baller_MineBallParkTableViewCell" bundle:nil] forCellReuseIdentifier:@"Baller_MineBallParkTableViewCell"];
        tableView.backgroundColor = CLEARCOLOR;
        tableView.layer.cornerRadius = TABLE_CORNERRADIUS;
        tableView.layer.borderColor = UIColorFromRGB(0xb2b2b2).CGColor;
        tableView.layer.borderWidth = 0.5;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.bottomScrollView addSubview: _ballParkTableView = tableView];
    }
    return _ballParkTableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Baller_MineBallParkTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Baller_MineBallParkTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.isHomeCourt = YES;
    }else{
        cell.isHomeCourt = NO;
    }
    
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
