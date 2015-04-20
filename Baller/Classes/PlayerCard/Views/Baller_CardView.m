//
//  Baller_PlayerCardView.m
//  Baller
//
//  Created by malong on 15/1/17.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#define PCV_SegmentHeightRatio 0.138
#define PCV_BottomSegHeightRatio (258.0/1113.0)

#define ShareButtonWidth 63.0

#import "Baller_CardView.h"
#import "UIButton+AFNetworking.h"

#import "Baller_MyBallParkViewController.h"
#import "Baller_MyBasketballTeamViewController.h"
#import "Baller_ChoseTeamViewController.h"
#import "Baller_BallParkHomepageViewController.h"

#import "Baller_PlayerCardViewController.h"

#import "Baller_AbilityView.h"
#import "Baller_AbilityEditorView.h"

#import "LShareSheetView.h"
#import "Baller_MyAttentionBallPark.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "Baller_AbilityInfoEditor.h"


#import "RCIM.h"
@interface Baller_CardView ()<RCIMUserInfoFetcherDelegagte>


@end
@implementation Baller_CardView

@synthesize ballParkButton = _ballParkButton;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = YES;
        self.showsVerticalScrollIndicator = NO;
        self.clipsToBounds = NO;
        self.scrollEnabled = YES;
        [self headImageButton];
        
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
     playerCardType:(BallerCardType)ballerCardType{
    self = [self initWithFrame:frame];
    if (self) {
        if (ballerCardType <= kBallerCardType_MyPlayerCard ) {
            self.contentSize =CGSizeMake(frame.size.width, NUMBER(750.0, 680.0, 610, 610));
            [self pcv_SetupBackLayerWith:CGRectMake(0.0, 0.0, frame.size.width,  NUMBER(610, 580, 540,540))];
        }else if(ballerCardType == kBallerCardType_CreateBallPark){
            self.contentSize =CGSizeMake(frame.size.width, NUMBER(750.0, 680.0, 610, 610));
            [self pcv_SetupBackLayerWith:CGRectMake(0.0, 0.0, frame.size.width,  NUMBER(615, 565, 545,545))];
        }else if (ballerCardType == kBallerCardType_CreateBasketBallTeam){
            self.contentSize =CGSizeMake(frame.size.width, NUMBER(750.0, 680.0, 620, 620));
            [self pcv_SetupBackLayerWith:CGRectMake(0.0, 0.0, frame.size.width,  NUMBER(550, 525, 500,500))];
        }

        
        self.ballerCardType = ballerCardType;
        
        _nickNameLabel = [ViewFactory addAlabelForAView:self withText:[USER_DEFAULT valueForKey:Baller_UserInfo_Username] frame:CGRectMake(10.0, CGRectGetMaxY(_headImageButton.bounds)+TextFontSize/2.0, pathRect.size.width-20.0, 3*TextFontSize)font:SYSTEM_FONT_S(TextFontSize) textColor:[UIColor whiteColor]];
        
        whiteBottomlayer = [CALayer layer];
        [self.layer addSublayer:whiteBottomlayer];
        
        switch (ballerCardType) {
            case kBallerCardType_FirstBorn:
            case kBallerCardType_MyPlayerCard:

                [self addShareButton];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseQiuChang:) name:@"ChooseZhuChang" object:nil];

                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseQiuDui:) name:@"ChooseTeamNotifacation" object:nil];

                
                whiteBottomlayer.frame = CGRectMake(0.0, CGRectGetMaxY(_nickNameLabel.frame), pathRect.size.width, CGRectGetMaxY(backLayer.frame)-pathRect.size.width*PCV_BottomSegHeightRatio-CGRectGetMaxY(_nickNameLabel.frame));

                whiteBottomlayer.backgroundColor = BALLER_CORLOR_CELL.CGColor;
                [self addSubview: self.ballParkButton];
                [self addSubview: self.ballTeamButton];
                [self addLineAndAbility];
                [self addBottomSegments];
                
                break;
            case kBallerCardType_OtherBallerPlayerCard:
                [self addPrivateChatButton];
                whiteBottomlayer.frame = CGRectMake(0.0, CGRectGetMaxY(_nickNameLabel.frame), pathRect.size.width, CGRectGetMaxY(backLayer.frame)-pathRect.size.width*PCV_BottomSegHeightRatio-CGRectGetMaxY(_nickNameLabel.frame));
                
                whiteBottomlayer.backgroundColor = BALLER_CORLOR_CELL.CGColor;
                [self addSubview: self.ballParkButton];
                [self addSubview: self.ballTeamButton];
                [self addLineAndAbility];
                [self addBottomSegments];
                
                break;
            case kBallerCardType_CreateBallPark:
            {
                self.createBallParkView = [[Baller_CreateBallParkView alloc]initWithFrame:CGRectMake(0.0, CGRectGetMaxY(_nickNameLabel.frame), self.frame.size.width, 4.5*PersonInfoCell_Height)];
                _nickNameLabel.text = [NSString stringWithFormat:@"由 %@ 创建",[USER_DEFAULT valueForKey:Baller_UserInfo_Username]];

                [self.bottomButton setTitle:@"创建球场" forState:UIControlStateNormal];
                [self addSubview:_createBallParkView];
            }
                break;
            case kBallerCardType_CreateBasketBallTeam:
            {
                _nickNameLabel.text = [NSString stringWithFormat:@"由 %@ 创建",[USER_DEFAULT valueForKey:Baller_UserInfo_Username]];

                self.createTeamView = [[[NSBundle mainBundle]loadNibNamed:@"Baller_CreateBasketBallTeamView" owner:self options:nil] lastObject];
                _createTeamView.frame = CGRectMake(0.0, CGRectGetMaxY(_nickNameLabel.frame), self.frame.size.width, 285);
                [self.bottomButton setTitle:@"创建球队" forState:UIControlStateNormal];
                [self addSubview:_createTeamView];


            }
                break;
  
        }
        
    }
    return self;
}

#pragma mark 请求个人信息

- (void)setUid:(NSString *)uid{
    if ([_uid isEqualToString:uid]) {
        return;
    }
    _uid = [uid copy];
    abilityView.evaluatedPersonUid = _uid;
    [self getPersonalInfoWithUid];
}

- (void)getPersonalInfoWithUid
{
    if (_uid == nil) {
        return;
    }
    
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_user_info parameters:@{@"uid":_uid,@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode]} responseBlock:^(id result, NSError *error) {
        if (error) return ;
        if ([result longForKey:@"errorcode"] == 0) {
            [self setPersonalInfo:[result valueForKey:@"user_info"]];
        }
    }];
    
}

- (void)setPersonalInfo:(NSDictionary *)personalInfo{
    if (_personalInfo == personalInfo) {
        return;
    }
    if(!_personalInfo) _personalInfo = [NSMutableDictionary dictionary];
    [_personalInfo setValuesForKeysWithDictionary:personalInfo];
    [_headImageButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[personalInfo valueForKey:@"photo"]] placeholderImage:[UIImage imageNamed:[personalInfo intForKey:@"gender"] == 1?@"manHead":@"womenHead"]];
    
    if ([[personalInfo valueForKey:@"appraise"] boolForKey:@"can_appraise"]) {
        if ([[personalInfo valueForKey:@"appraise"] boolForKey:@"friend_appraise"] && [personalInfo intForKey:@"attend_status"] == 3) {
            abilityView.evaluateType = @"friend";
            [self addEvaluateButton];
        }else if ([[personalInfo valueForKey:@"appraise"] boolForKey:@"activity_appraise"]){
            abilityView.evaluateType = @"activity";
            if (self.activity_id) {
                abilityView.activity_id = self.activity_id;
                [self addEvaluateButton];
            }
        }
    }
    _nickNameLabel.text = [personalInfo valueForKey:@"user_name"];
    
    switch ([personalInfo intForKey:@"attend_status"]) {
        case 0:
            [self addAttentionButtonWithTitle:@"关注" imageName:@"guangzhu"];
            break;
        case 2:
            [self addAttentionButtonWithTitle:@"关注" imageName:@"guangzhu"];
            break;
        case 1:
            [self addAttentionButtonWithTitle:@"已关注" imageName:nil];
            break;
        case 3:
            [self addAttentionButtonWithTitle:@"我的球友" imageName:nil];
            break;
            
        default:
            break;
    }
    
    if ([personalInfo intForKey:@"court_id"]) {
        self.court_name = [personalInfo valueForKey:@"court_name"];
        self.court_id = [personalInfo stringForKey:@"court_id"];
    }
    
    if ([personalInfo intForKey:@"team_id"]) {
        self.team_name = [personalInfo valueForKey:@"team_name"];
        self.team_id = [personalInfo stringForKey:@"team_id"];
    }
    NSMutableDictionary * abilityDetail = [NSMutableDictionary dictionary];
    
    NSInteger shoot = [[personalInfo valueForKey:@"shoot"] integerValue];
    NSInteger assists = [[personalInfo valueForKey:@"assists"] integerValue];
    NSInteger backboard = [[personalInfo valueForKey:@"backboard"] integerValue];
    NSInteger steal = [[personalInfo valueForKey:@"steal"] integerValue];
    NSInteger over = [[personalInfo valueForKey:@"over"] integerValue];
    NSInteger breakthrough = [[personalInfo valueForKey:@"breakthrough"] integerValue];
    
    NSInteger totalNumber = shoot + assists + backboard + steal + over + breakthrough;
    
    [abilityDetail setValue:[personalInfo valueForKey:@"shoot"] forKey:@"shoot"];
    [abilityDetail setValue:[personalInfo valueForKey:@"assists"] forKey:@"assists"];
    [abilityDetail setValue:[personalInfo valueForKey:@"backboard"] forKey:@"backboard"];
    [abilityDetail setValue:[personalInfo valueForKey:@"steal"] forKey:@"steal"];
    [abilityDetail setValue:[personalInfo valueForKey:@"over"] forKey:@"over"];
    [abilityDetail setValue:[personalInfo valueForKey:@"breakthrough"] forKey:@"breakthrough"];
    [abilityDetail setValue:@(totalNumber) forKey:@"totalNumber"];
    [self addLevelLabelWithLevelText:[Baller_AbilityInfoEditor levelStringWithAbility:abilityDetail]];

    self.abilityDetailInfo = abilityDetail;
    
    heightLabel.text = $str(@"%@ cm",[personalInfo valueForKey:@"height"]);
    weightLabel.text = $str(@"%@ kg",[personalInfo valueForKey:@"weight"]);
    positonLabel.text = $str(@"%@",[personalInfo valueForKey:@"position"]);
    
    [self setNeedsDisplay];

}

- (void)setActivity_id:(NSString *)activity_id{
    if ([_activity_id isEqualToString:activity_id]) {
        return;
    }
    _activity_id = activity_id;
    abilityView.activity_id = _activity_id;
}

- (void)setAbilityDetailInfo:(NSMutableDictionary *)abilityDetailInfo{
    if (_abilityDetailInfo == abilityDetailInfo) {
        return;
    }
    _abilityDetailInfo = abilityDetailInfo;
    [abilityEditorView removeFromSuperview];
    abilityEditorView = [[Baller_AbilityEditorView alloc]initWithFrame:CGRectMake(0.0, 0.0, 154.0, 158.0)];
    abilityEditorView.center = CGPointMake(abilityView.frame.size.width/2.0, abilityView.frame.size.height/2.0-5.0);
    abilityEditorView.abilities = abilityDetailInfo;
    [abilityView addSubview:abilityEditorView];
    
    
}

#pragma mark 设置球场名或球队名

- (void)setCourt_name:(NSString *)court_name{
    if ([_court_name isEqualToString:court_name]) {
        return;
    }
    _court_name = court_name;
    NSString * title = _court_name;
    if (_court_name.length>6) {
        title = [_court_name substringToIndex:6];
        title = $str(@"%@...",title);
    }
    [ballParkButton setTitle:title forState:UIControlStateNormal];
}

- (void)setTeam_name:(NSString *)team_name{
    if ([_team_name isEqualToString:team_name]) {
        return;
    }
    _team_name = team_name;
    [_ballTeamButton setTitle:team_name forState:UIControlStateNormal];
    [_ballTeamButton setTitle:team_name forState:UIControlStateNormal];
    
}

#pragma mark 球场名或球队名变化通知

-(void)chooseQiuChang:(NSNotification *) sender
{
    if (nil == sender.object) {
        return;
    }
    Baller_MyAttentionBallPark *currentBallPark = sender.object;
    self.court_name = currentBallPark.court_name;
    self.court_id = $str(@"%ld",(long)currentBallPark.court_id);
    
}

- (void)chooseQiuDui:(NSNotification *) sender
{
    if (nil == sender.userInfo) {
        return;
    }
    
    
}


#pragma mark  添加子视图
- (UIButton *)headImageButton
{
    if (!_headImageButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, HeadLayer_BorderWidth, 2*HeadLayer_CircleRadius-2*HeadLayer_BorderWidth, 2*HeadLayer_CircleRadius-2*HeadLayer_BorderWidth);
        button.center = CGPointMake(CGRectGetMidX(self.bounds), HeadLayer_CircleRadius);
        [button addTarget:self action:@selector(pcv_headImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = HeadLayer_CircleRadius-HeadLayer_BorderWidth;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = CYAN_COLOR.CGColor;
        button.layer.borderWidth = 4.0;
       [self addSubview: _headImageButton = button];
    }
    return _headImageButton;
}

/*!
 *  @brief  背景
*/
- (void)pcv_SetupBackLayerWith:(CGRect)frame{
    
    pathRect = CGRectMake(0.0,HeadLayer_CircleRadius,frame.size.width,
                                 frame.size.height-HeadLayer_CircleRadius);
    
    
    CGPoint leftTop = CGPointMake(0.0,HeadLayer_CircleRadius+BackLayer_CornerRadius);
    CGPoint topLeft = CGPointMake(BackLayer_CornerRadius,HeadLayer_CircleRadius);
    CGPoint topRight = CGPointMake(frame.size.width-BackLayer_CornerRadius, HeadLayer_CircleRadius);
    CGPoint rightTop = CGPointMake(frame.size.width, HeadLayer_CircleRadius+BackLayer_CornerRadius);
    CGPoint rightBottom = CGPointMake(frame.size.width, frame.size.height-BackLayer_CornerRadius);
    CGPoint bottomRight = CGPointMake(frame.size.width-BackLayer_CornerRadius, frame.size.height);
    CGPoint bottomLeft = CGPointMake(BackLayer_CornerRadius,frame.size.height);
    CGPoint leftBottom = CGPointMake(0, frame.size.height-BackLayer_CornerRadius);
    CGPoint topCenter = CGPointMake(frame.size.width/2.0,HeadLayer_CircleRadius);
    
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:leftTop];
    [path addQuadCurveToPoint:topLeft controlPoint:CGPointMake(0.0, HeadLayer_CircleRadius)];
    [path addArcWithCenter:topCenter radius:HeadLayer_CircleRadius startAngle:M_PI endAngle:0 clockwise:NO];
    [path addLineToPoint:topRight];
    [path addQuadCurveToPoint:rightTop controlPoint:CGPointMake(frame.size.width, HeadLayer_CircleRadius)];
    [path addLineToPoint:rightBottom];
    [path addQuadCurveToPoint:bottomRight controlPoint:CGPointMake(frame.size.width, frame.size.height)];
    [path addLineToPoint:bottomLeft];
    [path addQuadCurveToPoint:leftBottom controlPoint:CGPointMake(0, frame.size.height)];
    [path addLineToPoint:leftTop];
    
    backLayer = [CAShapeLayer layer];
    backLayer.bounds = pathRect;
    backLayer.frame = CGRectMake(0.0, HeadLayer_CircleRadius, frame.size.width, frame.size.height-HeadLayer_CircleRadius);
    backLayer.path = path.CGPath;
    backLayer.fillColor = CYAN_COLOR.CGColor;
    backLayer.shadowColor = CYAN_COLOR.CGColor;
    backLayer.shadowOpacity = 0.5;
    backLayer.shadowOffset = CGSizeMake(0.5, 0.0);
    
    [self.layer addSublayer:backLayer];
    [self layoutIfNeeded];
    
    
}

- (UIButton *)bottomButton
{
    if (!_bottomButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, CGRectGetMaxY(pathRect)-PersonInfoCell_Height, self.frame.size.width, PersonInfoCell_Height);
        [button setTitle:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = DEFAULT_BOLDFONT(17.0);
        [button addTarget:self action:@selector(bottomButtonClicked) forControlEvents:UIControlEventTouchUpInside];
       [self addSubview: _bottomButton = button];
    }
    return _bottomButton;
}


#pragma mark 我的球员卡状态视图
/*!
 *  @brief  分享按钮
 */
- (void)addShareButton{
    
    UIButton * shareButton = [ViewFactory getAButtonWithFrame:CGRectMake(pathRect.size.width-BackLayer_CornerRadius-ShareButtonWidth, pathRect.origin.y, ShareButtonWidth, ShareButtonWidth) nomalTitle:@"分享" hlTitle:@"分享" titleColor:[UIColor whiteColor] bgColor:CLEARCOLOR nImage:@"playerCard_share" hImage:@"playerCard_share" action:@selector(shareButtonAction) target:self buttonTpye:UIButtonTypeCustom];
    shareButton.titleLabel.font = SYSTEM_FONT_S(13.0);
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 10, 0.0, 10.0);
    shareButton.titleEdgeInsets = UIEdgeInsetsMake(1.0, 10, -1.0, -8.0);
    [self addSubview:shareButton];
    
}


#pragma mark 其他球员卡状态视图

/*!
 *  @brief  添加私聊按钮
 */
- (void)addPrivateChatButton
{
    UIButton * chatButton = [ViewFactory getAButtonWithFrame:CGRectMake(pathRect.size.width-BackLayer_CornerRadius-ShareButtonWidth, pathRect.origin.y, 87.0, 28) nomalTitle:@"私信" hlTitle:@"私信" titleColor:[UIColor whiteColor] bgColor:UIColorFromRGB(0x51d3b7) nImage:@"sixin" hImage:@"sixin" action:@selector(chatButtonAction) target:self buttonTpye:UIButtonTypeCustom];
    
    chatButton.center = CGPointMake(self.headImageButton.center.x-CGRectGetWidth(self.headImageButton.bounds)*3/4.0, self.headImageButton.center.y-20.0);
    
    chatButton.titleLabel.font = SYSTEM_FONT_S(13.0);
    chatButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -25, 0.0, 0.0);
    chatButton.titleEdgeInsets = UIEdgeInsetsMake(1.0, -15, -1.0, 0.0);
    chatButton.layer.cornerRadius = 5.0;
    
    [self insertSubview:chatButton belowSubview:self.headImageButton];
}

/*!
 *  @brief  添加评价按钮
 */
- (void)addEvaluateButton
{
    UIButton * evaluateButton = [ViewFactory getAButtonWithFrame:CGRectMake(pathRect.size.width-BackLayer_CornerRadius-ShareButtonWidth, pathRect.origin.y, 87.0, 28) nomalTitle:@"评价ta" hlTitle:@"评价ta" titleColor:[UIColor whiteColor] bgColor:UIColorFromRGB(0xf07d8a) nImage:@"pingjia" hImage:@"pingjia" action:@selector(evaluateButtonAction) target:self buttonTpye:UIButtonTypeCustom];
    evaluateButton.center = CGPointMake(self.headImageButton.center.x+CGRectGetWidth(self.headImageButton.bounds)*3/4.0, self.headImageButton.center.y-20.0);
    evaluateButton.titleLabel.font = SYSTEM_FONT_S(13.0);
    evaluateButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 15, 0.0, 0.0);
    evaluateButton.titleEdgeInsets = UIEdgeInsetsMake(1.0, 15, -1.0, 0.0);
    evaluateButton.layer.cornerRadius = 5.0;
    abilityView.evaluateButton = evaluateButton;
    [self insertSubview:evaluateButton belowSubview:self.headImageButton];

}

/*!
 *  @brief  关注按钮
 */
- (void)addAttentionButtonWithTitle:(NSString *)buttonTitle imageName:(NSString *)imageName
{
    if (!attentionButton) {
        attentionButton = [ViewFactory getAButtonWithFrame:CGRectMake(pathRect.size.width-BackLayer_CornerRadius-ShareButtonWidth, pathRect.origin.y, ShareButtonWidth, ShareButtonWidth) nomalTitle:nil hlTitle:nil titleColor:[UIColor whiteColor] bgColor:CLEARCOLOR nImage:@"guanzhu" hImage:@"guanzhu" action:@selector(attentionButtonAction) target:self buttonTpye:UIButtonTypeCustom];
        [self addSubview:attentionButton];

    }
    [attentionButton setTitle:buttonTitle forState:UIControlStateNormal];
    attentionButton.titleLabel.font = SYSTEM_FONT_S(13.0);
    if (imageName) {
        [attentionButton setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];

        attentionButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 10, 0.0, 10.0);
        attentionButton.titleEdgeInsets = UIEdgeInsetsMake(1.0, 10, -1.0, -8.0);
    }else{
        [attentionButton setImage:nil forState:UIControlStateNormal];
        attentionButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0, 0.0, 0.0);

    }
    
}

/*!
 *  @brief  添加级别标签
 */
- (void)addLevelLabelWithLevelText:(NSString *)levelText
{
    if (!levelLabel) {
        levelLabel = [ViewFactory addAlabelForAView:self withText:nil frame:CGRectMake(35, pathRect.origin.y, ShareButtonWidth, ShareButtonWidth) font:[UIFont systemFontOfSize:14.0] textColor:[UIColor whiteColor]];
        levelLabel.textAlignment = NSTextAlignmentLeft;
    }
    NSString * totalString = [NSString stringWithFormat:@"等级：%@",levelText];
    levelLabel.attributedText = [NSStringManager getAcolorfulStringWithText1:@"等级：" Color1:[UIColor whiteColor] Font1:[UIFont systemFontOfSize:11] Text2:levelText Color2:[UIColor whiteColor] Font2:[UIFont systemFontOfSize:15] AllText:totalString];
    
}

- (UIButton *)ballParkButton
{
    if (!_ballParkButton) {
        
        ballParkButton = [ViewFactory getAButtonWithFrame:CGRectMake(0.0, CGRectGetMaxY(_nickNameLabel.frame), pathRect.size.width/2.0, pathRect.size.width*PCV_SegmentHeightRatio) nomalTitle:nil hlTitle:nil titleColor:BALLER_CORLOR_696969 bgColor:nil nImage:@"homeCourt" hImage:@"homeCourt" action:@selector(ballParkButtonAction) target:self buttonTpye:UIButtonTypeCustom];
        ballParkButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -10, 0.0, 10.0);
        ballParkButton.titleEdgeInsets = UIEdgeInsetsMake(1.0, 0.0, -1.0, 0.0);
        ballParkButton.titleLabel.font = SYSTEM_FONT_S(15.0);
        _ballParkButton = ballParkButton;
        
        if (_ballerCardType == kBallerCardType_MyPlayerCard || _ballerCardType==kBallerCardType_FirstBorn)
        {
            NSString * court_nameString = [[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"court_name"];
            
            NSString * courtname = court_nameString.length?court_nameString:@"未加入球场";
            self.court_name = courtname;
            
            NSString * courtId = [[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"court_id"];
            self.court_id = [courtId integerValue]?courtId:nil;
            
        }
    }
    return _ballParkButton;
}


/*!
 *  @brief 我的球队
*/
- (UIButton *)ballTeamButton
{
    if (!_ballTeamButton) {
        
        UIButton * ballTeamButton = [ViewFactory getAButtonWithFrame:CGRectMake(pathRect.size.width/2.0, CGRectGetMaxY(_nickNameLabel.frame), pathRect.size.width/2.0, pathRect.size.width*PCV_SegmentHeightRatio) nomalTitle:nil hlTitle:nil titleColor:BALLER_CORLOR_696969 bgColor:nil nImage:@"ballTeam" hImage:@"ballTeam" action:@selector(ballTeamButtonAction) target:self buttonTpye:UIButtonTypeCustom];
        ballTeamButton.titleLabel.font = SYSTEM_FONT_S(15.0);
        ballTeamButton.titleEdgeInsets = UIEdgeInsetsMake(1.0, 10.0, -1.0, -10.0);
        _ballTeamButton = ballTeamButton;
        
    }
    if (_ballerCardType == kBallerCardType_MyPlayerCard || _ballerCardType==kBallerCardType_FirstBorn)
    {
        NSString * team_nameString = [[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"team_name"];
        
        NSString * ballTeamString = team_nameString.length?team_nameString:@"未加入球队";
        self.team_name = ballTeamString;
        
        NSString * teamid = [[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"team_id"];
        
        self.team_id = [teamid integerValue]?teamid:nil;
        
    }
    return _ballTeamButton;
}

/*!
 *  @brief  添加分割线
 */
- (void)addLineAndAbility{
    
    [ViewFactory addLayerToView:self.layer frame:CGRectMake(CGRectGetMidX(pathRect)-1, CGRectGetMidY(_ballParkButton.frame)-19.0/2.0, 0.5, 19.0) layerColor:UIColorFromRGB(0Xc6cacd)];
    
    [ViewFactory addLayerToView:self.layer frame:CGRectMake(CGRectGetMidX(pathRect)+1, CGRectGetMidY(_ballParkButton.frame)-27.0/2.0, 0.5, 27.0) layerColor:[UIColor whiteColor]];
    
   CALayer * line = [ViewFactory addLayerToView:self.layer frame:CGRectMake(0.0, CGRectGetMaxY(_ballParkButton.frame)-0.5,pathRect.size.width, 0.5) layerColor:UIColorFromRGB(0Xc6cacd)];
    NSArray *a = [[NSBundle mainBundle] loadNibNamed:@"AbilityView" owner:nil options:nil];
    abilityView = [a firstObject];
    abilityView.frame = CGRectMake(0.0, CGRectGetMaxY(line.frame), self.frame.size.width,288.0);
    
    [self addSubview:abilityView];

}

- (void)setEvaluatedType:(NSString *)evaluatedType{
    if ([_evaluatedType isEqualToString:evaluatedType]) {
        return;
    }
    _evaluatedType = [evaluatedType copy];
    abilityView.evaluateType = _evaluatedType;
}


/*!
 *  @brief  底部三个参数选项
 */
- (void)addBottomSegments{
    NSArray * images = @[[UIImage imageNamed:@"playerCard_height"],[UIImage imageNamed:@"playerCard_weight"],[UIImage imageNamed:@"position"]];
    

    NSArray * parameters = @[$str(@"%@ cm",[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"height"]),$str(@"%@ kg",[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"weight"]),$str(@"%@",[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"position"])];
    
    for (int i = 0; i < 3; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithImage:images[i]];
        imageView.frame = CGRectMake(pathRect.origin.x+i*1.0/3.0*pathRect.size.width, CGRectGetMaxY(whiteBottomlayer.frame)+TextFontSize, pathRect.size.width/3.0, imageView.image.size.height);
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        UILabel * label = [ViewFactory addAlabelForAView:self withText:parameters[i] frame:CGRectMake(pathRect.origin.x+i*1.0/3.0*pathRect.size.width, CGRectGetMaxY(imageView.frame), pathRect.size.width/3.0, BackLayer_CornerRadius) font:SYSTEM_FONT_S(TextFontSize) textColor:[UIColor whiteColor]];
        i?(i == 1? (weightLabel = label): (positonLabel = label)):(heightLabel = label);

    }
    
    [ViewFactory addLayerToView:self.layer frame:CGRectMake(pathRect.origin.x + pathRect.size.width/3.0-0.5, CGRectGetMaxY(whiteBottomlayer.frame)+TextFontSize+2.0, 0.5, pathRect.size.width*PCV_SegmentHeightRatio) layerColor:UIColorFromRGB(0X8c949f)];
    [ViewFactory addLayerToView:self.layer frame:CGRectMake(pathRect.origin.x = 2*pathRect.size.width/3.0-0.5, CGRectGetMaxY(whiteBottomlayer.frame)+TextFontSize+2.0, 0.5, pathRect.size.width*PCV_SegmentHeightRatio) layerColor:UIColorFromRGB(0X8c949f)];



}

#pragma mark 点击方法
/*!
 *  @brief 头像点击方法
 */
- (void)pcv_headImageButtonClicked:(UIButton *)sender{
    
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = self.headImageButton.imageView.image;
    imageInfo.referenceRect = self.headImageButton.frame;
    imageInfo.referenceView = self.headImageButton.superview;
    imageInfo.referenceContentMode = self.headImageButton.contentMode;
    imageInfo.referenceCornerRadius = self.headImageButton.layer.cornerRadius;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    // Present the view controller.
    [imageViewer showFromViewController:[MLViewConrollerManager sharedVCMInstance].rootViewController transition:JTSImageViewControllerTransition_FromOriginalPosition];
    
//    switch (_ballerCardType) {
//        case kBallerCardType_FirstBorn:
//            
//            break;
//        case kBallerCardType_MyPlayerCard:
//            
//            break;
//        case kBallerCardType_CreateBallPark:
//            
//            break;
//        case kBallerCardType_CreateBasketBallTeam:
//            break;
//        case kBallerCardType_OtherBallerPlayerCard:
//            
//            break;
//    }
    
}

/*!
 *  @brief  分享按钮方法
 */
- (void)shareButtonAction{
    __WEAKOBJ(weakSelf, self);
    __block NSString * share_link_url = nil;
    
    CGRect superRect = self.superview.bounds;
    weakSelf.superview.bounds = CGRectMake(0.0, 0.0, ScreenWidth, weakSelf.bounds.size.height+10);
    UIImage * shareImage = [ImageFactory saveImageFromView:weakSelf.superview];
    weakSelf.superview.bounds = superRect;
    
    [AFNHttpRequestOPManager postImageWithSubUrl:Baller_user_share parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"action":@"share"} fileName:@"shareImage" fileData:UIImageJPEGRepresentation(shareImage, 1) fileType:@"image/jpg" responseBlock:^(id result, NSError *error)
    {
        if ([result intForKey:@"errorcode"] == 0)
        {
            
            share_link_url = [[result valueForKey:@"pics"] valueForKey:@"image_url"];
            
            NSString *share_title = [[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"user_name"];
            
            NSString *share_content = @"朋友们,我在Baller创建了球员卡，快来看看吧！";

            
            [[LShareSheetView shareInstance] showShareContent:share_content title:share_title shareUrl:share_link_url shareImage:shareImage targetViewController:nil];
            [[LShareSheetView shareInstance]actionBlock:^(NSInteger buttonIndex, Share_Type shareType) {
                
                if (shareType == Share_QQ) {
                    
                    NSLog(@"Share_QQ");
                    
                }else if (shareType == Share_QQZone){
                    
                    NSLog(@"Share_QQZone");
                    
                }else if (shareType == Share_WeiBo){
                    
                    NSLog(@"Share_WeiBo");
                    
                }else if (shareType == Share_WX_HaoYou){
                    
                    NSLog(@"Share_WX_HaoYou");
                    
                }else if (shareType == Share_WX_PengYouQuan){
                    
                    NSLog(@"Share_WX_PengYouQuan");
                    
                }
                
            }];
            
            [[LShareSheetView shareInstance]shareResult:^(Share_Result result, Share_Type type) {
                
                if (result == Share_Success) {
                    
                    [LTools showMBProgressWithText:@"分享成功" addToView:weakSelf];
                }else
                {
                    NSLog(@"分享失败");
                }
                
            }];

        }
    }];
    
   
    

}
/*!
 *  @brief  私聊按钮方法
 */



- (void)chatButtonAction
{
    [[AppDelegate sharedDelegate] connectRC];
    RCChatViewController * rcChatVC = [[RCIM sharedRCIM]createPrivateChat:[_personalInfo valueForKey:@"uid"] title:[_personalInfo stringForKey:@"user_name"] completion:^{
        [self setRCUserinfo];
    }];
    
    [[[MLViewConrollerManager sharedVCMInstance] navigationController] pushViewController:(UIViewController *)rcChatVC animated:YES];
}

/*!
 *  @brief  评价按钮方法
 */
- (void)evaluateButtonAction
{
    abilityView.showEvaluateViews = !abilityView.showEvaluateViews;
    
}

//关注按钮方法
- (void)attentionButtonAction{
    
    int attendStatus = [_personalInfo intForKey:@"attend_status"];
    BOOL hasAttention = 1==attendStatus%2;
    
    [AFNHttpRequestOPManager getWithSubUrl:Baller_my_attention parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"action":hasAttention?@"can_friend":@"at_friend",@"friend_uid":[_personalInfo valueForKey:@"uid"]} responseBlock:^(id result, NSError *error) {
        if (error) {
            [Baller_HUDView bhud_showWithTitle:@"操作失败，请重试"];
            return ;
        }
        
        if ([result intForKey:@"errorcode"] == 0) {
            [_personalInfo setValue:@(attendStatus==0?1:(attendStatus==1?0:(attendStatus==2?3:2))) forKey:@"attend_status"];
            
            switch ([_personalInfo intForKey:@"attend_status"]) {
                case 0:
                    [self addAttentionButtonWithTitle:@"关注" imageName:@"guangzhu"];
                    break;
                case 2:
                    [self addAttentionButtonWithTitle:@"关注" imageName:@"guangzhu"];
                    break;
                case 1:
                    [self addAttentionButtonWithTitle:@"已关注" imageName:nil];
                    break;
                case 3:
                    [self addAttentionButtonWithTitle:@"我的球友" imageName:nil];
                    break;
                    
                default:
                    break;
            }
        }
        
    }];
    
}



/*!
 *  @brief  我的球场按钮方法
 */
- (void)ballParkButtonAction{
    
    UINavigationController * currentNav = [[MLViewConrollerManager sharedVCMInstance] navigationController];
    
    if (_court_id && _ballerCardType == kBallerCardType_OtherBallerPlayerCard)
    {
        Baller_BallParkHomepageViewController * ballParkHomeVC = [[Baller_BallParkHomepageViewController alloc]init];
        ballParkHomeVC.court_name = _court_name;
        ballParkHomeVC.court_id = _court_id;
        [currentNav pushViewController:ballParkHomeVC animated:YES];
        
    }else{
        switch (_ballerCardType) {
            case kBallerCardType_FirstBorn:
            case kBallerCardType_MyPlayerCard:
            {
                Baller_MyBallParkViewController * ballParkVC = [[Baller_MyBallParkViewController alloc]init];
                ballParkVC ->soureVC = @"2";
                [currentNav pushViewController:ballParkVC animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }


}

/*!
 *  @brief  我的球队按钮方法
 */
- (void)ballTeamButtonAction
{
    UINavigationController * currentNav = [[MLViewConrollerManager sharedVCMInstance] navigationController];
    
    if (_team_id) {
        Baller_MyBasketballTeamViewController * ballTeamVC = [[Baller_MyBasketballTeamViewController alloc]init];
        ballTeamVC.isCloseMJRefresh = YES;
        ballTeamVC.teamId = self.team_id;
        ballTeamVC.teamName = self.team_name;
        ballTeamVC.teamType = _ballerCardType == kBallerCardType_OtherBallerPlayerCard?Baller_TeamOtherTeamType:([[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"team_status"] integerValue]);
        [currentNav pushViewController:ballTeamVC animated:YES];
        
    }else{
        switch (_ballerCardType) {
            case kBallerCardType_FirstBorn:
            case kBallerCardType_MyPlayerCard:
            {
                Baller_ChoseTeamViewController *choseTeamVC = [[Baller_ChoseTeamViewController alloc] init];
                __WEAKOBJ(weakSelf, self)
                choseTeamVC.choseTeamBlock = ^(Baller_BallParkAttentionTeamListModel * chosenTeam) {
                    if (chosenTeam) {
                        __STRONGOBJ(strongSelf, weakSelf);
                        strongSelf.team_id = chosenTeam.team_id;
                        strongSelf.team_name = chosenTeam.team_name;
                    }
                };
                [currentNav pushViewController:choseTeamVC animated:YES];
                
            }
                
                break;
                
            default:
                break;
        }

    }
    
}

/*!
 *  @brief   底部按钮点击回调方法
 */
- (void)bottomButtonClicked{
    
    if (_bottomButtonClickedBlock) {
        self.bottomButtonClickedBlock(_ballerCardType);
    }
}

#pragma  mark 计算

/*!
 *  @brief  获取能力区分图六边形顶点坐标
 *
 *  @param abilityLayer 能力底图
 *
 *  @return 存放点值的数组
 */
- (NSMutableArray * )sixPointsOfAbilityLayer:(CALayer *)abilityLayer{
    
    NSMutableArray * points = $marrnew;
    
    CGPoint topPoint = CGPointMake(CGRectGetMidX(pathRect)-NUMBER(19.0, 19.0, 12.0, 19.0), CGRectGetMinY(abilityLayer.frame)-NUMBER(38.0, 38.0, 28.0, 38.0));
    [points addObject:[NSValue valueWithCGPoint:topPoint]];
    
    CGPoint rightTopPoint = CGPointMake(CGRectGetMaxX(abilityLayer.frame)-NUMBER(13.0, 10.0, 10.0, 10.0), CGRectGetMinY(abilityLayer.frame)+CGRectGetHeight(abilityLayer.bounds)/6.0-NUMBER(10.0, 10.0, 10.0, 10.0));
    [points addObject:[NSValue valueWithCGPoint:rightTopPoint]];
    
    CGPoint rightBottomPoint = CGPointMake(CGRectGetMaxX(abilityLayer.frame)-NUMBER(10.0, 10.0, 10.0, 10.0), CGRectGetMinY(abilityLayer.frame)+2*CGRectGetHeight(abilityLayer.bounds)/3.0);
    [points addObject:[NSValue valueWithCGPoint:rightBottomPoint]];
    
    CGPoint bottomPoint = CGPointMake(CGRectGetMidX(pathRect)-NUMBER(10.0, 10.0, 10.0, 10.0), CGRectGetMaxY(abilityLayer.frame)-NUMBER(2.0, 2.0, 2.0, 2.0));
    [points addObject:[NSValue valueWithCGPoint:bottomPoint]];
    
    CGPoint leftBottomPoint = CGPointMake(CGRectGetMinX(abilityLayer.frame)-NUMBER(28.0, 28.0, 20.0, 28.0), CGRectGetMinY(abilityLayer.frame)+2*CGRectGetHeight(abilityLayer.bounds)/3.0-NUMBER(3.0, 3.0, 3.0, 3.0));
    [points addObject:[NSValue valueWithCGPoint:leftBottomPoint]];
    
    CGPoint leftTopPoint = CGPointMake(CGRectGetMinX(abilityLayer.frame)-NUMBER(28.0, 28.0, 20.0, 28.0), CGRectGetMinY(abilityLayer.frame)+CGRectGetHeight(abilityLayer.bounds)/6.0-NUMBER(15.0, 15.0, 8.0, 15.0));
    [points addObject:[NSValue valueWithCGPoint:leftTopPoint]];
    
    return points;
}

- (NSMutableArray * )sixPointsOfAbilityContentLayer:(CALayer *)abilityLayer contentRatios:(NSArray *)ratios{
 
    NSMutableArray * abilityContenLayerPoints = $marrnew;

    return abilityContenLayerPoints;
}


#pragma mark 创建球场模式状态视图

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}

#pragma mark 融云用户系统
- (void)setRCUserinfo{
    [self userHeadClicked];
    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:YES];

}

- (NSMutableArray *)chatUsers
{
    if (!_chatUsers) {
        _chatUsers = [NSMutableArray new];
        
        RCUserInfo * myUserInfo = [[RCUserInfo alloc]initWithUserId:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"] name:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"user_name"] portrait:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"photo"]];
        
        RCUserInfo * friendUserInfo = [[RCUserInfo alloc]initWithUserId:[_personalInfo valueForKey:@"uid"] name:[_personalInfo valueForKey:@"user_name"] portrait:[_personalInfo valueForKey:@"photo"]];
        
        [_chatUsers addObject:myUserInfo];
        [_chatUsers addObject:friendUserInfo];
    }
    
    return _chatUsers;
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion{

    RCUserInfo *user  = nil;
    if([userId length] == 0)
        return completion(nil);
    for(RCUserInfo *u in self.chatUsers)
    {
        if([u.userId isEqualToString:userId])
        {
            user = u;
            break;
        }
    }
    return completion(user);
}

#pragma mark RCIMFriendsFetcherDelegate


- (void)userHeadClicked
{
    [[RCIM sharedRCIM] setUserPortraitClickEvent:^(UIViewController *viewController, RCUserInfo *userInfo) {
        DLog(@"%@,%@",viewController,userInfo);
        
        Baller_PlayerCardViewController *temp = [[Baller_PlayerCardViewController alloc]init];
        if ([userInfo.userId isEqualToString:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"]]) {
            temp.ballerCardType = kBallerCardType_MyPlayerCard;
        }else{
            temp.uid = userInfo.userId;
            temp.userName = userInfo.name;
            temp.photoUrl = userInfo.portraitUri;
            temp.ballerCardType = kBallerCardType_OtherBallerPlayerCard;
        }
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:temp];
        
        //导航和的配色保持一直
        UIImage *image= [viewController.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
        
        [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
        
        [viewController presentViewController:nav animated:YES completion:NULL];
        
    }];
}



@end
