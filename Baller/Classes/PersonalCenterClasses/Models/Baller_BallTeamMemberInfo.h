//
//  Baller_BallTeamMemberInfo.h
//  Baller
//
//  Created by Tongtong Xu on 15/3/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Baller_BallTeamMemberInfo : NSObject
@property (nonatomic, copy) NSString * favor_num;
@property (nonatomic, copy) NSString * weight;
@property (nonatomic, copy) NSString * birthday;
@property (nonatomic, copy) NSString * user_grade;
@property (nonatomic, copy) NSString * position;
@property (nonatomic, copy) NSString * devicetoken;
@property (nonatomic, copy) NSString * score;
@property (nonatomic, copy) NSString * admin_id;
@property (nonatomic, copy) NSString * friends_num;
@property (nonatomic, copy) NSString * thirdid;
@property (nonatomic, copy) NSString * court_id;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * third_photo;
@property (nonatomic, copy) NSString * job;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, copy) NSString * decription;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * dateline;
@property (nonatomic, copy) NSString * height;
@property (nonatomic, copy) NSString * fans_num;
@property (nonatomic, copy) NSString * recommend_uid;
@property (nonatomic, copy) NSString * age;
@property (nonatomic, copy) NSString * user_banner;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy) NSString * gold_coin;
@property (nonatomic, copy) NSString * msg_status;
@property (nonatomic, copy) NSString * attentions_num;
@property (nonatomic, copy) NSString * team_id;
@property (nonatomic, copy) NSString * user_name;

+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic;

@end
