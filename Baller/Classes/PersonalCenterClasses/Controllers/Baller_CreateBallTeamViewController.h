//
//  Baller_CreateBallTeamViewController.h
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

typedef void (^BasketBallTeamCreatedBlock)(NSDictionary * resultDic);

#import "BaseViewController.h"
#import "Baller_CardView.h"

@interface Baller_CreateBallTeamViewController : BaseViewController
@property (nonatomic,strong)Baller_CardView * createTeamCardView;
@property (nonatomic,copy)BasketBallTeamCreatedBlock basketBallTeamCreatedBlock;
@end
