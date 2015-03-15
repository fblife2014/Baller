//
//  NSTimer+Baller_BlockSupport.h
//  Baller
//
//  Created by malong on 15/3/1.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Baller_BlockSupport)

/*!
 *  @brief  通过块方法调整计时器对目标对象的“持有”关系
 *
 *  @param interval 计时器执行间隔
 *  @param block    计时器执行方法块
 *  @param repeats  是否重复执行
 *
 *  @return 返回一个NSTimer对象
 */
+ (NSTimer *)baller_scheduleTimerWithTimeInterval:(NSTimeInterval)interval
                                            block:(void(^)())block
                                          repeats:(BOOL)repeats;

@end
