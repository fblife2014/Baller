//
//  Baller_SystemConfigureTableViewCell.h
//  Baller
//
//  Created by malong on 15/1/28.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Baller_SystemConfigureTableViewCell : UITableViewCell
@end

@interface Baller_SystemConfigureTableViewCell_Message : Baller_SystemConfigureTableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *messageSwitch;
@property (nonatomic, copy) void (^onMessageSwitch)(UISwitch *messageSwitch);
@end

@interface Baller_SystemConfigureTableViewCell_ClearCache : Baller_SystemConfigureTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;
@end
