//
//  Baller_MyCourtInfo.m
//  Baller
//
//  Created by malong on 15/4/5.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyCourtInfo.h"

@implementation Baller_MyCourtInfo

+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic
{
    if (!dic) {
        return nil;
    }
    
    Baller_MyCourtInfo *info = [[Baller_MyCourtInfo alloc] init];
    info.address = [dic stringForKey:@"address"];
    info.attend_court = [dic boolForKey:@"attend_court"];
    info.auth_num = [dic stringForKey:@"auth_num"];
    info.chatroom_id = [dic stringForKey:@"chatroom_id"];
    info.chatroom_name = [dic stringForKey:@"chatroom_name"];
    info.check_time = [dic longLongIntForKey:@"check_time"];
    info.city = [dic stringForKey:@"city"];
    info.city_id = [dic stringForKey:@"city_id"];
    info.court_id = [dic stringForKey:@"court_id"];
    info.court_img = [dic stringForKey:@"court_img"];
    info.court_name = [dic stringForKey:@"court_name"];
    info.create_court = [dic boolForKey:@"create_court"];
    info.create_time = [dic longLongIntForKey:@"create_time"];
    info.disctrict_id = [dic stringForKey:@"disctrict_id"];
    info.home_court = [dic boolForKey:@"home_court"];
    info.img_height = [dic floatForKey:@"img_height"];
    info.img_size = [dic stringForKey:@"img_size"];
    info.img_width = [dic floatForKey:@"img_width"];
    info.latitude = [dic doubleForKey:@"latitude"];
    info.longitude = [dic doubleForKey:@"longitude"];
    info.pro_id = [dic stringForKey:@"pro_id"];
    info.status = [dic stringForKey:@"status"];
    info.tag = [dic stringForKey:@"tag"];
    return info;
}


@end
