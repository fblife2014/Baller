//
//  Baller_BallFriendsTableViewCell.h
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Baller_BaseTableViewCell.h"
@class CircleView;
@class Baller_BallerFriendListModel;
@interface Baller_BallFriendsTableViewCell : Baller_BaseTableViewCell
{
    CircleView * _circleView;
}
@property (strong, nonatomic) IBOutlet UIView *basketBallPark;
@property (strong, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *BallParkName;
@property (nonatomic)BOOL invitateStatus; //邀请状态
@property (nonatomic)BOOL chosing;  //选择球友的状态。该状态下，展示左侧圆圈
@property (nonatomic,strong)Baller_BallerFriendListModel * friendListModel;
@end

@interface CircleView : UIView
@property (nonatomic,strong)CALayer * grayLayer;
@end