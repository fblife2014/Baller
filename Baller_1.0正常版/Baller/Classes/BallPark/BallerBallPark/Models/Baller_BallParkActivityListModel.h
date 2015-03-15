//
//  Baller_BallParkActivityListModel.h
//  Baller
//
//  Created by malong on 15/1/24.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Baller_BallParkActivityListModel : NSObject

@property (nonatomic,copy)NSString * sponsorImageUrl;  //发起者头像地址
@property (nonatomic,copy)NSString * sponsorUsername;  //发起者用户名
@property (nonatomic)NSInteger  jionNumber; //参与人数
@property (nonatomic,copy)NSString * startTime; //开始时间
@property (nonatomic) BOOL hasJoined; //是否已加入活动

@end
