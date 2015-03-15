//
//  Baller_SystemConfigureTableViewCell.m
//  Baller
//
//  Created by malong on 15/1/28.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_SystemConfigureTableViewCell.h"

@implementation Baller_SystemConfigureTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(68.0, 22.0, 200.0, 16.0);
    self.textLabel.font = SYSTEM_FONT_S(16.0);
}

@end
