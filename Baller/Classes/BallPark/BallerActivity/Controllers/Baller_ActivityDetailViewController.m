//
//  Baller_ActivityDetailViewController.m
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_ActivityDetailViewController.h"
#import "Baller_BallParkHomepageViewController.h"
#import "Baller_BallParkActivityListModel.h"
#import "Baller_InfoItemView.h"

@interface Baller_ActivityDetailViewController ()
{
    UIView * bottomView;
    UIButton * bottomButton;
    BOOL isCreator; //当前用户是否为活动创建者
    __block BOOL isDataChanged; //数据是否已有变化
    
    NSMutableDictionary * activityInfo; //活动信息
    UIButton * collectButton; //收藏按钮
}
@end

@implementation Baller_ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动详情";
    [self getActivityInfo];
    isCreator = [_activityModel.uid isEqualToString:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"]];
    [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"]];
    [self setupSubViews];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_ballParkVC && isDataChanged == YES) {
        [_ballParkVC ballerParkHome_get_activities];
    }
}



/*!
 *  @brief  设置子视图
 */
- (void)setupSubViews{
    
    float space = NUMBER(22.0, 20.0, 15.0, 15.0);
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(space, 1.5*space, ScreenWidth-2*space, 5*PersonInfoCell_Height)];
    bottomView.backgroundColor = BALLER_CORLOR_CELL;
    bottomView.layer.cornerRadius = NUMBER(30.0, 25.0, 20.0, 20.0);
    bottomView.clipsToBounds = YES;
    [self.view addSubview:bottomView];
    
    NSArray * colors = @[BALLER_CORLOR_CELL,[UIColor whiteColor],BALLER_CORLOR_CELL,[UIColor whiteColor],BALLER_CORLOR_NAVIGATIONBAR];
    
    NSArray * titles = @[@"主题",@"备注",@"时间",@"已参加用户",[self activityBottomButtonTitle:_activityModel.is_join]];
    
    NSArray * details = @[_activityModel.activity_title,_activityModel.activity_info.length?_activityModel.activity_info:@"无",[TimeManager getDateStringOfTimeInterval:_activityModel.start_time],$str(@"%ld/%ld",_activityModel.join_num,_activityModel.max_num)];
    
    for (int i = 0; i < colors.count; i++) {
        
        if (i<4) {
            Baller_InfoItemView * itemView = [[Baller_InfoItemView alloc]initWithFrame:CGRectMake(0.0, i*PersonInfoCell_Height, ScreenWidth-2*space, PersonInfoCell_Height) title:titles[i] placeHolder:nil];
            itemView.infoTextField.text = details[i];
            itemView.backgroundColor = colors[i];
            itemView.infoTextField.font = SYSTEM_FONT_S(15.0);
            itemView.titleLabel.font = SYSTEM_FONT_S(15.0);
            [bottomView addSubview:itemView];
            
        }else{
            
            bottomButton = [ViewFactory getAButtonWithFrame:CGRectMake(0.0, 4*PersonInfoCell_Height, ScreenWidth-2*space, PersonInfoCell_Height) nomalTitle:titles[4] hlTitle:titles[4] titleColor:[UIColor whiteColor] bgColor:(_activityModel.is_join || _activityModel.status == 2)?BALLER_CORLOR_RED:BALLER_CORLOR_NAVIGATIONBAR nImage:nil hImage:nil action:@selector(bottomButtonAction) target:self buttonTpye:UIButtonTypeCustom];
            [bottomView addSubview:bottomButton];
            if (_activityModel.status == 2) {
                bottomButton.enabled = NO;
            }
        }
    }
    
}

//设置底部按钮状态
- (void)setBottomButtonStatus:(BOOL)isJoind
{
    NSString * buttonTitle = [self activityBottomButtonTitle:_activityModel.is_join];
    [bottomButton setTitle:buttonTitle forState:UIControlStateNormal];
    [bottomButton setTitle:buttonTitle forState:UIControlStateHighlighted];
    
    if (isJoind) {
        if (_activityModel.status == 1) {
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        }
        bottomButton.backgroundColor = BALLER_CORLOR_RED;

    }else{
        if (_activityModel.status == 1) {
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        }
        bottomButton.backgroundColor = BALLER_CORLOR_NAVIGATIONBAR;
    }
}

/*!
 *  @brief  根据返回的活动详情信息，重置视图
 */
- (void)resetSubviewsWithActivityInfo
{
    if (!collectButton) {
        collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [collectButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
        collectButton.frame = CGRectMake(0.0, 0.0, 60.0, NavigationBarHeight);
        [collectButton addTarget:self action:@selector(collectButtonAction) forControlEvents:UIControlEventTouchUpInside];
        collectButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        collectButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -15.0);
        
        UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithCustomView:collectButton];
        self.navigationItem.rightBarButtonItem = barItem;
    }

    [collectButton setTitle:[[activityInfo valueForKey:@"my_favo"] boolValue]?@"已收藏":@"收藏" forState:UIControlStateNormal];
}

#pragma mark 网络请求
/*!
 *  @brief  获取活动详情
 */
- (void)getActivityInfo
{
    [AFNHttpRequestOPManager getWithSubUrl:Baller_activity_get_info parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"activity_id":_activityModel.activity_id} responseBlock:^(id result, NSError *error) {
        if (error)return;
        
        if (0 == [[result valueForKey:@"errorcode"] integerValue]) {
            activityInfo = [NSMutableDictionary dictionaryWithDictionary:result];
            [self resetSubviewsWithActivityInfo];
        }
        
    }];
}

/*!
 *  @brief  加入、退出或解散球队
 */
- (void)joinOrOutActivity
{
    __WEAKOBJ(weakSelf, self);
    [AFNHttpRequestOPManager getWithSubUrl:_activityModel.is_join?Baller_activity_out:Baller_activities_join parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"activity_id":[_activityModel.activity_id copy]} responseBlock:^(id result, NSError *error) {
        
        if (error) return ;
        
        __STRONGOBJ(strongSelf, weakSelf);
        
        if (0 == [[result valueForKey:@"errorcode"] integerValue]) {
            isDataChanged = YES;
            if (isCreator) {
                [strongSelf PopToLastViewController];
            }else{
                strongSelf.activityModel.is_join = !strongSelf.activityModel.is_join;
                strongSelf.activityModel.status = 2;
                [strongSelf setBottomButtonStatus:_activityModel.is_join];
            }
        }
    }];
}

/*!
 *  @brief  收藏或取消收藏
 */
- (void)favoOrCancelFavo
{
    BOOL is_my_favo = [[activityInfo valueForKey:@"my_favo"] boolValue];
    __BLOCKOBJ(blockSelf, self);
    [AFNHttpRequestOPManager getWithSubUrl:is_my_favo?Baller_activity_cancel_favo:Baller_activity_favo parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"activity_id":_activityModel.activity_id} responseBlock:^(id result, NSError *error){
        if(error) return;
        if ([[result valueForKey:@"errorcode"] integerValue] == 0) {
            [blockSelf -> activityInfo setValue:$str(@"%d",!is_my_favo) forKey:@"my_favo"];
            [self resetSubviewsWithActivityInfo];
        }
    }];
}

#pragma mark 数据处理

//底部按钮标题
- (NSString *)activityBottomButtonTitle:(BOOL)isJoind{
    if (isCreator) {
        if (_activityModel.status == 1) {
            return @"解散活动";
        }else if (_activityModel.status == 2){
            return @"活动已解散";
        }
        return @"";
    }else{
        return _activityModel.is_join?@"退出活动":@"加入活动";
    }
}


#pragma mark 点击方法

- (void)collectButtonAction
{
    [self favoOrCancelFavo];
}

- (void)bottomButtonAction{
    [self joinOrOutActivity];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
