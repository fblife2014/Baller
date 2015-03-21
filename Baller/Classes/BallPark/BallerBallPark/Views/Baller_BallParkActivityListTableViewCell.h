//
//  Baller_BallParkActivityListTableViewCell.h
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Baller_BaseTableViewCell.h"
@class Baller_BallParkActivityListModel;

@interface Baller_BallParkActivityListTableViewCell : Baller_BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *menberLabel;
@property (strong, nonatomic) IBOutlet UIButton *jionButton;
@property (nonatomic,strong)Baller_BallParkActivityListModel * activitiyModel;

- (IBAction)jionButtonAction:(id)sender;
- (IBAction)userButtonAction:(id)sender;

@end
