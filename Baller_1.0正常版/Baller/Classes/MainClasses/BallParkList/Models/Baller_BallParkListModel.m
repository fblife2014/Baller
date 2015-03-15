//
//  Baller_BallParkListModel.m
//  Baller
//
//  Created by malong on 15/1/20.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_BallParkListModel.h"
@interface Baller_BallParkListModel()

@property (nonatomic,readwrite,copy)NSString * address;
@property (nonatomic,readwrite)NSInteger auth_num;
@property (nonatomic,readwrite)NSInteger check_time;
@property (nonatomic,readwrite)NSInteger city_id;
@property (nonatomic,readwrite)NSInteger court_id;
@property (nonatomic,readwrite,copy)NSString * court_img;
@property (nonatomic,readwrite,copy)NSString * court_name;
@property (nonatomic,readwrite,copy)NSString * create_time;
@property (nonatomic,readwrite)NSInteger disctrict_id;
@property (nonatomic,readwrite)NSInteger distance;
@property (nonatomic,readwrite)CGFloat img_height;
@property (nonatomic,readwrite)CGFloat img_width;
@property (nonatomic,readwrite,copy)NSString * img_size;
@property (nonatomic,readwrite,copy)NSString * latitude;
@property (nonatomic,readwrite,copy)NSString * longitude;
@property (nonatomic,readwrite)NSInteger pro_id;
@property (nonatomic,readwrite)NSInteger status;
@property (nonatomic,readwrite)NSInteger uid;

@end

@implementation Baller_BallParkListModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        self.address = $safe([attributes valueForKey:@"address"]);
        self.auth_num = (NSInteger)[$safe([attributes valueForKey:@"auth_num"]) integerValue];
        self.check_time = (NSInteger)[$safe([attributes valueForKey:@"check_time"]) integerValue];
        self.city_id = (NSInteger)[$safe([attributes valueForKey:@"city_id"]) integerValue];
        self.court_id = (NSInteger)[$safe([attributes valueForKey:@"court_id"]) integerValue];
        self.disctrict_id = (NSInteger)[$safe([attributes valueForKey:@"disctrict_id"]) integerValue];
        self.distance = (NSInteger)[$safe([attributes valueForKey:@"distance"]) integerValue];
        self.img_height = (CGFloat)[$safe([attributes valueForKey:@"img_height"]) floatValue];
        self.img_width = (CGFloat)[$safe([attributes valueForKey:@"img_width"]) floatValue];
        self.pro_id = (NSInteger)[$safe([attributes valueForKey:@"pro_id"]) integerValue];
        self.status = (NSInteger)[$safe([attributes valueForKey:@"status"]) integerValue];
        self.uid = (NSInteger)[$safe([attributes valueForKey:@"uid"]) integerValue];


        self.court_img = $safe([attributes valueForKey:@"court_img"]);
        self.court_name = $safe([attributes valueForKey:@"court_name"]);
        self.create_time = $safe([attributes valueForKey:@"create_time"]);
        
        self.img_size = $safe([attributes valueForKey:@"img_size"]);
        self.latitude = $safe([attributes valueForKey:@"latitude"]);
        self.longitude = $safe([attributes valueForKey:@"longitude"]);
    }
    return self;
}
@end
