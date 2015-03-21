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
    kBallerCardType_MyPlayerCard,       //平时我的球员卡
    kBallerCardType_CreateBallPark,     //创建球场
    kBallerCardType_CreateBasketBallTeam    //创建球队

};

typedef void(^CardView_BottomButtonClicked) (BallerCardType ballerCardType);

#import <UIKit/UIKit.h>
#import "Baller_CreateBallParkView.h"
#import "Baller_CreateBasketBallTeamView.h"
@class Baller_AbilityView;

@interface Baller_CardView : UIScrollView
{
    CGRect pathRect;          //背景layer 的 path
    CAShapeLayer * backLayer; //背景层
    UILabel * _nickNameLabel; //昵称
    CALayer * whiteBottomlayer;
    
    Baller_AbilityView * abilityView;
    CAShapeLayer * abilityContentLabyer;  //能力值呈现图谱
    @public
    UIButton * ballParkButton ;
}

@property (nonatomic) BallerCardType ballerCardType;

@property (nonatomic, strong)UIButton * headImageButton;
@property (nonatomic, strong)UIButton * ballParkButton;
@property (nonatomic, strong)UIButton * ballTeamButton;

@property (nonatomic, copy)CardView_BottomButtonClicked bottomButtonClickedBlock; //底部按钮点中后的块方法

@property (nonatomic, strong)UIButton * bottomButton;

@property (nonatomic, strong)Baller_CreateBallParkView * createBallParkView;
@property (nonatomic, strong)Baller_CreateBasketBallTeamView * createTeamView;
@property (nonatomic,copy)NSArray * abilityDetails; //能力详情

- (id)initWithFrame:(CGRect)frame
     playerCardType:(BallerCardType)ballerCardType;

@end
