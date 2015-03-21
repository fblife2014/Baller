//
//  Baller_GameListTableViewCell.h
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Baller_BaseTableViewCell.h"
@class Baller_BallParkActivityListModel;

@interface Baller_GameListTableViewCell : Baller_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinedNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *gameStadusButton;
- (IBAction)gameStadusButtonAction:(id)sender;
@property (nonatomic,strong)CALayer * line;
@property (nonatomic)BOOL canJoin; //可以加入
@property (nonatomic,strong)Baller_BallParkActivityListModel * activityModel;


@end
