//
//  Baller_BallParkActivityListModel.h
//  Baller
//
//  Created by malong on 15/1/24.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Baller_BallParkActivityListModel : NSObject

@property (nonatomic,copy)NSString * activity_title;//活动主题
@property (nonatomic,copy)NSString * activity_info; //活动备注

@property (nonatomic,copy)NSString * activity_id;  //活动id
@property (nonatomic,copy)NSString * court_id;     //活动所属球场id
@property (nonatomic)unsigned long long  dateline;     //
@property (nonatomic)unsigned long long  end_time;     //活动结束时间
@property (nonatomic)unsigned long long  start_time;   //开始时间

@property (nonatomic,copy)NSString * user_name;  //发起者用户名
@property (nonatomic,copy)NSString * uid;  //活动发起者id
@property (nonatomic,copy)NSString * user_photo;  //活动发起者头像

@property (nonatomic)NSInteger  join_num; //参与人数
@property (nonatomic)NSInteger  max_num;  //参与人数上限
@property (nonatomic)NSInteger  status;   //活动状态

@property (nonatomic) BOOL is_join;    //是否已加入活动

- (instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
