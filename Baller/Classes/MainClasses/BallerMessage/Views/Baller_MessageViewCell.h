//
//  Baller_MessageViewCellI.h
//  Baller
//
//  Created by malong on 15/1/22.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Baller_MessageListInfo;
@interface Baller_MessageViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageNumberLable;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageDetailLabel;
@property (nonatomic,strong)Baller_MessageListInfo * messageInfo;


@end
