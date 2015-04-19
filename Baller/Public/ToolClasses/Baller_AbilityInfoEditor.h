//
//  Baller_AbilityInfoEditor.h
//  Baller
//
//  Created by malong on 15/4/19.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Baller_AbilityInfoEditor : NSObject


+ (NSString *)levelString:(NSInteger)abilityNumber;
+ (NSString *)levelStringWithAbility:(NSDictionary *)abilityInfo;


+ (UIColor *)levelColor:(NSInteger)abilityNumber;
+ (UIColor *)levelColorWithAbility:(NSDictionary *)abilityInfo;

+ (CGFloat)levelRatio:(NSInteger)abilityNumber totalNumber:(NSInteger)totalNumber;


@end
