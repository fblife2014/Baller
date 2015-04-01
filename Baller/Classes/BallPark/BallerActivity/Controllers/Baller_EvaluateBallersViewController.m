//
//  Baller_EvaluateBallersViewController.m
//  Baller
//
//  Created by malong on 15/4/1.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_EvaluateBallersViewController.h"
#import "Baller_BallFriendsTableViewCell.h"

@interface Baller_EvaluateBallersViewController ()

@end
static NSString * const Baller_BallFriendsTableViewCellId = @"Baller_BallFriendsTableViewCell";

@implementation Baller_EvaluateBallersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待评价球员列表";
    self.items = [NSMutableArray arrayWithCapacity:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"Baller_BallFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:Baller_BallFriendsTableViewCellId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewDataSource = [[TableViewDataSource alloc] initWithItems:self.items cellIdentifier:Baller_BallFriendsTableViewCellId tableViewConfigureBlock:^(Baller_BallFriendsTableViewCell * cell, Baller_BallerFriendListModel * item)
                                {
                                    cell.friendListModel  = item;
                                }];
    
    self.tableView.dataSource = self.tableViewDataSource;
    
    [self getBallerLists];

    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 获取球员列表
- (void)getBallerLists
{
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_no_appraised_by_activity parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"activity_id":_activityID} responseBlock:^(id result, NSError *error) {
        if (!error) {
            if ([result intForKey:@"errorcode"] == 0) {
                
            }else{
                [Baller_HUDView bhud_showWithTitle:[result valueForKey:@"msg"]];
            }
        }
    }];
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
