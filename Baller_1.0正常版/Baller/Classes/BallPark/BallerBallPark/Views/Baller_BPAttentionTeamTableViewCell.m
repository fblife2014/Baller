//
//  Baller_BPAttentionTeamTableViewCell.m
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BPAttentionTeamTableViewCell.h"
#import "Baller_BallTeamInfo.h"

@implementation Baller_BPAttentionTeamTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTeamInfo:(Baller_BallTeamInfo *)teamInfo{
    if (_teamInfo == teamInfo) {
        return;
    }
    _teamInfo = teamInfo;
    self.logoImageView.image = [UIImage imageNamed:@"ballPark_default"];
    self.teamNameLabel.text = teamInfo.teamName;
    self.teamNumberLabel.text = [NSString stringWithFormat:@"%ld人",teamInfo.teamNumber];
    
}

@end
