//
//  SystemDefines.h
//  Baller
//
//  Created by malong on 15/1/10.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#ifndef Baller_SystemDefines_h
#define Baller_SystemDefines_h

#pragma mark 版本及其他信息
//版本及其他信息
#define IOS7    ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7.0)

#define IOS8    ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8.0)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define SYSTEM_VERSION ([[UIDevice currentDevice] systemVersion])

#define SYSTEM_LANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])

#define UMKEY @"55050828fd98c5518e000c31"

#define Baller_AMAP_Key @"8a1575d24fe2d11e7ee537c50550029e" //高德地图key
#define Baller_RongCloudAppKey @"kj7swf8o7zrx2" //容云appkey

#define Baller_RCTestToken @"oFum0Dxv6MkkcYOPskMnXFqSqg2vN7fksoctuRRZGFdeGV9sajE+ZilAAjzB7oess4eI+YwyhFRy9UdKlLevVQ==" //容云测试token

#endif
