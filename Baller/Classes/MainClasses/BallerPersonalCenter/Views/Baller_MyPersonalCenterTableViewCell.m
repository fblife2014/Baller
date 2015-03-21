//
//  Baller_MyPersonalCenterTableViewCell.m
//  Baller
//
//  Created by malong on 15/1/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyPersonalCenterTableViewCell.h"

@implementation Baller_MyPersonalCenterTableViewCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.font = SYSTEM_FONT_S(16.0);
    self.detailTextLabel.font = SYSTEM_FONT_S(10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
