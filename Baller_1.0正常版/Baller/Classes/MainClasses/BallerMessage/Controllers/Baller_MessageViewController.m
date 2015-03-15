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

@interface Baller_MessageViewController ()

@end

static NSString * const Baller_MessageViewCellId = @"Baller_MessageViewCellId";

@implementation Baller_MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([USER_DEFAULT valueForKey:Baller_UserInfo] && ![USER_DEFAULT valueForKey:Baller_RCToken]) {
        //向融云请求token
        [AFNHttpRequestOPManager getRCTokenWithUserId:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"] userName:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"user_name"] portrait_uri:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"photo"] responseBlock:^(id result, NSError *error) {
            DLog(@"result = %@",result);
            if (0 == [[result valueForKey:@"errorcode"] intValue]) {
                [USER_DEFAULT setValue:[result valueForKey:@"token"] forKey:Baller_RCToken];
            }
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    // 连接融云服务器。
    [RCIM connectWithToken:[USER_DEFAULT valueForKey:Baller_RCToken] completion:^(NSString *userId) {
        // 此处处理连接成功。
        NSLog(@"Login successfully with userId: %@.", userId);
        
        RCChatViewController * rcChatVC = [[RCIM sharedRCIM]createPrivateChat:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"] title:@"自聊" completion:^{
            
        }];
        rcChatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rcChatVC animated:YES];

    } error:^(RCConnectErrorCode status) {
        // 此处处理连接错误。
        NSLog(@"Login failed.");
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
