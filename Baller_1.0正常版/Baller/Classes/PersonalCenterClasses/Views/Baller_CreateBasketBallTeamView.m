//
//  Baller_CreateBasketBallTeamView.m
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_CreateBasketBallTeamView.h"
#import "Baller_MyBallFriendsViewController.h"

#import "Baller_ImagePicker.h"
@implementation Baller_CreateBasketBallTeamView

- (void)awakeFromNib{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)updateLogo:(id)sender {
    
    [[self baller_ImagePicker] showImageChoseAlertView];

}

- (IBAction)inviteFriends:(id)sender {
    Baller_MyBallFriendsViewController * ballFriendVC = [[Baller_MyBallFriendsViewController alloc]init];
    ballFriendVC.ballFriendsListType = BallFriendsListTypeChosing;
    __BLOCKOBJ(blockSelf, self);
    ballFriendVC.myBallFriendsEndChoseBallFriendsBlock = ^(NSArray * invitedFriends){
        blockSelf.partnerNumberLabel.text = [NSString stringWithFormat:@"已邀请%lu位",(unsigned long)invitedFriends.count];
        [blockSelf.inviteFriendsButton setTitle:@"继续邀请" forState:UIControlStateNormal];
        [MLViewConrollerManager popToLastViewController];
    };
    [[[MLViewConrollerManager sharedVCMInstance]rootViewController].navigationController pushViewController:ballFriendVC animated:YES];
}


- (Baller_ImagePicker *)baller_ImagePicker
{
    if (!_baller_ImagePicker) {
        Baller_ImagePicker * baller_ImagePicker = [[Baller_ImagePicker alloc]init];
        _baller_ImagePicker = baller_ImagePicker;
        __BLOCKOBJ(blockSelf, self);
        _baller_ImagePicker.baller_ImagePicker_ImageChosenBlock = (^(UIImage * image){
            blockSelf.teamLogoImageView.image = image;
        });
    }
    return _baller_ImagePicker;
}



@end
