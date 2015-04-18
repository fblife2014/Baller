//
//  Baller_MessageViewCellI.m
//  Baller
//
//  Created by malong on 15/1/22.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MessageViewCell.h"
#import "Baller_MessageListInfo.h"

@implementation Baller_MessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.messageNumberLable.layer.cornerRadius = self.messageNumberLable.frame.size.width/2.0;
    self.headImageView.layer.cornerRadius = 4;
    self.headImageView.layer.masksToBounds = YES;
    self.messageNumberLable.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageInfo:(Baller_MessageListInfo *)messageInfo{

    _messageInfo = messageInfo;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_messageInfo.photo] placeholderImage:[UIImage imageNamed:@"manHead"]];
    self.messageTitleLabel.text = _messageInfo.from_username;
    self.messageDetailLabel.text = _messageInfo.content;
    self.messageNumberLable.hidden = _messageInfo.is_read;
    self.timeLabel.text = _messageInfo.send_time;
}

@end
