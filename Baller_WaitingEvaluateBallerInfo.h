//
//  Baller_WaitingEvaluateBallerInfo.h
//  Baller
//
//  Created by malong on 15/4/4.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Baller_WaitingEvaluateBallerInfo : NSObject
@property (nonatomic, copy) NSString * activity_id;
@property (nonatomic, copy) NSString * aj_id;
@property (nonatomic, copy) NSString * marked_num;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * user_name;
@property (nonatomic, copy) NSString * position;
@property (nonatomic) unsigned long long dateline;

+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic;

@end
