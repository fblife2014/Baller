//
//  Baller_MessageViewCellI.h
//  Baller
//
//  Created by malong on 15/1/22.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Baller_BaseTableViewCell.h"

@interface Baller_MessageViewCell : Baller_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageNumberLable;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageDetailLabel;



@end
