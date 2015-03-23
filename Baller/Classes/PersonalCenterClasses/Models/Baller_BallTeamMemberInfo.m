//
//  Baller_BallTeamMemberInfo.m
//  Baller
//
//  Created by Tongtong Xu on 15/3/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BallTeamMemberInfo.h"

@implementation Baller_BallTeamMemberInfo

+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    Baller_BallTeamMemberInfo *info = [[Baller_BallTeamMemberInfo alloc] init];
    info.favor_num = [dic stringForKey:@"favor_num"];
    info.weight = [dic stringForKey:@"weight"];
    info.birthday = [dic stringForKey:@"birthday"];
    info.user_grade = [dic stringForKey:@"user_grade"];
    info.position = [dic stringForKey:@"position"];
    info.devicetoken = [dic stringForKey:@"devicetoken"];
    info.score = [dic stringForKey:@"score"];
    info.admin_id = [dic stringForKey:@"admin_id"];
    info.friends_num = [dic stringForKey:@"friends_num"];
    info.thirdid = [dic stringForKey:@"thirdid"];
    info.court_id = [dic stringForKey:@"court_id"];
    info.type = [dic stringForKey:@"type"];
    info.state = [dic stringForKey:@"state"];
    info.third_photo = [dic stringForKey:@"third_photo"];
    info.job = [dic stringForKey:@"job"];
    info.gender = [dic stringForKey:@"gender"];
    info.decription = [dic stringForKey:@"decription"];
    info.uid = [dic stringForKey:@"uid"];
    info.email = [dic stringForKey:@"email"];
    info.mobile = [dic stringForKey:@"mobile"];
    info.dateline = [dic stringForKey:@"dateline"];
    info.height = [dic stringForKey:@"height"];
    info.fans_num = [dic stringForKey:@"fans_num"];
    info.recommend_uid = [dic stringForKey:@"recommend_uid"];
    info.age = [dic stringForKey:@"age"];
    info.user_banner = [dic stringForKey:@"user_banner"];
    info.photo = [dic stringForKey:@"photo"];
    info.gold_coin = [dic stringForKey:@"gold_coin"];
    info.msg_status = [dic stringForKey:@"msg_status"];
    info.attentions_num = [dic stringForKey:@"attentions_num"];
    info.team_id = [dic stringForKey:@"team_id"];
    info.user_name = [dic stringForKey:@"user_name"];
    return info;
}

@end
