//
//  Baller_BallParkAttentionBallerListModel.m
//  Baller
//
//  Created by malong on 15/3/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BallParkAttentionBallerListModel.h"

@implementation Baller_BallParkAttentionBallerListModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        self.check_dateline = (unsigned long long)[$safe([attributes valueForKey:@"check_dateline"]) longLongValue];
        self.dateline = (unsigned long long)[$safe([attributes valueForKey:@"dateline"]) longLongValue];
        self.status = (NSInteger)[$safe([attributes valueForKey:@"status"]) integerValue];
        self.check_uid = $safe([attributes valueForKey:@"check_uid"]);
        self.photo = $safe([attributes valueForKey:@"photo"]);
        self.position = $safe([attributes valueForKey:@"position"]);
        
        self.team_id = $safe([attributes valueForKey:@"team_id"]);
        self.tm_id = $safe([attributes valueForKey:@"tm_id"]);
        self.uid = $safe([attributes valueForKey:@"uid"]);
        self.user_name = $safe([attributes valueForKey:@"user_name"]);
        
    }
    return self;
}


@end
