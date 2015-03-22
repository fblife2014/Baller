//
//  Baller_MyBasketballTeamTableViewHeaderView.h
//  Baller
//
//  Created by Tongtong Xu on 15/3/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTLabel.h"

@interface Baller_MyBasketballTeamTableViewHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *memberCountView;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *memberCount;

@property (weak, nonatomic) IBOutlet BTLabel *captainName;

@property (weak, nonatomic) IBOutlet BTLabel *courtName;

@end
