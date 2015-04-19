//
//  Baller_AbilityInfoEditor.m
//  Baller
//
//  Created by malong on 15/4/19.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_AbilityInfoEditor.h"

@implementation Baller_AbilityInfoEditor

+ (NSString *)levelString:(NSInteger)abilityNumber{
    if (abilityNumber > 50) {
        if (abilityNumber > 105) {
            if (abilityNumber > 140) {
                return @"S+";
            }else{
                return @"S";

            }
        }else if(abilityNumber > 75){
            return @"A+";

        }else {
            return @"A";
        }
    }else if(abilityNumber > 30){
        return @"B+";

    }else if (abilityNumber>15){
        return @"B";

    }else if (abilityNumber>5){
        return @"C+";

    }else{
        return @"C";

    }
}

+ (NSString *)levelStringWithAbility:(NSDictionary *)abilityInfo
{
    NSInteger shoot = [[abilityInfo valueForKey:@"shoot"] integerValue];
    NSInteger assists = [[abilityInfo valueForKey:@"assists"] integerValue];
    NSInteger backboard = [[abilityInfo valueForKey:@"backboard"] integerValue];
    NSInteger steal = [[abilityInfo valueForKey:@"steal"] integerValue];
    NSInteger over = [[abilityInfo valueForKey:@"over"] integerValue];
    NSInteger breakthrough = [[abilityInfo valueForKey:@"breakthrough"] integerValue];
    
    NSInteger max = 0;
    max = max>shoot?max:shoot;
    max = max>assists?max:assists;
    max = max>backboard?max:backboard;
    max = max>steal?max:steal;
    max = max>over?max:over;
    max = max>breakthrough?max:breakthrough;

    return [Baller_AbilityInfoEditor levelString:max];
}

+ (UIColor *)levelColorWithAbility:(NSDictionary *)abilityInfo
{
    NSInteger shoot = [[abilityInfo valueForKey:@"shoot"] integerValue];
    NSInteger assists = [[abilityInfo valueForKey:@"assists"] integerValue];
    NSInteger backboard = [[abilityInfo valueForKey:@"backboard"] integerValue];
    NSInteger steal = [[abilityInfo valueForKey:@"steal"] integerValue];
    NSInteger over = [[abilityInfo valueForKey:@"over"] integerValue];
    NSInteger breakthrough = [[abilityInfo valueForKey:@"breakthrough"] integerValue];
    
    NSInteger max = 0;
    max = max>shoot?max:shoot;
    max = max>assists?max:assists;
    max = max>backboard?max:backboard;
    max = max>steal?max:steal;
    max = max>over?max:over;
    max = max>breakthrough?max:breakthrough;
    
    return [Baller_AbilityInfoEditor levelColor:max];
}

+ (UIColor *)levelColor:(NSInteger)abilityNumber{

    if (abilityNumber > 50) {
        if (abilityNumber > 105) {
            if (abilityNumber > 140) {
                return UIColorFromRGB(0xf14847);
            }else{
                return UIColorFromRGB(0xffa2a2);
                
            }
        }else if(abilityNumber > 75){
            return UIColorFromRGB(0xac56de);
            
        }else {
            return UIColorFromRGB(0xddbcf0);
        }
    }else if(abilityNumber > 30){
        return UIColorFromRGB(0x8dba2a);
        
    }else if (abilityNumber>15){
        return UIColorFromRGB(0xcae58f);
        
    }else if (abilityNumber>5){
        return UIColorFromRGB(0x4fc1a4);
        
    }else{
        return UIColorFromRGB(0xb6ddd3);
    }

}

+ (CGFloat)levelRatio:(NSInteger)abilityNumber totalNumber:(NSInteger)totalNumber
{
    float abilitynumber = (float)abilityNumber;
    float totalnumber = (float)totalNumber;
    if (totalNumber != 0) {
        return MAX(0.25, MIN(0.96, abilitynumber/totalnumber+0.25));

    }else{
        return 0.25;
    }
}

@end
