//
//  Baller_MyBasketballTeamViewController.m
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyBasketballTeamViewController.h"
#import "Baller_ChoseTeamViewController.h"
#import "Baller_CreateBallTeamViewController.h"

#import "Baller_MyBasketBallTeamTableViewCell.h"
#import "UIView+ML_BlurView.h"

@interface Baller_MyBasketballTeamViewController ()<UITableViewDelegate>
{
    NSMutableArray * myTeamNumbers; //我的队友
    BOOL hasOwnTeam;
}

@end

@implementation Baller_MyBasketballTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的球队";
    [self.tableView registerNib:[UINib nibWithNibName:@"Baller_MyBasketBallTeamTableViewCell" bundle:nil] forCellReuseIdentifier:@"Baller_MyBasketBallTeamTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem * rightItem = [ViewFactory getABarButtonItemWithImage:@"qunliao" imageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -15) target:self selection:@selector(goToGroupChat)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self setupTableHeaderViewAndFooterView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 *  @brief 设置已经加入球队后的headerview和footerview
 */
- (void)setupTableHeaderViewAndFooterView{
    self.tableView.tableHeaderView = nil;
    self.tableView.tableFooterView = nil;
    if (hasOwnTeam) {
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        
        UIView * headView = [ViewFactory clearViewWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 101.0)];
        
        UIImageView * headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0., 0., ScreenWidth, 101)];
        headImageView.image = [UIImage imageNamed:@"ballPark_default"];
        [headImageView showBlurWithDuration:0.5 blurStyle:kUIBlurEffectStyleLight hidenViews:nil];
        [headView addSubview:headImageView];
        
        TopLebel * homeCourtLabel = [[TopLebel alloc] initWithFrame:CGRectMake(0.0, 29.0, [NSStringManager sizeOfCurrentString:@"北大球场" font:13.0 contentSize:CGSizeMake(ScreenWidth/2.0, 13.0)].width+20, 51.0) title:@"主场" detail:@"北大球场"];
        homeCourtLabel.center = CGPointMake(headView.center.x, 54.0);
        [headView addSubview:homeCourtLabel];
        
        TopLebel * memberNumberLabel = [[TopLebel alloc] initWithFrame:CGRectMake(0.0, 29.0, [NSStringManager sizeOfCurrentString:@"人数" font:13.0 contentSize:CGSizeMake(ScreenWidth/2.0, 13.0)].width+20, 51.0) title:@"人数" detail:@"10"];
        memberNumberLabel.frame = CGRectMake(CGRectGetMinX(homeCourtLabel.frame)-35.0-memberNumberLabel.frame.size.width, 29.0, memberNumberLabel.frame.size.width, 51.0);
        [headView addSubview:memberNumberLabel];
        
        
        TopLebel * captainLabel = [[TopLebel alloc] initWithFrame:CGRectMake(0.0, 29.0, [NSStringManager sizeOfCurrentString:@"王宝强" font:13.0 contentSize:CGSizeMake(ScreenWidth/2.0, 13.0)].width+20, 51.0) title:@"队长" detail:@"王宝强"];
        captainLabel.center = CGPointMake(CGRectGetMaxX(homeCourtLabel.frame)+35.0+captainLabel.frame.size.width/2.0, 54.0);
        [headView addSubview:captainLabel];
        
        self.tableView.tableHeaderView = headView;
        
        UIView * footerView = [ViewFactory clearViewWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 107.0)];
        
        UIButton * quitTeamButton = [ViewFactory getAButtonWithFrame:CGRectMake(ScreenWidth/2.0-125.0, 27.0, 250.0, 50.0) nomalTitle:@"退出球队" hlTitle:@"退出球队" titleColor:[UIColor whiteColor] bgColor:UIColorFromRGB(0X611b1b) nImage:nil hImage:nil action:@selector(quitTeamButtonAction) target:self buttonTpye:UIButtonTypeCustom];
        quitTeamButton.titleLabel.font = DEFAULT_BOLDFONT(17.0);
        quitTeamButton.layer.cornerRadius = 7.5;
        [footerView addSubview:quitTeamButton];
        self.tableView.tableFooterView = footerView;

    }else{
#pragma mark 没有所属球队时的头视图
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;

        UIView * hasNoTeamHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenWidth)];
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 43.0)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [hasNoTeamHeaderView addSubview:whiteView];
        
        [ViewFactory addAlabelForAView:hasNoTeamHeaderView withText:@"选择加入球队或者创建球队，找到自己的梦想之队" frame:CGRectMake(10.0, 15.0, ScreenWidth-20.0, 13.0) font:SYSTEM_FONT_S(13.0) textColor:UIColorFromRGB(0x282828)];
        hasNoTeamHeaderView.backgroundColor = CLEARCOLOR;
        
        
        
        UIButton * jionTeamButton = [ViewFactory getAButtonWithFrame:CGRectMake(ScreenWidth/2.0-125.0, 56.0, 250.0, 50.0) nomalTitle:@"加入球队" hlTitle:@"加入球队" titleColor:[UIColor whiteColor] bgColor:BALLER_CORLOR_NAVIGATIONBAR nImage:nil hImage:nil action:@selector(jionTeamButtonAction) target:self buttonTpye:UIButtonTypeCustom];
        jionTeamButton.titleLabel.font = DEFAULT_BOLDFONT(17.0);
        jionTeamButton.layer.cornerRadius = 7.5;
        [hasNoTeamHeaderView addSubview:jionTeamButton];
        
        
        UIButton * createTeamButton = [ViewFactory getAButtonWithFrame:CGRectMake(ScreenWidth/2.0-125.0, CGRectGetMaxY(jionTeamButton.frame)+38.0, 250.0, 50.0) nomalTitle:@"创建球队" hlTitle:@"创建球队" titleColor:[UIColor whiteColor] bgColor:BALLER_CORLOR_NAVIGATIONBAR nImage:nil hImage:nil action:@selector(createTeamButtonAction) target:self buttonTpye:UIButtonTypeCustom];
        createTeamButton.titleLabel.font = DEFAULT_BOLDFONT(17.0);
        createTeamButton.layer.cornerRadius = 7.5;
        [hasNoTeamHeaderView addSubview:createTeamButton];
        
        self.tableView.tableHeaderView = hasNoTeamHeaderView;
    }
    

}

#pragma mark 按钮方法
/*!
 *  @brief  前往群聊
 */
- (void)goToGroupChat{
    
}

/*!
 *  @brief  退出球队
 */
- (void)quitTeamButtonAction{
    hasOwnTeam = NO;
    [self setupTableHeaderViewAndFooterView];
    [self.tableView reloadData];
}

/*!
 *  @brief  加入球队
 */
- (void)jionTeamButtonAction{
    
    Baller_ChoseTeamViewController * choseTeamVC = [[Baller_ChoseTeamViewController alloc]init];
    __WEAKOBJ(weakSelf, self)
    choseTeamVC.choseTeamBlock = ^(NSDictionary * chosenTeamDic){
        hasOwnTeam = YES;
        [weakSelf setupTableHeaderViewAndFooterView];
        MAIN_BLOCK(^{
            [weakSelf.tableView reloadData];
        });
    };
    [self.navigationController pushViewController:choseTeamVC animated:YES];
}


/*!
 *  @brief  创建球队
 */
- (void)createTeamButtonAction
{
    
    Baller_CreateBallTeamViewController * createTeamVC = [[Baller_CreateBallTeamViewController alloc]init];
    __WEAKOBJ(weakSelf, self);
    createTeamVC.basketBallTeamCreatedBlock = ^(NSDictionary * resultDic){
        [MLViewConrollerManager popToLastViewController];
        hasOwnTeam = YES;
        [weakSelf setupTableHeaderViewAndFooterView];
        MAIN_BLOCK(^{
            [weakSelf.tableView reloadData];
        });
    };
    [self.navigationController pushViewController:createTeamVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return hasOwnTeam?10:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Baller_MyBasketBallTeamTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Baller_MyBasketBallTeamTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.partnerType = PartnerType_Captain;
    }else if(indexPath.row <5){
        cell.partnerType = PartnerType_Online;
    }else{
        cell.partnerType = PartnerType_Offline;
    }
    
    if (indexPath.row == 0) {
        cell.backgroundType = BaseCellBackgroundTypeUpWhite;
        
    }else if (indexPath.row == 9){
        cell.backgroundType = (indexPath.row%2)?BaseCellBackgroundTypeDownGrey:BaseCellBackgroundTypeDownWhite;
        
    }else{
        cell.backgroundType = indexPath.row%2?BaseCellBackgroundTypeMiddleGrey:BaseCellBackgroundTypeMiddleWhite;
        
    }
    return cell;
    
}

#pragma mark - Table view data delegate


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

@implementation TopLebel

- (id)initWithFrame:(CGRect)frame title:(NSString *)title detail:(NSString *)detail{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0;
        self.clipsToBounds = YES;
    
        CALayer * topLayer = [CALayer layer];
        topLayer.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height/2.0);
        topLayer.backgroundColor = BALLER_CORLOR_NAVIGATIONBAR.CGColor;
        [self.layer addSublayer:topLayer];
        
        CALayer * bottomLayer = [CALayer layer];
        bottomLayer.frame = CGRectMake(0.0, frame.size.height/2.0, frame.size.width, frame.size.height/2.0);
        bottomLayer.backgroundColor = BALLER_CORLOR_CELL.CGColor;
        [self.layer addSublayer:bottomLayer];
        
        [ViewFactory addAlabelForAView:self withText:title frame:CGRectMake(5.0, 7.0, frame.size.width-10.0, 13.0) font:DEFAULT_BOLDFONT(13.0) textColor:[UIColor whiteColor]];
        
        [ViewFactory addAlabelForAView:self withText:detail frame:CGRectMake(5.0, 7.0+frame.size.height/2.0, frame.size.width-10.0, 13.0) font:DEFAULT_BOLDFONT(13.0) textColor:BALLER_CORLOR_696969];

        
        
    }
    return self;
}

@end





