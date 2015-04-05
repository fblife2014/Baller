//
//  Baller_MineBallParkTableViewCell.h
//  Baller
//
//  Created by malong on 15/1/25.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Baller_BaseTableViewCell.h"
@class Baller_MyAttentionBallPark;
@class Baller_MyCourtInfo;
@interface Baller_MineBallParkTableViewCell : Baller_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ballParkImageView;
@property (weak, nonatomic) IBOutlet UILabel *ballParkNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *homeCourtImageView;
@property (weak, nonatomic) IBOutlet UILabel *homeCourtLabel;
@property (nonatomic,strong)Baller_MyAttentionBallPark * ballParkModel;
@property (nonatomic,strong)Baller_MyCourtInfo * myCourtInfo;
@property (nonatomic)BOOL isHomeCourt; 

@end
