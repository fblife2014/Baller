//
//  Baller_PlayerCardViewController.h
//  Baller
//
//  Created by malong on 15/1/17.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "BaseViewController.h"
#import "Baller_CardView.h"

@class Baller_BallerFriendListModel;
@interface Baller_PlayerCardViewController : BaseViewController
@property (nonatomic,strong)Baller_CardView * playCardView;;
@property (nonatomic) BallerCardType ballerCardType;
@property (nonatomic,strong)Baller_BallerFriendListModel * friendModel;
@property (nonatomic,copy)NSString * uid; //用户id
@property (nonatomic,copy)NSString * userName; //用户名
@property (nonatomic,copy)NSString * photoUrl;
@property (nonatomic,copy)NSString * activity_id;
@end
