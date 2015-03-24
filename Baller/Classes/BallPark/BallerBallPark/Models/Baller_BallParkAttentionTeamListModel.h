//
//  Baller_BallParkAttentionTeamListModel.h
//  Baller
//
//  Created by malong on 15/3/22.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Baller_BallParkAttentionTeamListModel : NSObject

@property (nonatomic, copy) NSString * court_id;
@property (nonatomic, copy) NSString * court_name;
@property (nonatomic, copy) NSString * create_time;
@property (nonatomic, copy) NSString * create_uid;
@property (nonatomic, copy) NSString * logo_size;
@property (nonatomic, copy) NSString * member_num;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * team_id;
@property (nonatomic, copy) NSString * team_leader_uid;
@property (nonatomic, copy) NSString * team_logo;
@property (nonatomic, copy) NSString * team_name;

+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic;

@end
