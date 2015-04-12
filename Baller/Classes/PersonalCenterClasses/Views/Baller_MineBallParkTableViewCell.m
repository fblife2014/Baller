//
//  Baller_MineBallParkTableViewCell.m
//  Baller
//
//  Created by malong on 15/1/25.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MineBallParkTableViewCell.h"
#import "Baller_MyAttentionBallPark.h"
#import "Baller_MyCourtInfo.h"

#import "UIView+ML_BlurView.h"
@implementation Baller_MineBallParkTableViewCell

- (void)awakeFromNib {
    self.ballParkImageView.clipsToBounds = YES;
    self.ballParkImageView.blurView.alpha = 0.8;
    [self.contentView bringSubviewToFront:self.homeCourtImageView];
    [self.contentView bringSubviewToFront:self.homeCourtLabel];

}

- (void)setIsHomeCourt:(BOOL)isHomeCourt{

    if (_isHomeCourt == isHomeCourt) {
        return;
    }
    _isHomeCourt = isHomeCourt;
    self.homeCourtImageView.hidden = !isHomeCourt;
    self.homeCourtLabel.hidden = !isHomeCourt;
}

- (void)setBallParkModel:(Baller_MyAttentionBallPark *)ballParkModel{
    if (_ballParkModel == ballParkModel) {
        return;
    }
    _ballParkModel = ballParkModel;
    [self.ballParkImageView sd_setImageWithURL:[NSURL URLWithString:ballParkModel.court_img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.ballParkImageView showBlurWithDuration:1.0 blurStyle:kUIBlurEffectStyleLight belowView:nil radius:40];

    }];
    self.ballParkNameLabel.text = ballParkModel.court_name;
    self.isHomeCourt = (ballParkModel.court_id == [[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"court_id"] intValue]);
}

- (void)setMyCourtInfo:(Baller_MyCourtInfo *)myCourtInfo{
    if (_myCourtInfo == myCourtInfo) {
        return;
    }
    _myCourtInfo = myCourtInfo;
    [self.ballParkImageView sd_setImageWithURL:[NSURL URLWithString:myCourtInfo.court_img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.ballParkImageView showBlurWithDuration:1.0 blurStyle:kUIBlurEffectStyleLight belowView:nil radius:40];

    }];
    self.ballParkNameLabel.text = myCourtInfo.court_name;
    self.isHomeCourt = myCourtInfo.home_court;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
