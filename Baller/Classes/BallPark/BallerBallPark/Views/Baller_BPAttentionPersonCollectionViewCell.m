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


@implementation Baller_BPAttentionPersonCollectionViewCell

- (void)awakeFromNib {
    
    self.contentView.backgroundColor = [Baller_PositionRelated  baller_PositionColorWithType:PositionType_SF];
    // Initialization code
}

- (void)setBallerModel:(Baller_BallParkAttentionBallerListModel *)ballerModel{
    if (_ballerModel == ballerModel) {
        return;
    }
    _ballerModel = ballerModel;
    _positionLabel.text = ballerModel.position;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:ballerModel.photo] placeholderImage:[UIImage imageNamed:@"ballPark_default"]];
    _userNameLabel.text = ballerModel.user_name;
    [self setNeedsDisplay];
}

@end
