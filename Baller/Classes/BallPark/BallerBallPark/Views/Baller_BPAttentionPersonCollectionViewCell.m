//
//  Baller_BPAttentionPersonCollectionViewCell.m
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BPAttentionPersonCollectionViewCell.h"
#import "Baller_PositionRelated.h"
#import "Baller_BallParkAttentionBallerListModel.h"
#import "Baller_WaitingEvaluateBallerInfo.h"


@implementation Baller_BPAttentionPersonCollectionViewCell

- (void)awakeFromNib {
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.clipsToBounds = YES;
    // Initialization code
}

- (void)setBallerModel:(Baller_BallParkAttentionBallerListModel *)ballerModel{
    if (_ballerModel == ballerModel) {
        return;
    }
    _ballerModel = ballerModel;
    _positionLabel.text = ballerModel.position;
    if ([ballerModel.position isEqualToString:@"C"]) {
        self.contentView.backgroundColor = [Baller_PositionRelated  baller_PositionColorWithType:PositionType_C];

    }else if ([ballerModel.position isEqualToString:@"SF"]) {
        self.contentView.backgroundColor = [Baller_PositionRelated  baller_PositionColorWithType:PositionType_SF];

    }else if ([ballerModel.position isEqualToString:@"SG"]) {
        self.contentView.backgroundColor = [Baller_PositionRelated  baller_PositionColorWithType:PositionType_SG];

    }else if ([ballerModel.position isEqualToString:@"PF"]) {
        self.contentView.backgroundColor = [Baller_PositionRelated  baller_PositionColorWithType:PositionType_PF];

    }else if ([ballerModel.position isEqualToString:@"PG"]) {
        self.contentView.backgroundColor = [Baller_PositionRelated  baller_PositionColorWithType:PositionType_PG];
    }
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:ballerModel.photo] placeholderImage:[UIImage imageNamed:@"manHead"]];
    _userNameLabel.text = ballerModel.user_name;
    [self setNeedsDisplay];
}

- (void)setWaitingEvaluateBallerInfo:(Baller_WaitingEvaluateBallerInfo *)waitingEvaluateBallerInfo{
    if (_waitingEvaluateBallerInfo == waitingEvaluateBallerInfo) {
        return;
    }
    _waitingEvaluateBallerInfo = waitingEvaluateBallerInfo;
    _positionLabel.text = waitingEvaluateBallerInfo.position;
    if ([waitingEvaluateBallerInfo.position isEqualToString:@"C"]) {
        self.contentView.backgroundColor = [Baller_PositionRelated  baller_PositionColorWithType:PositionType_C];
        
    }else if ([waitingEvaluateBallerInfo.position isEqualToString:@"SF"]) {
        self.contentView.backgroundColor = [Baller_PositionRelated  baller_PositionColorWithType:PositionType_SF];
        
    }else if ([waitingEvaluateBallerInfo.position isEqualToString:@"SG"]) {
        self.contentView.backgroundColor = [Baller_PositionRelated  baller_PositionColorWithType:PositionType_SG];
        
    }else if ([waitingEvaluateBallerInfo.position isEqualToString:@"PF"]) {
        self.contentView.backgroundColor = [Baller_PositionRelated  baller_PositionColorWithType:PositionType_PF];
        
    }else if ([waitingEvaluateBallerInfo.position isEqualToString:@"PG"]) {
        self.contentView.backgroundColor = [Baller_PositionRelated  baller_PositionColorWithType:PositionType_PG];
    }
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:waitingEvaluateBallerInfo.photo] placeholderImage:[UIImage imageNamed:@"manHead"]];
    _userNameLabel.text = waitingEvaluateBallerInfo.user_name;
    [self setNeedsDisplay];
}

@end
