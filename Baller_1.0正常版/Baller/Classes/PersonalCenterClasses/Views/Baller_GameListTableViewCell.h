//
//  Baller_GameListTableViewCell.h
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

typedef NS_ENUM(NSInteger, GameStadus) {
    //比赛状态
    GameStadusDone = 0,         //比赛已结束
    GameStadusProgressing,      //比赛正进行
    GameStadusCanJoin           //比赛可被申请加入

};

#import <UIKit/UIKit.h>

@interface Baller_GameListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinedNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *gameStadusButton;
- (IBAction)gameStadusButtonAction:(id)sender;
@property (nonatomic,strong)CALayer * line;
@property (nonatomic)GameStadus gameStadus;

@end
