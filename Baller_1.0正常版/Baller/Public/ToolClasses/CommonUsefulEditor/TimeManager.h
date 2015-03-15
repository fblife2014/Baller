//
//  TimeManager.h
//  LightApp
//
//  Created by malong on 14/12/1.
//  Copyright (c) 2014年 malong. All rights reserved.
//
/*
 *brief 时间戳管理
 */
#import <Foundation/Foundation.h>

@interface TimeManager : NSObject
/*
 *brief 编辑返回一个有效的时间字符串
 */
+ (NSString *)userfulTimeString:(NSString *)timeString;

/*
 *brief 当前时间距创建时间的时间间隔
 *param createTime创建的时间
 *formatString 时间格式
 */
+ (NSString *)theInterValTimeFromCreateTime:(NSString *)createTime
                               formatString:(NSString *)formatString;


/*
 *brief 比较时间是否比当前时间早
 *param timeString 时间
 *formatString 时间格式
 */
+ (BOOL) isTimeOlderThanCurrentTime:(NSString *)timeString
                       formatString:(NSString *)formatString;


/*
 *brief 比较两时间
 *param time1String 第一个时间
 *param time2String 第二个时间
 *formatString 时间格式
 */
+ (BOOL) isTime1:(NSString *)time1String
  orderThanTime2:(NSString *)time2String
    formatString:(NSString *)formatString;

/*
 *brief 倒计时
 */
+ (NSString *)lastTime:(NSDate *)lockDate;


#pragma mark 获取本月，本周，本季度第一天的时间戳
+ (unsigned long long)getFirstDayOfWeek:(unsigned long long)timestamp;
+ (unsigned long long)getFirstDayOfQuarter:(unsigned long long)timestamp;
+ (unsigned long long)getFirstDayOfMonth:(unsigned long long)timestamp;

@end
