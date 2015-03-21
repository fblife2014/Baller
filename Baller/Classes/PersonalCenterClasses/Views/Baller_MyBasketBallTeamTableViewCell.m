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

@implementation Baller_MyBasketBallTeamTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imageView.image = [UIImage imageNamed:@"ballPark_default"];
    self.imageView.layer.cornerRadius = 4.0;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderColor = BALLER_CORLOR_b2b2b2.CGColor;
    self.textLabel.backgroundColor = CLEARCOLOR;
    self.textLabel.font = SYSTEM_FONT_S(15.0);
    self.textLabel.textColor = BALLER_CORLOR_696969;
    self.textLabel.text = @"王宝强";
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(15.0+NUMBER(33.0, 30, 23.0, 23.0), 11.5, 41, 41);
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+15.0, 24.5, 120, 15.0);

}

- (void)setPartnerType:(PartnerType)partnerType{
//    if (_partnerType == partnerType) {
//        return;
//    }
    
    _partnerType = partnerType;
    switch (partnerType) {
        case PartnerType_Online:
        case PartnerType_Offline:
            self.stadusImageView.image = nil;
            self.imageView.image = [UIImage imageNamed:@"ballPark_default"];

            break;
        case PartnerType_Captain:
            self.stadusImageView.image = [UIImage imageNamed:@"duizhang"];
            self.imageView.image = [UIImage imageNamed:@"ballPark_default"];

            break;
            
        default:
            break;
    }
    [self setNeedsDisplay];
}


@end
