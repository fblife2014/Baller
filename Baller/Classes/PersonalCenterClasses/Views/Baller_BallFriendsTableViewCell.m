//
//  Baller_BallFriendsTableViewCell.m
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BallFriendsTableViewCell.h"
#import "Baller_BallerFriendListModel.h"
#import "Baller_BallTeamMemberInfo.h"

@implementation Baller_BallFriendsTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imageView.layer.cornerRadius = 4.0;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.image = [UIImage imageNamed:@"manHead"];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderColor = BALLER_CORLOR_b2b2b2.CGColor;
    self.textLabel.backgroundColor = CLEARCOLOR;
    self.textLabel.textColor = BALLER_CORLOR_5c5c5c;
    self.textLabel.font = SYSTEM_FONT_S(13.0);
    self.textLabel.text = @"Baller";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        
    }else{
        
    }

}

- (void)setFriendListModel:(Baller_BallerFriendListModel *)friendListModel{
    if (_friendListModel == friendListModel) {
        return;
    }
    
    _friendListModel = friendListModel;
    //球场图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:friendListModel.friend_user_photo] placeholderImage:[UIImage imageNamed:@"ballPark_default"]];
    //球场名字
    self.BallParkName.text = friendListModel.court_name;
    //好友名字
    self.textLabel.text = friendListModel.friend_user_name;
    //位置
    self.positionLabel.text = friendListModel.position;
    [self setNeedsDisplay];
}

- (void)setUserInfoModel:(Baller_BallTeamMemberInfo *)userInfoModel{
    if (_userInfoModel == userInfoModel) {
        return;
    }
    _userInfoModel = userInfoModel;
    
    //球场图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:userInfoModel.photo] placeholderImage:[UIImage imageNamed:@"ballPark_default"]];
    //球场名字
    self.BallParkName.text = nil;
    //好友名字
    self.textLabel.text = userInfoModel.user_name;
    //位置
    self.positionLabel.text = userInfoModel.position;
    [self setNeedsDisplay];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_invitateStatus) {
        _circleView.frame = CGRectMake(NUMBER(20.0, 18.0, 15.0, 15.0), 22, 16.0, 16.0);
        self.imageView.frame = CGRectMake(43.0, 9.5, 41, 41);

    }else{
        _circleView.frame = CGRectMake(NUMBER(15.0, 13.0, 10.0, 10.0), 22, 16.0, 16.0);
        self.imageView.frame = CGRectMake(33.0, 9.5, 41, 41);

    }
    
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+10.0, CGRectGetMinY(self.imageView.frame)+3, 120, 13.0);
    self.BallParkName.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+10.0, CGRectGetMaxY(self.imageView.frame)-16, ScreenWidth-60-CGRectGetMaxX(self.imageView.frame), 13.0);
}

- (CircleView *)circleView
{
    if (!_circleView) {
        _circleView = [[CircleView alloc]initWithFrame:CGRectMake(NUMBER(15.0, 13.0, 10.0, 10.0), 22, 16.0, 16.0)];
        [self.contentView addSubview:_circleView];

    }
    return _circleView;
}

- (void)setInvitateStatus:(BOOL)invitateStatus{
    if (_invitateStatus == invitateStatus) {
        return;
    }
    _invitateStatus = invitateStatus;

}

- (void)setChosing:(BOOL)chosing{
    _chosing = chosing;
    [self circleView].grayLayer.hidden = !chosing;
}


@end


@implementation CircleView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = frame.size.width/2.0;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = UIColorFromRGB(0x9f9f9f).CGColor;
        
        self.grayLayer = [CALayer layer];
        _grayLayer.frame = CGRectMake(frame.size.width/4.0, frame.size.height/4.0, frame.size.width/2.0,frame.size.height/2.0);
        _grayLayer.cornerRadius = frame.size.width/4.0;
        _grayLayer.backgroundColor = UIColorFromRGB(0x535353).CGColor;
        _grayLayer.hidden = YES;
        [self.layer addSublayer:_grayLayer];
    }
    return self;
}

@end
