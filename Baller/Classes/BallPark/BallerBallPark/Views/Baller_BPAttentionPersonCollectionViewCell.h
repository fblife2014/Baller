//
//  Baller_BPAttentionPersonCollectionViewCell.h
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

//球场关注人员列表cell

#import <UIKit/UIKit.h>
@class Baller_BallParkAttentionBallerListModel;
@class Baller_WaitingEvaluateBallerInfo;

@interface Baller_BPAttentionPersonCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (nonatomic,strong)Baller_BallParkAttentionBallerListModel * ballerModel;

@property (nonatomic,strong)Baller_WaitingEvaluateBallerInfo * waitingEvaluateBallerInfo;

@end
