//
//  Baller_MessageListInfo.h
//  Baller
//
//  Created by malong on 15/3/29.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Baller_MessageListInfo : NSObject
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * from_uid;
@property (nonatomic, copy) NSString * from_username;
@property (nonatomic) BOOL is_read;
@property (nonatomic, copy) NSString * msg_id;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy) NSString * pic;
@property (nonatomic, copy) NSString * send_time;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * theme_id;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * to_uid;
@property (nonatomic) NSInteger type;

+ (instancetype)shareWithServerDictionary:(NSDictionary *)dic;

@end
