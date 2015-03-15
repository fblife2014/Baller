//
//  Baller_BasketBallTeamTableViewCell.m
//  Baller
//
//  Created by malong on 15/1/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BasketBallTeamTableViewCell.h"

@implementation Baller_BasketBallTeamTableViewCell

- (void)awakeFromNib {
    self.imageView.image = [UIImage imageNamed:@"ballPark_default"];
    self.imageView.clipsToBounds = YES;
    self.textLabel.backgroundColor = CLEARCOLOR;
    self.textLabel.font = SYSTEM_FONT_S(17.0);
    self.textLabel.textColor = BALLER_CORLOR_696969;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(NUMBER(20.0, 15.0, 10.0, 10.0)+TABLE_SPACE_INSET, 23.0, 64, 64);
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+15.0, 45.5, 120, 19.0);


}

@end
