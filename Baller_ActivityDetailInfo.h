//
//  Baller_ActivityDetailInfo.h
//  Baller
//
//  Created by malong on 15/3/30.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Baller_ActivityDetailInfo : NSObject

@property (nonatomic, copy) NSString * activity_id;
@property (nonatomic, copy) NSString * court_id;
@property (nonatomic, copy) NSString * create_user_name;
@property (nonatomic, copy) NSString * create_user_photo;
@property (nonatomic, copy) NSString * info;
@property (nonatomic, copy) NSString * join_num;
@property (nonatomic) unsigned long long start_time;
@property (nonatomic) unsigned long long dateline;
@property (nonatomic) unsigned long long end_time;
@property (nonatomic) BOOL my_favo;
@property (nonatomic) BOOL my_join;
@property (nonatomic) NSInteger status;
@property (nonatomic, copy) NSString * max_num;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * uid;


+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic;

@end
