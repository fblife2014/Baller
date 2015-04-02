//
//  Baller_MyBasketballTeamViewController.h
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

typedef NS_ENUM(NSInteger, Baller_TeamType) {
    Baller_TeamWaitingCheckType = 0,   //请求加入向其他球队后的等待状态
    Baller_TeamJoinedType,      //已加入状态
    Baller_TeamNotJoinedType,   //未加入状态，可申请加入或自己创建球队
    Baller_TeamOtherTeamType,   //展示其他球队状态，只可查看其详情
    Baller_TeamInvitingType     //被邀请状态

};

#import "BaseTableViewController.h"
@interface Baller_MyBasketballTeamViewController : BaseTableViewController

@property (nonatomic,copy)NSString * teamId; //球队id
@property (nonatomic,copy)NSString * teamName; //球队名
@property (nonatomic)Baller_TeamType teamType; //球队详情页状态

@end