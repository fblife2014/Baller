//
//  Baller_CreateBasketBallTeamView.h
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//
@class Baller_ImagePicker;

#import <UIKit/UIKit.h>

@interface Baller_CreateBasketBallTeamView : UIView
{
    Baller_ImagePicker * _baller_ImagePicker;
}
@property (strong, nonatomic) IBOutlet UIButton *updateTeamLogoButton;
@property (strong, nonatomic) IBOutlet UIButton *inviteFriendsButton;
@property (strong, nonatomic) IBOutlet UILabel *partnerNumberLabel;
@property (strong, nonatomic) IBOutlet UITextField *teamNameTextfield;

- (IBAction)updateLogo:(id)sender;
- (IBAction)inviteFriends:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *teamLogoImageView;
@property (nonatomic,strong) __block NSData * teamLogoData; //球场logo图片数据
@property (nonatomic,strong)__block NSMutableArray * invitedFriends; //邀请的好友
@end
