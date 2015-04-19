//
//  Baller_PlayerCardView.h
//  Baller
//
//  Created by malong on 15/1/17.
//  Copyright (c) 2015年 malong. All rights reserved.
//


/*!
 *  @brief  <#Description#>
 */

typedef NS_ENUM(NSUInteger, BallerCardType) {
    kBallerCardType_FirstBorn = 0,      //首次生成我的球员卡
    kBallerCardType_OtherBallerPlayerCard,//其他球员的球员卡
    kBallerCardType_MyPlayerCard,       //平时我的球员卡
    kBallerCardType_CreateBallPark,     //创建球场
    kBallerCardType_CreateBasketBallTeam    //创建球队

};

typedef void(^CardView_BottomButtonClicked) (BallerCardType ballerCardType);

#import <UIKit/UIKit.h>
#import "Baller_CreateBallParkView.h"
#import "Baller_CreateBasketBallTeamView.h"
@class Baller_AbilityView;
@class Baller_AbilityEditorView;
@interface Baller_CardView : UIScrollView
{
    CGRect pathRect;          //背景layer 的 path
    CAShapeLayer * backLayer; //背景层
    UILabel * _nickNameLabel; //昵称
    CALayer * whiteBottomlayer; //白色底板
    
    Baller_AbilityView * abilityView;
    Baller_AbilityEditorView * abilityEditorView;
    CAShapeLayer * abilityContentLabyer;  //能力值呈现图谱
    UILabel * levelLabel; //关注按钮
    UIButton * attentionButton; //关注按钮
    UIButton * showDetailButton; //显示能力图谱分级的按钮
    
    UILabel * positonLabel;
    UILabel * weightLabel;
    UILabel * heightLabel;
    
    @public
    UIButton * ballParkButton;
}

@property (nonatomic) BallerCardType ballerCardType;
@property (nonatomic,copy)NSString * uid; //被评价用户的用户id
@property (nonatomic,copy)NSString * evaluatedType;
@property (nonatomic,copy)NSString * activity_id;
@property (nonatomic,strong)NSMutableDictionary * personalInfo; //个人信息

@property (nonatomic, strong)UIButton * headImageButton;
@property (nonatomic, strong)UIButton * ballParkButton;
@property (nonatomic,copy)NSString * court_id;
@property (nonatomic,copy)NSString * court_name;

@property (nonatomic, strong)UIButton * ballTeamButton;
@property (nonatomic,copy)NSString * team_id;
@property (nonatomic,copy)NSString * team_name;

@property (nonatomic, assign)UIViewController *tagetViewController;//分享目标

@property (nonatomic, copy)CardView_BottomButtonClicked bottomButtonClickedBlock; //底部按钮点中后的块方法

@property (nonatomic, strong)UIButton * bottomButton; //底部按钮

@property (nonatomic, strong)Baller_CreateBallParkView * createBallParkView;
@property (nonatomic, strong)Baller_CreateBasketBallTeamView * createTeamView;
@property (nonatomic,copy)NSMutableDictionary * abilityDetailInfo; //能力详情


@property (nonatomic,strong)NSMutableArray * chatUsers; //聊天双方信息

- (id)initWithFrame:(CGRect)frame
     playerCardType:(BallerCardType)ballerCardType;

- (void)addLevelLabelWithLevelText:(NSString *)levelText;

@end
