//
//  Baller_BallParkActivityListModel.m
//  Baller
//
//  Created by malong on 15/1/24.
//  Copyright (c) 2015年 malong. All rights reserved.
//
/*!
 *  @brief  球场活动列表模型
 */

#import "Baller_BallParkActivityListModel.h"

@implementation Baller_BallParkActivityListModel


- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        self.activity_id = $safe([attributes valueForKey:@"activity_id"]);
        self.court_id = $safe([attributes valueForKey:@"court_id"]);
        
        self.dateline = (unsigned long long)[$safe([attributes valueForKey:@"dateline"]) longLongValue];
        self.end_time = (unsigned long long)[$safe([attributes valueForKey:@"end_time"]) longLongValue];
        self.is_join = (BOOL)[$safe([attributes valueForKey:@"is_join"]) boolValue];
        
        self.join_num = (NSInteger)[$safe([attributes valueForKey:@"join_num"]) integerValue];
        self.max_num = (NSInteger)[$safe([attributes valueForKey:@"max_num"]) integerValue];
        
        self.start_time = (unsigned long long)[$safe([attributes valueForKey:@"start_time"]) longLongValue];
        self.status = (NSInteger)[$safe([attributes valueForKey:@"status"]) integerValue];
        self.activity_title = $safe([attributes valueForKey:@"title"]);
        self.activity_info = $safe([attributes valueForKey:@"info"]);

        self.uid = $safe([attributes valueForKey:@"uid"]);
        
        self.user_photo = $safe([attributes valueForKey:@"user_photo"]);
        self.user_name = $safe([attributes valueForKey:@"user_name"]);
 
    }
    return self;
}

@end
