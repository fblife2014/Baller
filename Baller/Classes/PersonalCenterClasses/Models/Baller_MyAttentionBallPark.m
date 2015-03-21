//
//  Baller_MyAttentionBallPark.m
//  Baller
//
//  Created by unisedu on 15/3/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyAttentionBallPark.h"

@implementation Baller_MyAttentionBallPark
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        self.attend_time = $safe([attributes valueForKey:@"attend_time"]);
        self.court_id = (NSInteger)[$safe([attributes valueForKey:@"court_id"]) integerValue];
        self.court_img = $safe([attributes valueForKey:@"court_img"]);
        self.court_name = $safe([attributes valueForKey:@"court_name"]);
        self.a_id       = (NSInteger)[$safe([attributes valueForKey:@"id"]) integerValue];
        self.img_height       = (CGFloat)[$safe([attributes valueForKey:@"img_height"]) floatValue];
        self.img_width       = (CGFloat)[$safe([attributes valueForKey:@"img_width"]) floatValue];
        self.uid = (NSInteger)[$safe([attributes valueForKey:@"uid"]) integerValue];
        self.my_home_court =  $safe([attributes valueForKey:@"my_home_court"]);
        
    }
    return self;
}
@end