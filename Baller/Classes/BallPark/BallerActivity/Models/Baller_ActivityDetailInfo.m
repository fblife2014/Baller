//
//  Baller_ActivityDetailInfo.m
//  Baller
//
//  Created by malong on 15/3/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_ActivityDetailInfo.h"

@implementation Baller_ActivityDetailInfo

+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    Baller_ActivityDetailInfo *info = [[Baller_ActivityDetailInfo alloc] init];
    info.activity_id = [dic stringForKey:@"activity_id"];
    info.court_id = [dic stringForKey:@"court_id"];
    info.chatroom_id = [dic stringForKey:@"chatroom_id"];
    info.chatroom_name = [dic stringForKey:@"chatroom_name"];
    info.create_user_name = [dic stringForKey:@"create_user_name"];
    info.my_favo = [dic boolForKey:@"my_favo"];
    info.my_join = [dic boolForKey:@"my_join"];
    info.create_user_photo = [dic stringForKey:@"create_user_photo"];
    info.info = [dic stringForKey:@"info"];
    info.join_num = [dic stringForKey:@"join_num"];
    info.start_time = [dic longLongIntForKey:@"start_time"];
    info.dateline = [dic longLongIntForKey:@"dateline"];
    info.end_time = [dic longLongIntForKey:@"end_time"];



    info.status = [dic integerForKey:@"status"];
    info.max_num = [dic stringForKey:@"max_num"];
    info.title = [dic stringForKey:@"title"];
    info.uid = [dic stringForKey:@"uid"];
    return info;
}

@end
