//
//  Baller_MessageViewCellI.m
//  Baller
//
//  Created by malong on 15/1/22.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MessageViewCell.h"

@implementation Baller_MessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.messageNumberLable.layer.cornerRadius = self.messageNumberLable.frame.size.width/2.0;
    self.messageNumberLable.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
