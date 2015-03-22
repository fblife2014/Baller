//
//  Baller_BallParkAttentionTeamListModel.m
//  Baller
//
//  Created by malong on 15/3/22.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BallParkAttentionTeamListModel.h"

@implementation Baller_BallParkAttentionTeamListModel

+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic
{
    Baller_BallParkAttentionTeamListModel *info = [[Baller_BallParkAttentionTeamListModel alloc] init];
    info.court_id = [dic stringForKey:@"court_id"];
    info.create_time = [dic stringForKey:@"create_uid"];
    info.create_uid = [dic stringForKey:@"birthday"];
    info.logo_size = [dic stringForKey:@"logo_size"];
    info.member_num = [dic stringForKey:@"member_num"];
    info.status = [dic stringForKey:@"status"];
    info.team_id = [dic stringForKey:@"team_id"];
    info.team_leader_uid = [dic stringForKey:@"team_leader_uid"];
    info.team_logo = [dic stringForKey:@"team_logo"];
    info.team_name = [dic stringForKey:@"team_name"];
    info.court_id = [dic stringForKey:@"court_id"];
    return info;
}
@end
