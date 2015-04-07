//
//  Baller_MyBasketBallTeamTableViewCell.m
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyBasketBallTeamTableViewCell.h"
#import "Baller_ImageUtil.h"
#import "Baller_ColorMatrix.h"

@interface Baller_MyBasketBallTeamTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sfRightMarge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightRightMarge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftMarge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signLeftMarge;

@end

@implementation Baller_MyBasketBallTeamTableViewCell

- (void)awakeFromNib
{
    self.memberImage.layer.borderColor = BALLER_CORLOR_b2b2b2.CGColor;
    self.sfRightMarge.constant = NUMBER(45, 35, 30, 30);
    self.heightRightMarge.constant = NUMBER(71, 50, 30, 30);
    self.nameLeftMarge.constant = NUMBER(28, 20, 15, 15);
    self.signLeftMarge.constant = NUMBER(11, 8, 3, 3);
}

- (void)setPartnerType:(PartnerType)partnerType {
    _partnerType = partnerType;
    switch (partnerType) {
        case PartnerType_Online:
        case PartnerType_Offline:
            self.stadusImageView.image = nil;
            break;
        case PartnerType_Captain:
            self.stadusImageView.image = [UIImage imageNamed:@"duizhang"];
            break;
    }
}

@end
