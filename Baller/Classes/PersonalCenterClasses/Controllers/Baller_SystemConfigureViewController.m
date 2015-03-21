//
//  Baller_SystemConfigureViewController.m
//  Baller
//
//  Created by malong on 15/1/28.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_SystemConfigureViewController.h"
#import "Baller_UpdatePasswordViewController.h"
#import "Baller_LoginViewController.h"

#import "Baller_SystemConfigureTableViewCell.h"

@interface Baller_SystemConfigureViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * systemConfigureTableView;

@end


@implementation Baller_SystemConfigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"系统设置";
    [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"]];
    [self.bottomScrollView addSubview:self.systemConfigureTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)systemConfigureTableView
{
    if (!_systemConfigureTableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(TABLE_SPACE_INSET, TABLE_SPACE_INSET, ScreenWidth-2*TABLE_SPACE_INSET, 300.0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerNib:[UINib nibWithNibName:@"Baller_SystemConfigureTableViewCell" bundle:nil] forCellReuseIdentifier:@"Baller_SystemConfigureTableViewCell"];
        tableView.backgroundColor = CLEARCOLOR;
        tableView.layer.cornerRadius = TABLE_CORNERRADIUS;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        [self.bottomScrollView addSubview: _systemConfigureTableView = tableView];
        
    
        UIButton * logoutButton = [ViewFactory getAButtonWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 60) nomalTitle:@"注销" hlTitle:@"注销" titleColor:[UIColor whiteColor] bgColor:UIColorFromRGB(0x2e3d51) nImage:@"zhuxiao" hImage:@"zhuxiao" action:@selector(logoutButtonAction) target:self buttonTpye:UIButtonTypeCustom];
        logoutButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 15, 0.0, 0.0);
        logoutButton.titleLabel.font= DEFAULT_BOLDFONT(17.0);
        tableView.tableFooterView = logoutButton;
        
    }
    return _systemConfigureTableView;
}

- (void)logoutButtonAction{
    [AFNHttpRequestOPManager getWithSubUrl:Baller_logout parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode]} responseBlock:^(id result, NSError *error) {
        if ([[result valueForKey:@"errorcode"] integerValue] == 0) {
            
            Baller_LoginViewController * loginVC = [[Baller_LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:^{
                [USER_DEFAULT removeObjectForKey:Baller_UserInfo];
                [USER_DEFAULT removeObjectForKey:Baller_UserInfo_Authcode];
                [USER_DEFAULT removeObjectForKey:Baller_UserInfo_Username];
                [USER_DEFAULT removeObjectForKey:Baller_UserInfo_Devicetoken];
                [USER_DEFAULT removeObjectForKey:Baller_UserInfo_HeadImage];
                [USER_DEFAULT removeObjectForKey:Baller_UserInfo_HeadImageData];
                [USER_DEFAULT removeObjectForKey:Baller_UserInfo_Height];
                [USER_DEFAULT removeObjectForKey:Baller_UserInfo_Weight];
                [USER_DEFAULT removeObjectForKey:Baller_UserInfo_Position];
                [USER_DEFAULT removeObjectForKey:Baller_UserInfo_Sex];
                [USER_DEFAULT removeObjectForKey:Baller_RCToken];
                [USER_DEFAULT synchronize];
            }];
        }
    }];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Baller_SystemConfigureTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Baller_SystemConfigureTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = (indexPath.row%2)?BALLER_CORLOR_CELL:[UIColor whiteColor];
    cell.textLabel.text = @[@"密码修改",@"消息通知提醒",@"清理缓存",@"关于"][indexPath.row];
    cell.jianTouImageView.hidden = (BOOL)(indexPath.row == 2);
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            Baller_UpdatePasswordViewController * updateVC = [[Baller_UpdatePasswordViewController alloc]init];
            [self.navigationController pushViewController:updateVC animated:YES];
        }
            break;
        case 3:
  
            break;
            
        default:
            break;
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
