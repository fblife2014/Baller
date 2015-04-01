//
//  Baller_MyAttentionBallPark.h
//  Baller
//
//  Created by unisedu on 15/3/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Baller_MyAttentionBallPark : NSObject

@property (nonatomic,copy)NSString * attend_time;
@property (nonatomic,assign)NSInteger court_id;
@property (nonatomic,copy)NSString * court_img;
@property (nonatomic,copy)NSString * court_name;
@property (nonatomic,assign)NSInteger  a_id;
@property (nonatomic,assign)CGFloat img_height;
@property (nonatomic,assign)CGFloat img_width;
@property (nonatomic,assign)NSInteger uid;
@property (nonatomic,copy)NSString *my_home_court;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end