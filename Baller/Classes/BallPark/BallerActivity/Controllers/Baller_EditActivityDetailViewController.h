//
//  Baller_EditActivityDetailViewController.h
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "BaseViewController.h"
@class Baller_BallParkHomepageViewController;
@interface Baller_EditActivityDetailViewController : BaseViewController

@property (nonatomic,weak) Baller_BallParkHomepageViewController * ballParkVC;
@property (nonatomic,copy)NSString * court_id;

@end
