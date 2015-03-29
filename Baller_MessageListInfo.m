//
//  Baller_MessageListInfo.m
//  Baller
//
//  Created by malong on 15/3/29.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MessageListInfo.h"

@implementation Baller_MessageListInfo
+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    Baller_MessageListInfo *info = [[Baller_MessageListInfo alloc] init];
    info.content = [dic stringForKey:@"content"];
    info.from_uid = [dic stringForKey:@"from_uid"];
    info.from_username = [dic stringForKey:@"from_username"];
    info.is_read = [dic boolForKey:@"is_read"];
    info.msg_id = [dic stringForKey:@"msg_id"];
    info.photo = [dic stringForKey:@"photo"];
    info.pic = [dic stringForKey:@"pic"];
    info.send_time = [[TimeManager getDateStringOfTimeInterval:(unsigned long long)[[dic valueForKey:@"send_time"] integerValue]] substringToIndex:10];
    info.status = [dic stringForKey:@"status"];
    info.theme_id = [dic stringForKey:@"theme_id"];
    info.title = [dic stringForKey:@"title"];
    info.to_uid = [dic stringForKey:@"to_uid"];
    info.type = [dic integerForKey:@"type"];
    return info;
}
@end
