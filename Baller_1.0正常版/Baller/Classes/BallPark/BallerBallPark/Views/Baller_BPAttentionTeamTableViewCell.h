//
//  Baller_BPAttentionTeamTableViewCell.h
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

//球场相关球队列表的cell
#import <UIKit/UIKit.h>
#import "Baller_BaseTableViewCell.h"
@class Baller_BallTeamInfo;

@interface Baller_BPAttentionTeamTableViewCell : Baller_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *teamNumberLabel;

@property (nonatomic, strong)Baller_BallTeamInfo * teamInfo;
@end
