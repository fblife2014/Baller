//
//  Baller_BallParkHomepageViewController.h
//  Baller
//
//  Created by malong on 15/1/23.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "BaseTableViewController.h"
@class Baller_BallParkListModel;
@interface Baller_BallParkHomepageViewController : BaseTableViewController

@property (nonatomic,strong)Baller_BallParkListModel * ballParkModel;

@end



#pragma mark 认证按钮
@interface AuthenticationView : UIView

@property (nonatomic,strong)UIButton * authenButton; //认证按钮

@property (nonatomic,strong)UILabel * identifyLabel; //是否已认证标签

@property (nonatomic,strong)UILabel * detailLabel; //详情标签

@property (nonatomic)BOOL hasIdentified; //是否已经认证
@property (nonatomic,copy)NSString * court_id; 
@property (nonatomic)NSInteger auth_num; //认证人数
@end