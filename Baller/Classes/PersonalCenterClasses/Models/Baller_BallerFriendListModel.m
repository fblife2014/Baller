//
//  Baller_BallerFriendListModel.m
//  Baller
//
//  Created by malong on 15/3/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BallerFriendListModel.h"

@implementation Baller_BallerFriendListModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        self.court_id = $safe([attributes valueForKey:@"court_id"]);
        self.court_name = $safe([attributes valueForKey:@"court_name"]);
        self.dateline = (unsigned long long)[$safe([attributes valueForKey:@"dateline"]) longLongValue];
        self.flag = $safe([attributes valueForKey:@"flag"]);
        self.friend_dateline = $safe([attributes valueForKey:@"friend_dateline"]);
        self.friend_uid = $safe([attributes valueForKey:@"friend_uid"]);
        self.friend_user_name = $safe([attributes valueForKey:@"friend_user_name"]);
        self.friend_user_photo = $safe([attributes valueForKey:@"friend_user_photo"]);
        self.court_id = $safe([attributes valueForKey:@"g_id"]);
        self.a_id = $safe([attributes valueForKey:@"id"]);
        self.uid = $safe([attributes valueForKey:@"uid"]);
        self.position = $safe([attributes valueForKey:@"position"]);
    }
    return self;
}
@end
