//
//  Baller_ActivityDetailViewController.h
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "BaseViewController.h"

@class Baller_BallParkActivityListModel;
@class Baller_BallParkHomepageViewController;

@interface Baller_ActivityDetailViewController : BaseViewController

@property (nonatomic,weak) Baller_BallParkHomepageViewController * ballParkVC;
@property (nonatomic,strong)Baller_BallParkActivityListModel * activityModel;
@property (nonatomic,copy)NSString * activityID;
@property (nonatomic,copy)NSString * activity_CreaterID;


@end
