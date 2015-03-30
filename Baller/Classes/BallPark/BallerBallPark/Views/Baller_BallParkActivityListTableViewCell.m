//
//  Baller_BallParkActivityListTableViewCell.m
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BallParkActivityListTableViewCell.h"
#import "Baller_BallParkActivityListModel.h"
#import "Baller_MyBallFriendsViewController.h"
#import "Baller_BallerFriendListModel.h"

@implementation Baller_BallParkActivityListTableViewCell

- (void)awakeFromNib {
    self.imageView.layer.cornerRadius = 7.0;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderColor = BALLER_CORLOR_b2b2b2.CGColor;
    self.textLabel.backgroundColor = CLEARCOLOR;
    self.textLabel.font = SYSTEM_FONT_S(11.0);
    self.textLabel.textColor = BALLER_CORLOR_696969;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
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
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:activitiyModel.user_photo] placeholderImage:[UIImage imageNamed:@"ballPark_default"]];
    self.textLabel.text = activitiyModel.user_name;
    self.timeLabel.text = [TimeManager getHourAndMiniteStringOfTimeInterval:activitiyModel.start_time];
    self.menberLabel.text = $str(@"%ld人已加入",activitiyModel.join_num);
        
    if (activitiyModel.status == 1) {
        if ([TimeManager theSuccessivelyWithCurrentTimeFrom:activitiyModel.start_time]) {
            if (activitiyModel.join_num == activitiyModel.max_num) {
                self.jionButton.userInteractionEnabled = NO;
                [self.jionButton setTitle:@"已满员" forState:UIControlStateNormal];
                self.jionButton.layer.borderColor = BALLER_CORLOR_NAVIGATIONBAR.CGColor;
                self.jionButton.backgroundColor = BALLER_CORLOR_NAVIGATIONBAR;
                [self.jionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }else{
                self.jionButton.userInteractionEnabled = YES;
                [self.jionButton setTitle:(activitiyModel.is_join?@"邀请加入":@"+ 加入") forState:UIControlStateNormal];
                self.jionButton.layer.borderColor = (activitiyModel.is_join)?RGB(253.0, 174.0, 42.0).CGColor:BALLER_CORLOR_696969.CGColor;
                self.jionButton.backgroundColor = (activitiyModel.is_join)?RGB(253.0, 174.0, 42.0):[UIColor whiteColor];
                [self.jionButton setTitleColor:(activitiyModel.is_join?[UIColor whiteColor]:BALLER_CORLOR_696969) forState:UIControlStateNormal];
            }
            
        }else if ([TimeManager theSuccessivelyWithCurrentTimeFrom:activitiyModel.end_time]){
            [self.jionButton setTitle:@"正在进行" forState:UIControlStateNormal];
            self.jionButton.layer.borderColor = BALLER_CORLOR_NAVIGATIONBAR.CGColor;
            self.jionButton.backgroundColor = BALLER_CORLOR_NAVIGATIONBAR;
            [self.jionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.jionButton.userInteractionEnabled = NO;
        }else{
            [self.jionButton setTitle:@"已结束" forState:UIControlStateNormal];
            self.jionButton.layer.borderColor = BALLER_CORLOR_NAVIGATIONBAR.CGColor;
            self.jionButton.backgroundColor = BALLER_CORLOR_NAVIGATIONBAR;
            [self.jionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.jionButton.userInteractionEnabled = NO;

        }
        
    }else if (activitiyModel.status == 2)
    {
        [self.jionButton setTitle:@"已解散" forState:UIControlStateNormal];
        self.jionButton.layer.borderColor = BALLER_CORLOR_RED.CGColor;
        self.jionButton.backgroundColor = BALLER_CORLOR_RED;
        [self.jionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.jionButton.userInteractionEnabled = NO;
    }
    
    [self setNeedsDisplay];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(15.0+NUMBER(20, 18, 15, 15), 18.0, 60, 60);
    self.textLabel.frame = CGRectMake(CGRectGetMinX(self.imageView.frame)-10.0, CGRectGetMaxY(self.imageView.frame)+7.0, 80.0, 11.0);

}

/*!
 *  @brief  点击加入或邀请加入的方法
 */
- (IBAction)jionButtonAction:(id)sender {
    UIButton * button = (UIButton *)sender;
    DLog(@"senderTitle = %@",button.titleLabel.text);
    if ([button.titleLabel.text isEqualToString:@"邀请加入"]) {
        Baller_MyBallFriendsViewController * friednVC = [[Baller_MyBallFriendsViewController alloc]init];
        friednVC.ballFriendsListType = BallFriendsListTypeChosing;
        friednVC.myBallFriendsEndChoseBallFriendsBlock = ^(NSArray * chosedFriends)
        {
            NSString * uids = nil;
            for (Baller_BallerFriendListModel * friendModel in chosedFriends)
            {
                if (nil == uids) {
                    uids = friendModel.friend_uid;
                }else{
                    uids = $str(@"%@,%@",uids,friendModel.friend_uid);

                }
            }
            if (uids) {
                [AFNHttpRequestOPManager getWithSubUrl:Baller_invite_join_activity parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode ],@"activity_id":_activitiyModel.activity_id,@"uid":uids} responseBlock:^(id result, NSError *error)
                 {
                     if (error) return ;
                     [Baller_HUDView bhud_showWithTitle:[result valueForKey:@"msg"]];
                     
                 }];
            }
        };
        [[[MLViewConrollerManager sharedVCMInstance] navigationController]pushViewController:friednVC animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"+ 加入"]) {
        [AFNHttpRequestOPManager getWithSubUrl:Baller_activities_join parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"activity_id":_activitiyModel.activity_id} responseBlock:^(id result, NSError *error) {
            if (error) {
                [Baller_HUDView bhud_showWithTitle:error.domain];
                return ;
            }
            if ([result integerForKey:@"errorcode"] == 0) {
                [self.jionButton setTitle:@"邀请加入" forState:UIControlStateNormal];
                self.jionButton.layer.borderColor = RGB(253.0, 174.0, 42.0).CGColor;
                self.jionButton.backgroundColor = RGB(253.0, 174.0, 42.0);
                [self.jionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            [Baller_HUDView bhud_showWithTitle:[result valueForKey:@"msg"]];

        }];
    }
}

/*!
 *  @brief  点击用户头像的方法
*/
- (IBAction)userButtonAction:(id)sender {
    
    
}
@end
