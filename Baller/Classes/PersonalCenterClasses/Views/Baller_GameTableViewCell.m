//
//  Baller_GameTableViewCell.m
//  Baller
//
//  Created by malong on 15/1/25.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_GameTableViewCell.h"

@implementation Baller_GameTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CALayer * circle = [CALayer layer];
        circle.frame = CGRectMake(18.0, PersonInfoCell_Height/2.0-5.5, 11.0, 11.0);
        circle.cornerRadius = 5.5;
        circle.backgroundColor = BALLER_CORLOR_696969.CGColor;
        [self.layer addSublayer:circle];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(63.0, PersonInfoCell_Height/2.0-NUMBER(17.0, 16.0, 15.0, 15.0)/2.0, 200, NUMBER(17.0, 16.0, 15.0, 15.0));


}

@end
