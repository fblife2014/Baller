//
//  Baller_MyGameViewController.m
//  Baller
//
//  Created by malong on 15/1/25.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyGameViewController.h"
#import "Baller_MyGameListViewController.h"

#import "Baller_GameTableViewCell.h"

@interface Baller_MyGameViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * titles;
}

@property (nonatomic,strong) UITableView * gameTableView;

@end

@implementation Baller_MyGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的比赛";
    [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"]];
    titles = @[@"我发起的比赛",@"我收藏的比赛",@"参加过的比赛",@"评价过的比赛"];
  
    self.bottomScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+30.0);
    [self gameTableView];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)gameTableView
{
    if (!_gameTableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(TABLE_SPACE_INSET, TABLE_SPACE_INSET, ScreenWidth-2*TABLE_SPACE_INSET, 4*PersonInfoCell_Height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[Baller_GameTableViewCell class] forCellReuseIdentifier:@"Baller_GameTableViewCell"];
        tableView.backgroundColor = CLEARCOLOR;
        tableView.layer.cornerRadius = TABLE_CORNERRADIUS;
        tableView.layer.borderColor = UIColorFromRGB(0xb2b2b2).CGColor;
        tableView.layer.borderWidth = 0.5;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       [self.bottomScrollView addSubview: _gameTableView = tableView];
    }
    return _gameTableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PersonInfoCell_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Baller_GameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Baller_GameTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = (indexPath.row%2)?BALLER_CORLOR_CELL:[UIColor whiteColor];
    cell.textLabel.text = titles[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Baller_MyGameListViewController * gameListVC = [[Baller_MyGameListViewController alloc]init];
    [self.navigationController pushViewController:gameListVC animated:YES];
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
