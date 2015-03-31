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

#import "Baller_BallerFriendListModel.h"

@implementation Baller_CreateBasketBallTeamView

- (void)awakeFromNib{

}

- (NSMutableArray *)invitedFriends
{
    if (!_invitedFriends) {
        _invitedFriends = [NSMutableArray new];
    }
    return _invitedFriends;
}


- (IBAction)updateLogo:(id)sender {
    
    [[self baller_ImagePicker] showImageChoseAlertView];

}

- (IBAction)inviteFriends:(id)sender {
    
    UINavigationController * currentNav = [[MLViewConrollerManager sharedVCMInstance] navigationController];
    Baller_MyBallFriendsViewController * ballFriendVC = [[Baller_MyBallFriendsViewController alloc]init];
    ballFriendVC.ballFriendsListType = BallFriendsListTypeChosing;
    __WEAKOBJ(weakSelf, self);
    ballFriendVC.myBallFriendsEndChoseBallFriendsBlock = ^(NSArray * invitedFriends){
        __STRONGOBJ(strongSelf, self);
        for (Baller_BallerFriendListModel * friendModel in invitedFriends) {
            if (![strongSelf.invitedFriends containsObject:friendModel]) {
                [strongSelf.invitedFriends addObject:friendModel];
            }
            
        };
        strongSelf.partnerNumberLabel.text = [NSString stringWithFormat:@"已邀请%lu位",(unsigned long)weakSelf.invitedFriends.count];
        [strongSelf.inviteFriendsButton setTitle:@"继续邀请" forState:UIControlStateNormal];
    };
    [currentNav pushViewController:ballFriendVC animated:YES];
}


- (Baller_ImagePicker *)baller_ImagePicker
{
    if (!_baller_ImagePicker) {
        Baller_ImagePicker * baller_ImagePicker = [[Baller_ImagePicker alloc]init];
        _baller_ImagePicker = baller_ImagePicker;
        
        __BLOCKOBJ(blockSelf, self);
        __WEAKOBJ(weakSelf, self);
        _baller_ImagePicker.baller_ImagePicker_ImageChosenBlock = (^(UIImage * image){
            blockSelf.teamLogoImageView.image = image;
            weakSelf.teamLogoData = UIImageJPEGRepresentation(image, 0.2);
        });
    }
    return _baller_ImagePicker;
}



@end
