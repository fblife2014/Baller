//
//  Baller_PositionRelated.h
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//

typedef NS_ENUM(NSUInteger, PositionType) {
    PositionType_SF = 0,
    PositionType_SG ,
    PositionType_C ,
    PositionType_PF ,
    PositionType_PG ,

};

extern NSString * const Baller_PositionDescribe_SF;
extern NSString * const Baller_PositionDescribe_SG;
extern NSString * const Baller_PositionDescribe_C;
extern NSString * const Baller_PositionDescribe_PF;
extern NSString * const Baller_PositionDescribe_PG;


#import <Foundation/Foundation.h>

@interface Baller_PositionRelated : NSObject

+ (UIColor *)baller_PositionColorWithType:(PositionType)positionType;


@end
