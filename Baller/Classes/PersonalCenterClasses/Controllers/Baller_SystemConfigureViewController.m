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
    [self.naviTitleScrollView resetTitle:@"系统设置"];

    UIImage * image = nil;
    if ([USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]) {
        image = [UIImage imageWithData:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]];
    }
    [self showBlurBackImageViewWithImage:image?image:[UIImage imageNamed:@"ballPark_default"] belowView:nil];
    [self.bottomScrollView addSubview:self.systemConfigureTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)systemConfigureTableView
{
    if (!_systemConfigureTableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(TABLE_SPACE_INSET, TABLE_SPACE_INSET, ScreenWidth-2*TABLE_SPACE_INSET, 360.0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
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

- (void)logoutButtonAction
{
    [AFNHttpRequestOPManager getWithSubUrl:Baller_logout parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode]} responseBlock:^(id result, NSError *error) {
        if ([[result valueForKey:@"errorcode"] integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:NO];
            Baller_LoginViewController * loginVC = [[Baller_LoginViewController alloc]init];
            [[[AppDelegate sharedDelegate] tabBarContoller] presentViewController:loginVC animated:YES completion:^{
                [[[AppDelegate sharedDelegate] tabBarContoller] setSelectedIndex:1];
                [DataBaseManager deleteDataBase];
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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Baller_SystemConfigureTableViewCell *cell;
    NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"Baller_SystemConfigureTableViewCell" owner:nil options:nil];
    switch (indexPath.row) {
        case 1:
        {
            static NSString *CellIdentiferId = @"Baller_SystemConfigureTableViewCell_Message";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
            if (!cell) {
                cell = [nibObjects objectAtIndex:1];
            }
            [self configMessageCell:(Baller_SystemConfigureTableViewCell_Message *)cell];
            break;
        }
        case 2:
        {
            static NSString *CellIdentiferId = @"Baller_SystemConfigureTableViewCell_ClearCache";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
            if (!cell) {
                cell = [nibObjects lastObject];
            }
            [self configClearCacheCell:(Baller_SystemConfigureTableViewCell_ClearCache *)cell];
            break;
        }
        default:
        {
            static NSString *CellIdentiferId = @"Baller_SystemConfigureTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
            if (!cell) {
                cell = [nibObjects firstObject];
            }
            break;
        }
    }
    cell.backgroundColor = (indexPath.row%2)?BALLER_CORLOR_CELL:[UIColor whiteColor];
    cell.textLabel.text = @[@"密码修改",@"消息通知提醒",@"清理缓存",@"隐私条款",@"关于"][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            Baller_UpdatePasswordViewController * updateVC = [[Baller_UpdatePasswordViewController alloc]initWithNibName:@"Baller_UpdatePasswordViewController" bundle:nil];
            [self.navigationController pushViewController:updateVC animated:YES];
            break;
        }
        case 2:
        {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [Baller_HUDView bhud_showWithTitle:@"清除成功"];
                Baller_SystemConfigureTableViewCell_ClearCache *cell = (Baller_SystemConfigureTableViewCell_ClearCache *)[tableView cellForRowAtIndexPath:indexPath];
                cell.cacheSizeLabel.text = @"0 M";
            }];
        }
            break;
        case 3:
        {
            Baller_PrivacyPolicyViewController * privacyVC = [[Baller_PrivacyPolicyViewController alloc]init];
            [self.navigationController pushViewController:privacyVC animated:YES];
        }
            break;
        case 4:
        {
            Baller_AboutUserViewController * aboutUsVC = [[Baller_AboutUserViewController alloc]initWithNibName:@"Baller_AboutUserViewController" bundle:nil];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (BOOL)userWeatherReceiveMessage
{
    NSDictionary *userInfo = [USER_DEFAULT valueForKey:Baller_UserInfo];
    return [[userInfo objectForKey:@"msg_status"] boolValue];
}

- (void)configMessageCell:(Baller_SystemConfigureTableViewCell_Message *)cell
{
    cell.messageSwitch.on = [self userWeatherReceiveMessage];
    __WEAKOBJ(weakCell, cell);
    cell.onMessageSwitch = ^(UISwitch *messageSwich){
        NSString *authcode = [USER_DEFAULT valueForKey:Baller_UserInfo_Authcode];
        NSDictionary *paras = @{
                                @"authcode" : authcode,
                                @"action" : @(messageSwich.on)
                                };
        [AFNHttpRequestOPManager getWithSubUrl:Baller_msg_switch parameters:paras responseBlock:^(id result, NSError *error) {
            __STRONGOBJ(strongCell, weakCell);
            if (error){
                strongCell.messageSwitch.on = !strongCell.messageSwitch.on;
                [Baller_HUDView bhud_showWithTitle:error.description];
                return;
            }
            if (0 == [[result valueForKey:@"errorcode"] integerValue]) {
                [Baller_HUDView bhud_showWithTitle:[result objectForKey:@"msg"]];
            }else{
                strongCell.messageSwitch.on = !strongCell.messageSwitch.on;
                [Baller_HUDView bhud_showWithTitle:[result valueForKey:@"msg"]];
            }
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[USER_DEFAULT valueForKey:Baller_UserInfo]];
            [userInfo setValue:@(strongCell.messageSwitch.on) forKey:@"msg_status"];
            [USER_DEFAULT setValue:userInfo forKey:Baller_UserInfo];
        }];
    };
}

- (void)configClearCacheCell:(Baller_SystemConfigureTableViewCell_ClearCache *)cell
{
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    if (size == 0) {
        cell.cacheSizeLabel.text = @"0 M";
    }else{
        cell.cacheSizeLabel.text = [NSString stringWithFormat:@"%0.2f M",size / 1024 / 1024.0];
    }
}

@end
