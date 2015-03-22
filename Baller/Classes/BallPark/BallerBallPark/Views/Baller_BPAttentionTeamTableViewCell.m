//
//  Baller_BPAttentionTeamTableViewCell.m
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BPAttentionTeamTableViewCell.h"
#import "Baller_BallParkAttentionTeamListModel.h"

@implementation Baller_BPAttentionTeamTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTeamInfo:(Baller_BallParkAttentionTeamListModel *)teamInfo{
    if (_teamInfo == teamInfo) {
        return;
    }
    _teamInfo = teamInfo;
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:teamInfo.team_logo] placeholderImage:[UIImage imageNamed:@"ballPark_default"]];
    self.teamNameLabel.text = teamInfo.team_name;
    self.teamNumberLabel.text = [NSString stringWithFormat:@"%@人",teamInfo.member_num];
    [self setNeedsDisplay];
}

@end
