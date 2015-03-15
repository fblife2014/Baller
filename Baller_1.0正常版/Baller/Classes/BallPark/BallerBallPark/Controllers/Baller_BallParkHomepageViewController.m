//
//  Baller_BallParkHomepageViewController.m
//  Baller
//
//  Created by malong on 15/1/23.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BallParkHomepageViewController.h"
#import "Baller_BPAttentionPersonListViewController.h"
#import "Baller_BallParkMapViewController.h"

#import "Baller_EditActivityDetailViewController.h"
#import "Baller_ActivityDetailViewController.h"

#import "Baller_BallParkListModel.h"
#import "Baller_BallParkHeadView.h"
#import "Baller_BallParkActivityListModel.h"

#import "Baller_BallParkActivityListTableViewCell.h"
#import "Baller_HUDView.h"

@interface Baller_BallParkHomepageViewController ()<UITableViewDelegate,Baller_BallParkHeadViewDelegate>
{
   __block NSMutableDictionary * courtInfoDic; // 球场详情信息
    Baller_BallParkHeadView * ballParkHeadView;
    
    NSMutableArray * activities;  //该球场发起的活动
   __block UIButton * attentionButton;
}

@end

static NSString * const Baller_BallParkHomepageTableViewCellId = @"Baller_BallParkHomepageTableViewCellId";

@implementation Baller_BallParkHomepageViewController

#pragma mark 布局视图

- (void)loadView
{
    [super loadView];

    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"Baller_BallParkActivityListTableViewCell" bundle:nil] forCellReuseIdentifier:@"Baller_BallParkActivityListTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加headview图片
    ballParkHeadView = [[Baller_BallParkHeadView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 330)];
    ballParkHeadView.delegate = self;
    ballParkHeadView.ballParkModel = self.ballParkModel;
    self.tableView.tableHeaderView = ballParkHeadView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.ballParkModel.court_name;
    [self getCourtInfo];

    //设置列表
    
}

#pragma mark 网络请求
/*!
 *  @brief  获取球场详情信息
 */
- (void)getCourtInfo{
    if (nil == self.ballParkModel)return;
    __WEAKOBJ(weakSelf, self);
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_court_info parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"court_id":@(self.ballParkModel.court_id)} responseBlock:^(id result, NSError *error) {
        if (error) {
            
        }else {
            courtInfoDic = [NSMutableDictionary dictionaryWithDictionary:result];
            if (0 == [[result valueForKey:@"errorcode"] intValue]){
                [self addAttentionButton];
                if (2 == weakSelf.ballParkModel.status) {
                    [self addAuthedCourtSubViews];
                }else{
                    [self addAuthingCourtSubViews];
                }
            }

        }
    }];
}


#pragma mark 页面加载、布局、更新
/*!
 *  @brief  若已认证，添加关注按钮
 */
- (void)addAttentionButton{
    UIBarButtonItem * rightItem = [ViewFactory getABarButtonItemWithTitle:[[courtInfoDic valueForKey:@"my_attend"] integerValue]?@"已关注":@"  关注" titleEdgeInsets:UIEdgeInsetsZero target:self selection:@selector(attentionButtonAction:)];
    attentionButton = (UIButton *)rightItem.customView;
    self.navigationItem.rightBarButtonItem = rightItem;
}


/*!
 *  @brief  球场如果已经认证通过，添加球场视图
 */
- (void)addAuthedCourtSubViews{
    
    activities = $marrnew;
    for (int i = 0; i < 5; i++) {
        Baller_BallParkActivityListModel * activity = [[Baller_BallParkActivityListModel alloc] init];
        activity.sponsorImageUrl = nil;
        activity.sponsorImageUrl = @"Brad pitt";
        activity.startTime = @"9:00 AM";
        activity.jionNumber = 5;
        activity.hasJoined = (BOOL)(i%2);
        [activities addObject:activity];
    }
    
    self.tableViewDataSource = [[TableViewDataSource alloc]initWithItems:activities cellIdentifier:@"Baller_BallParkActivityListTableViewCell" tableViewConfigureBlock:^(Baller_BallParkActivityListTableViewCell * cell, Baller_BallParkActivityListModel * item) {
        cell.activitiyModel = item;
    }];
    self.tableView.dataSource = self.tableViewDataSource;

}


/*!
 *  @brief  当球场未认证通过时，添加认证图
 */
- (void)addAuthingCourtSubViews{
    AuthenticationView * authenticationView = [[AuthenticationView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenWidth)];
    authenticationView.court_id = $str(@"%ld",self.ballParkModel.court_id);
    authenticationView.hasIdentified = [[courtInfoDic valueForKey:@"my_auth"] boolValue];
    authenticationView.auth_num = [[courtInfoDic valueForKey:@"auth_num"] integerValue];
    self.tableView.tableFooterView = authenticationView;
}

#pragma mark  按钮点击方法等
/*!
 *  @brief  关注按钮方法
*/
- (void)attentionButtonAction:(UIBarButtonItem *)item{
    
    [AFNHttpRequestOPManager getWithSubUrl:Baller_attend_court parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"court_id":@(self.ballParkModel.court_id)} responseBlock:^(id result, NSError *error) {
        if (0 == [[result valueForKey:@"errorcode"] intValue]) {
            BOOL attentioned = [[courtInfoDic valueForKey:@"my_attend"] boolValue];
            [courtInfoDic setValue:attentioned?@"0":@"1" forKey:@"my_attend"];
            
            [attentionButton setTitle:attentioned?@"  关注":@"已关注" forState:UIControlStateNormal];
            
            [Baller_HUDView bhud_showWithTitle:attentioned?@"已取消关注!":@"关注成功！"];
        }
    }];
}
#pragma mark 数据处理


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 111.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Baller_ActivityDetailViewController * activityDetailVC = [[Baller_ActivityDetailViewController alloc]init];
    activityDetailVC.haveJoined  = (BOOL)(indexPath.row%2);
    [self.navigationController pushViewController:activityDetailVC animated:YES];
}

#pragma mark Baller_BallParkHeadViewDelegate

- (void)ballParkHeadView:(Baller_BallParkHeadView *)ballParkHeadView mapButtonSelected:(UIButton *)mapButton{
    Baller_BallParkMapViewController * ballParkMapVC = [[Baller_BallParkMapViewController alloc]init];
    ballParkMapVC.ballParkModel = self.ballParkModel;
    [self.navigationController pushViewController:ballParkMapVC animated:YES];

}

- (void)ballParkHeadView:(Baller_BallParkHeadView *)ballParkHeadView userButtonSelected:(UIButton *)userButton{
    Baller_BPAttentionPersonListViewController * bpAttentionListVC = [[Baller_BPAttentionPersonListViewController alloc]init];
    bpAttentionListVC.ballParkModel = self.ballParkModel;
    [self.navigationController pushViewController:bpAttentionListVC animated:YES];
}

- (void)ballParkHeadView:(Baller_BallParkHeadView *)ballParkHeadView activitieButtonSelected:(UIButton *)activitieButton{
    Baller_EditActivityDetailViewController * editADVC = [[Baller_EditActivityDetailViewController alloc]init];
    [self.navigationController pushViewController:editADVC animated:YES];
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



@implementation AuthenticationView

- (id)initWithFrame:(CGRect)frame{
    frame = CGRectMake(0.0, 0.0, ScreenWidth, ScreenWidth);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xe7e7e7);
        self.hasIdentified = NO;
    }
    return self;
}

- (UILabel *)identifyLabel
{
    if (!_identifyLabel) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 2*ScreenWidth/9.0, ScreenWidth/3.0, ScreenWidth/9.0)];
        label.backgroundColor = UIColorFromRGB(0xebeef3);
        label.textColor = UIColorFromRGB(0x6b6c6e);
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textAlignment = NSTextAlignmentCenter;
       [self.authenButton addSubview: _identifyLabel = label];
    }
    return _identifyLabel;
}

/*!
 *  @brief  认证按钮
*/
- (UIButton *)authenButton
{
    if (!_authenButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ScreenWidth/3.0, ScreenWidth/6.0, ScreenWidth/3.0, ScreenWidth/3.0);
        button.layer.cornerRadius = ScreenWidth/20.0;
        button.layer.borderColor = BALLER_CORLOR_696969.CGColor;
        button.layer.borderWidth = 0.5;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(-ScreenWidth/12.0, 0.0, 0.0, 0.0);
        [button setTitle:[NSString stringWithFormat:@"%ld",15-_auth_num] forState:UIControlStateNormal];
        button.clipsToBounds = YES;
        button.titleLabel.font = DEFAULT_BOLDFONT(button.frame.size.width/2.0);
        [button addTarget:self action:@selector(authenButtonAction) forControlEvents:UIControlEventTouchUpInside];
       [self addSubview: _authenButton = button];
    }
    return _authenButton;
}

/*!
 *  @brief  认证状态详情表情
*/
- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.authenButton.frame)+ScreenWidth/10.0, ScreenWidth-40.0, 20.0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = BALLER_CORLOR_696969;
        label.font = [UIFont systemFontOfSize:15.0f];
       [self addSubview: _detailLabel = label];
    }
    return _detailLabel;
}


- (void)setHasIdentified:(BOOL)hasIdentified{
    _hasIdentified = hasIdentified;
    [self.authenButton setBackgroundColor:hasIdentified?UIColorFromRGB(0x959595):CYAN_COLOR];
    self.identifyLabel.text = hasIdentified?@"已认证":@"点击认证";

}

- (void)setAuth_num:(NSInteger)auth_num{
    if (_auth_num == auth_num) {
        return;
    }
    _auth_num = auth_num;
    self.detailLabel.attributedText = [NSStringManager getAcolorfulStringWithText1:[NSString stringWithFormat:@"%ld",auth_num] Color1:nil Font1:SYSTEM_FONT_S(19) Text2:nil Color2:nil Font2:nil AllText:[NSString stringWithFormat:@"距离正式运营只差%ld个认证",15-auth_num]];
    [self.authenButton setTitle:[NSString stringWithFormat:@"%ld",auth_num] forState:UIControlStateNormal];
}

#pragma mark 方法
- (void)authenButtonAction{
    [AFNHttpRequestOPManager getWithSubUrl:Baller_auth_court parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"court_id":_court_id} responseBlock:^(id result, NSError *error) {
        if (0 == [[result valueForKey:@"errorcode"] intValue]) {
            self.hasIdentified = YES;
            self.auth_num++;
        }
    }];
}


@end
