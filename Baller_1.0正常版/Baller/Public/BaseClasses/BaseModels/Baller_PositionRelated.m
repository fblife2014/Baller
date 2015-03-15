//
//  Baller_PositionRelated.m
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

NSString * const Baller_PositionDescribe_SF = @"SF";
NSString * const Baller_PositionDescribe_SG = @"SG";
NSString * const Baller_PositionDescribe_C = @"C";
NSString * const Baller_PositionDescribe_PF = @"PF";
NSString * const Baller_PositionDescribe_PG = @"PG";

#import "Baller_PositionRelated.h"

@implementation Baller_PositionRelated
+ (UIColor *)baller_PositionColorWithType:(PositionType)positionType{
    
    UIColor * positionColor;
    
    switch (positionType) {
        case PositionType_SF:
            positionColor = UIColorFromRGB(0x00b8ee);
            break;
        case PositionType_SG:
            positionColor = UIColorFromRGB(0xf07d8a);

            break;
        case PositionType_C:
            positionColor = UIColorFromRGB(0xc89f81);

            break;
        case PositionType_PF:
            positionColor = UIColorFromRGB(0xae90d8);

            break;
        case PositionType_PG:
            positionColor = UIColorFromRGB(0x51d3b7);
            break;

    }
    return positionColor;
}
@end
