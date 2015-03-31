//
//  Baller_ChoseTeamViewController.h
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

/*!
 *  @brief  选择球队控制器
 */

#import "BaseTableViewController.h"
#import "Baller_BallParkAttentionTeamListModel.h"

typedef void (^ChoseTeamBlock)(Baller_BallParkAttentionTeamListModel * chosenTeam);  //选中的球队信息回调


@interface Baller_ChoseTeamViewController : BaseTableViewController

@property (nonatomic,copy)ChoseTeamBlock choseTeamBlock;

@end
