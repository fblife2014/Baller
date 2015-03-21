//
//  Baller_BallParkAttentionBallerListModel.h
//  Baller
//
//  Created by malong on 15/3/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Baller_BallParkAttentionBallerListModel : NSObject

@property (nonatomic)unsigned long long check_dateline;
@property (nonatomic, copy)NSString * check_uid;
@property (nonatomic)unsigned long long dateline;
@property (nonatomic, copy)NSString * photo;
@property (nonatomic, copy)NSString * position;
@property (nonatomic) NSInteger status;
@property (nonatomic, copy)NSString * team_id;
@property (nonatomic, copy)NSString * tm_id;
@property (nonatomic, copy)NSString * uid;
@property (nonatomic, copy)NSString * user_name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
