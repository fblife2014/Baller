//
//  Baller_SystemConfigureTableViewCell.m
//  Baller
//
//  Created by malong on 15/1/28.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_SystemConfigureTableViewCell.h"

@implementation Baller_SystemConfigureTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(68.0, 22.0, 200.0, 16.0);
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.font = SYSTEM_FONT_S(16.0);
}

@end

@implementation Baller_SystemConfigureTableViewCell_Message

- (IBAction)switchAction:(UISwitch *)sender {
    if (self.onMessageSwitch) {
        self.onMessageSwitch(sender);
    }
}

@end

@implementation Baller_SystemConfigureTableViewCell_ClearCache

@end