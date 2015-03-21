//
//  NSTimer+Baller_BlockSupport.m
//  Baller
//
//  Created by malong on 15/3/1.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "NSTimer+Baller_BlockSupport.h"

@implementation NSTimer (Baller_BlockSupport)

+ (NSTimer *)baller_scheduleTimerWithTimeInterval:(NSTimeInterval)interval
                                            block:(void(^)())block
                                          repeats:(BOOL)repeats{
    
    return [NSTimer timerWithTimeInterval:interval
                                   target:self
                                 selector:@selector(baller_blockInvoke:)
                                 userInfo:[block copy]
                                  repeats:repeats];
}

/*!
 *  @brief  执行计时器循环块
 *
 *  @param timer 以自身为目标对象的NSTimer类对象
 */
+ (void)baller_blockInvoke:(NSTimer *)timer{
    void (^block)() = timer.userInfo;
    if(block){
        block();
    }
}

@end
