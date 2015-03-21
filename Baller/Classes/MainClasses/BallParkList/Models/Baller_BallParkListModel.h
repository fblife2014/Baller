//
//  Baller_BallParkListModel.h
//  Baller
//
//  Created by malong on 15/1/20.
//  Copyright (c) 2015年 malong. All rights reserved.
//

//认证通过了的球场信息
#import <Foundation/Foundation.h>

@interface Baller_BallParkListModel : NSObject

@property (nonatomic,readonly,copy)NSString * address;
@property (nonatomic,readonly)NSInteger auth_num;
@property (nonatomic,readonly)NSInteger check_time;
@property (nonatomic,readonly)NSInteger city_id;
@property (nonatomic,readonly)NSInteger court_id;
@property (nonatomic,readonly,copy)NSString * court_img;
@property (nonatomic,readonly,copy)NSString * court_name;
@property (nonatomic,readonly,copy)NSString * create_time;
@property (nonatomic,readonly)NSInteger disctrict_id;
@property (nonatomic,readonly)NSInteger distance;
@property (nonatomic,readonly)CGFloat img_height;
@property (nonatomic,readonly)CGFloat img_width;
@property (nonatomic,readonly,copy)NSString * img_size;
@property (nonatomic,readonly,copy)NSString * latitude;
@property (nonatomic,readonly,copy)NSString * longitude;
@property (nonatomic,readonly)NSInteger pro_id;
@property (nonatomic,readonly)NSInteger status;
@property (nonatomic,readonly)NSInteger uid;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
