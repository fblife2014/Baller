//
//  Baller_BallTeamInfo.m
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BallTeamInfo.h"
#import "Baller_BallTeamMemberInfo.h"

@implementation Baller_BallTeamInfo

+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic
{
    Baller_BallTeamInfo *info = [[Baller_BallTeamInfo alloc] init];
    info.createTime = [dic stringForKey:@"create_time"];
    info.status = [dic stringForKey:@"status"];
    info.courtID = [dic integerForKey:@"court_id"];
    info.teamLeaderUserName = [dic stringForKey:@"team_leader_user_name"];
    info.logoImageUrl = [dic stringForKey:@"team_logo"];
    info.teamName = [dic stringForKey:@"team_name"];
    info.logoSize = [dic stringForKey:@"logo_size"];
    info.createUserID = [dic integerForKey:@"create_uid"];
    info.logoHeight = [dic integerForKey:@"logo_height"];
    info.logoWidth = [dic integerForKey:@"logo_width"];
    info.teamID = [dic integerForKey:@"team_id"];
    info.teamLeaderUserID = [dic integerForKey:@"team_leader_uid"];
    info.court_name = [dic stringForKey:@"court_name"];
    NSMutableArray *temp = @[].mutableCopy;
    NSArray *members = [dic arrayForKey:@"members"];
    for (NSDictionary *member in members) {
        Baller_BallTeamMemberInfo *memberInfo = [Baller_BallTeamMemberInfo shareWithServerDictionary:member];
        [temp addObject:memberInfo];
    }
    info.members = [NSArray arrayWithArray:temp];
    return info;
}

- (NSInteger)memberNumber
{
    return self.members.count;
}

@end
