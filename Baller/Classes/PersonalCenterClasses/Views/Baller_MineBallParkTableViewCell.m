//
//  Baller_MineBallParkTableViewCell.m
//  Baller
//
//  Created by malong on 15/1/25.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MineBallParkTableViewCell.h"
#import "UIView+ML_BlurView.h"
@implementation Baller_MineBallParkTableViewCell

- (void)awakeFromNib {
    self.ballParkImageView.clipsToBounds = YES;
    [self.ballParkImageView showBlurWithDuration:0.5 blurStyle:kUIBlurEffectStyleLight belowView:nil];
    self.ballParkImageView.blurView.alpha = 0.8;
}

- (void)setIsHomeCourt:(BOOL)isHomeCourt{
    if (_isHomeCourt == isHomeCourt) {
        return;
    }
    _isHomeCourt = isHomeCourt;
    self.homeCourtImageView.hidden = !isHomeCourt;
    self.homeCourtLabel.hidden = !isHomeCourt;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
