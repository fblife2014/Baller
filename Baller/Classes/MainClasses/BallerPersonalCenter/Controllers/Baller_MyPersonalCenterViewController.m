//
//  Baller_MyPersonalCenterViewController.m
//  Baller
//
//  Created by malong on 15/1/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//
#import "Baller_MyBallParkViewController.h"
#import "Baller_MyPersonalCenterViewController.h"
#import "Baller_PersonalInfoViewController.h"
#import "Baller_MyGameViewController.h"
#import "Baller_PlayerCardViewController.h"
#import "Baller_MyBallFriendsViewController.h"
#import "Baller_MyBasketballTeamViewController.h"

#import "Baller_MyPersonalCenterTableViewCell.h"
#import "Baller_MyCenterTopTableViewCell.h"
@interface Baller_MyPersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * images;
    NSArray * titles;
    CGFloat cellHeight;
}

@end

static NSString * const Baller_MyPersonalCenterTableViewCellId = @"Baller_MyPersonalCenterTableViewCellId";
static NSString * const Baller_MyCenterTopTableViewCellId = @"Baller_MyCenterTopTableViewCellId";

@implementation Baller_MyPersonalCenterViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    cellHeight = NUMBER(80.0, 70.0, 60.0, 60.0);
    
    [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"]];

    self.bottomScrollView.contentSize = CGSizeMake(ScreenWidth, MAX(ScreenHeight, self.myCenterTableView.frame.size.height)+50);
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    
    images = @[[UIImage imageNamed:@"ballPark_default"],[UIImage imageNamed:@"mycenter_basketball"],[UIImage imageNamed:@"mycenter_bisai"],[UIImage imageNamed:@"mycenter_card"],[UIImage imageNamed:@"mycenter_qiuyou"],[UIImage imageNamed:@"mycenter_qiudui"]];
    
    titles = @[@"我的球场",@"我的球场",@"我的比赛",@"我的球员卡",@"我的球友",@"我的球队"];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:BallerLogoutThenLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:BallerUpdateHeadImageNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)reloadData{
    
    [self.myCenterTableView reloadData];
}

- (UITableView *)myCenterTableView
{
    if (!_myCenterTableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(TABLE_SPACE_INSET, TABLE_SPACE_INSET, ScreenWidth-2*TABLE_SPACE_INSET, 6*cellHeight+30.0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = CLEARCOLOR;
        tableView.layer.cornerRadius = TABLE_CORNERRADIUS;
        tableView.layer.borderColor = BALLER_CORLOR_b2b2b2.CGColor;
        tableView.layer.borderWidth = 0.5;
        tableView.backgroundColor = [UIColor clearColor];
        [tableView registerNib:[UINib nibWithNibName:@"Baller_MyPersonalCenterTableViewCell" bundle:nil] forCellReuseIdentifier:Baller_MyPersonalCenterTableViewCellId];
        [tableView registerNib:[UINib nibWithNibName:@"Baller_MyCenterTopTableViewCell" bundle:nil] forCellReuseIdentifier:Baller_MyCenterTopTableViewCellId];
       [self.bottomScrollView addSubview: _myCenterTableView = tableView];
    }
    return _myCenterTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.row?cellHeight:cellHeight+30.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        Baller_MyCenterTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Baller_MyCenterTopTableViewCellId forIndexPath:indexPath];
        cell.headLabel.text = [USER_DEFAULT valueForKey:Baller_UserInfo_Username];
        cell.userIdLabel.text = [NSString stringWithFormat:@"Baller Id:%@",[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"]];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImage]] placeholderImage:[UIImage imageNamed:@"ballPark_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [USER_DEFAULT setValue:UIImageJPEGRepresentation(image, 1.0) forKey:Baller_UserInfo_HeadImageData];
            [self showBlurBackImageViewWithImage:image?:[UIImage imageNamed:@"ballPark_default"]];
        }];
        return cell;
    }else{
        Baller_MyPersonalCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Baller_MyPersonalCenterTableViewCellId forIndexPath:indexPath];
        cell.imageView.image = images[indexPath.row];
        cell.textLabel.text = titles[indexPath.row];
        cell.backgroundColor = (indexPath.row%2)?BALLER_CORLOR_CELL:[UIColor whiteColor];
        return cell;

    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            Baller_PersonalInfoViewController * personalInfoVC = [[Baller_PersonalInfoViewController alloc]init];
            personalInfoVC.title = @"个人资料";
            personalInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personalInfoVC animated:YES];
        }
            break;
        case 1:
            
        {
           //[MLViewConrollerManager pushToTheViewController:@"Baller_MyBallParkViewController" transferInfo:nil];
            Baller_MyBallParkViewController *myBallParkVC = [[Baller_MyBallParkViewController alloc]init];
            myBallParkVC ->soureVC = @"1";
            myBallParkVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myBallParkVC animated:YES];
        }
            break;
        case 2:
        {
            Baller_MyGameViewController * myGameVC = [[Baller_MyGameViewController alloc]init];
            myGameVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myGameVC animated:YES];
        }
            break;
        case 3:
        {
            Baller_PlayerCardViewController * playerCard = [[Baller_PlayerCardViewController alloc]init];
            playerCard.ballerCardType = kBallerCardType_MyPlayerCard;
            playerCard.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:playerCard animated:YES];
        }
            break;
        case 4:
        {
            Baller_MyBallFriendsViewController * ballFriendsVC = [[Baller_MyBallFriendsViewController alloc]init];
            ballFriendsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ballFriendsVC animated:YES];
        }
            break;
        case 5:
        {
            Baller_MyBasketballTeamViewController * myteamVC = [[Baller_MyBasketballTeamViewController alloc]init];
            myteamVC.isCloseMJRefresh = YES;
            myteamVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myteamVC animated:YES];
            
        }
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
