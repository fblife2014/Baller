//
//  Baller_MyCourtInfo.h
//  Baller
//
//  Created by malong on 15/4/5.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Baller_MyCourtInfo : NSObject

@property (nonatomic, copy) NSString * address;
@property (nonatomic) BOOL  attend_court;
@property (nonatomic, copy) NSString * auth_num;
@property (nonatomic, copy) NSString * chatroom_id;
@property (nonatomic, copy) NSString * chatroom_name;
@property (nonatomic) UInt64 check_time;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * city_id;
@property (nonatomic, copy) NSString * court_id;
@property (nonatomic, copy) NSString * court_img;
@property (nonatomic, copy) NSString * court_name;
@property (nonatomic) BOOL  create_court;
@property (nonatomic) UInt64 create_time;
@property (nonatomic, copy) NSString * disctrict_id;
@property (nonatomic) BOOL  home_court;
@property (nonatomic) CGFloat img_height;
@property (nonatomic, copy) NSString * img_size;
@property (nonatomic) CGFloat img_width;
@property (nonatomic) double  latitude;
@property (nonatomic) double  longitude;
@property (nonatomic, copy) NSString * pro_id;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * tag;

+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic;

@end
