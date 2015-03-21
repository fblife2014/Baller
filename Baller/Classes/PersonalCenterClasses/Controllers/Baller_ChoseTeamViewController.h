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
typedef void (^ChoseTeamBlock)(NSDictionary * chosenTeamInfo);  //选中的球队信息回调

#import "BaseTableViewController.h"

@interface Baller_ChoseTeamViewController : BaseTableViewController

@property (nonatomic,copy)ChoseTeamBlock choseTeamBlock;

@end
