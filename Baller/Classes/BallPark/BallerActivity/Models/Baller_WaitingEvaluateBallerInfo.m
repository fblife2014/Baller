//
//  Baller_WaitingEvaluateBallerInfo.m
//  Baller
//
//  Created by malong on 15/4/4.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_WaitingEvaluateBallerInfo.h"

@implementation Baller_WaitingEvaluateBallerInfo
+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    Baller_WaitingEvaluateBallerInfo *info = [[Baller_WaitingEvaluateBallerInfo alloc] init];
    info.activity_id = [dic stringForKey:@"activity_id"];
    info.aj_id = [dic stringForKey:@"aj_id"];
    info.marked_num = [dic stringForKey:@"marked_num"];
    info.photo = [dic stringForKey:@"photo"];
    info.position = [dic stringForKey:@"position"];
    info.status = [dic stringForKey:@"status"];
    info.dateline = [dic longLongIntForKey:@"dateline"];
    info.user_name = [dic stringForKey:@"user_name"];
    info.uid = [dic stringForKey:@"uid"];
    return info;
}
@end
