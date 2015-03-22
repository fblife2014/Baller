//
//  Baller_MyBasketBallTeamTableViewCell.h
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

typedef NS_ENUM(NSInteger, PartnerType) {
    PartnerType_Offline = 0, //离线
    PartnerType_Online,      //在线
    PartnerType_Captain,     //队长
};

/// 我的球队队友列表cell
#import <UIKit/UIKit.h>
#import "Baller_BaseTableViewCell.h"

@interface Baller_MyBasketBallTeamTableViewCell : Baller_BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *stadusImageView;

@property (weak, nonatomic) IBOutlet UILabel *heightLabel;

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *memberImage;

@property (weak, nonatomic) IBOutlet UILabel *memberName;

@property (nonatomic) PartnerType partnerType;

@end
