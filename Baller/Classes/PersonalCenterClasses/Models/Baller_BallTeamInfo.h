//
//  Baller_BallTeamInfo.h
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Baller_BallTeamInfo : NSObject

@property (nonatomic) long long createTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic) NSInteger courtID;
@property (nonatomic, copy) NSString *teamLeaderUserName;
@property (nonatomic, copy)NSString * logoImageUrl;
@property (nonatomic, copy)NSString * teamName;
@property (nonatomic) NSString *logoSize;
@property (nonatomic) NSInteger createUserID;
@property (nonatomic) NSInteger logoHeight;
@property (nonatomic) NSInteger memberNumber;
@property (nonatomic) NSInteger logoWidth;
@property (nonatomic) NSInteger teamID;
@property (nonatomic) NSInteger teamLeaderUserID;
@property (nonatomic) NSString *court_name;
@property (nonatomic) NSArray *members;

+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic;

+ (NSArray *)teamsWithArray:(NSArray *)array;

@end
