//
//  Baller_BallParkActivityListTableViewCell.m
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BallParkActivityListTableViewCell.h"
#import "Baller_BallParkActivityListModel.h"

@implementation Baller_BallParkActivityListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setActivitiyModel:(Baller_BallParkActivityListModel *)activitiyModel{
    if (_activitiyModel == activitiyModel) {
        return;
    }
    _activitiyModel = activitiyModel;
    
    self.jionButton.layer.borderColor = (activitiyModel.hasJoined)?RGB(253.0, 174.0, 42.0).CGColor:BALLER_CORLOR_696969.CGColor;
    self.jionButton.backgroundColor = (activitiyModel.hasJoined)?RGB(253.0, 174.0, 42.0):[UIColor whiteColor];
    [self.jionButton setTitle:(activitiyModel.hasJoined?@"邀请加入":@"+ 加入") forState:UIControlStateNormal];
    [self.jionButton setTitleColor:(activitiyModel.hasJoined?[UIColor whiteColor]:BALLER_CORLOR_696969) forState:UIControlStateNormal];
    [self setNeedsDisplay];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(15.0+NUMBER(20, 18, 15, 15), 18.0, 60, 60);
    self.imageView.layer.cornerRadius = 7.0;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.image = [UIImage imageNamed:@"ballPark_default"];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderColor = BALLER_CORLOR_b2b2b2.CGColor;
    
    self.textLabel.frame = CGRectMake(CGRectGetMinX(self.imageView.frame)-10.0, CGRectGetMaxY(self.imageView.frame)+7.0, 80.0, 11.0);
    self.textLabel.backgroundColor = CLEARCOLOR;
    self.textLabel.font = SYSTEM_FONT_S(11.0);
    self.textLabel.textColor = BALLER_CORLOR_696969;
    self.textLabel.text = @"Brad Pitt";
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}


- (IBAction)jionButtonAction:(id)sender {
}
@end
