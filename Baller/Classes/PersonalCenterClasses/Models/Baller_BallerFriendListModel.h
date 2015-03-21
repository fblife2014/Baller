//
//  Baller_BallerFriendListModel.h
//  Baller
//
//  Created by malong on 15/3/21.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Baller_BallerFriendListModel : NSObject
{
    
}
@property (nonatomic, copy)NSString * court_id;
@property (nonatomic, copy)NSString * court_name;
@property (nonatomic)unsigned long long dateline;
@property (nonatomic, copy)NSString * flag;
@property (nonatomic, copy)NSString * friend_dateline;
@property (nonatomic, copy)NSString * friend_uid;
@property (nonatomic, copy)NSString * friend_user_name;
@property (nonatomic, copy)NSString * friend_user_photo;
@property (nonatomic, copy)NSString * g_id;
@property (nonatomic, copy)NSString * a_id;
@property (nonatomic, copy)NSString * uid;
@property (nonatomic, copy)NSString * position;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end