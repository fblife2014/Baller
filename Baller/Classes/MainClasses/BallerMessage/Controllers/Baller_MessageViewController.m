//
//  Baller_MessageViewController.m
//  Baller
//
//  Created by malong on 15/1/22.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MessageViewController.h"
#import "Baller_MessageViewCell.h"
#import "RCIM.h"
#import "RCChatViewController.h"

@interface Baller_MessageViewController ()<RCIMUserInfoFetcherDelegagte>

@end

static NSString * const Baller_MessageViewCellId = @"Baller_MessageViewCellId";

@implementation Baller_MessageViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BallerLogoutThenLoginNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRCUserinfo];
    [self setupTableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMessageData) name:BallerLogoutThenLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMessageData) name:BallerUpdateHeadImageNotification object:nil];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadMessageData
{
    [[AppDelegate sharedDelegate]getTokenFromRC];
    [[AppDelegate sharedDelegate]connectRC];
    
}

#pragma mark - Table view data source

- (void)setupTableView{
    
    self.items = $marrnew;
    
    for (int i = 0; i<10; i++) {
        [self.items addObject:@(i)];
    }
    
    self.tableViewDataSource = [[TableViewDataSource alloc]initWithItems:self.items cellIdentifier:Baller_MessageViewCellId tableViewConfigureBlock:^(Baller_MessageViewCell * cell, id item) {
    
    }];;
    self.tableView.dataSource = self.tableViewDataSource;
    //发起网络请求
//    [self.tableView headerBeginRefreshing];

}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return PersonInfoCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * uid = [[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"];

    RCChatViewController * rcChatVC = [[RCIM sharedRCIM]createPrivateChat:[uid isEqualToString:@"2"]?@"5":@"2" title:@"自聊" completion:^{
        
    }];
    rcChatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rcChatVC animated:YES];

}

#pragma mark 融云用户系统
- (void)setRCUserinfo{
    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:YES];
}
#pragma mark RCIMUserInfoFetcherDelegagte

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion{
    
    NSString * headImageUrl = [USER_DEFAULT valueForKey:Baller_UserInfo_HeadImage];
    if (!headImageUrl) {
        headImageUrl = [[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"photo"];
    }
    RCUserInfo * myUserInfo = [[RCUserInfo alloc]initWithUserId:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"] name:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"user_name"] portrait:headImageUrl];
    completion(myUserInfo);
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
