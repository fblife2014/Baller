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

#define UMKEY @"551be5b9fd98c50cb20012ab"//baller，友盟账号15600257760@163.com

//#define UMKEY @"548bae91fd98c50d0c000b8b"//衣+衣

#define Baller_AMAP_Key @"8a1575d24fe2d11e7ee537c50550029e" //高德地图key
#define Baller_RongCloudAppKey @"kj7swf8o7zrx2" //容云appkey

#define Baller_RCTestToken @"oFum0Dxv6MkkcYOPskMnXFqSqg2vN7fksoctuRRZGFdeGV9sajE+ZilAAjzB7oess4eI+YwyhFRy9UdKlLevVQ==" //容云测试token

//第三方appkey和appSecret

#define SinaAppKey @"1270257351"
#define SinaAppSecret @"e620de093a9acc3618aca003cf0d32d7"

#define QQAPPID @"1104467876" //十六进制:41CEB39B; 生成方法:echo 'ibase=10;obase=16;1104065435'|bc
#define QQAPPKEY @"jPVa4UMOobYnZiV6"

#define WXAPPID @"wx2e98a5a243ad127b"//正式
#define WXAPPSECRET @"59c7980f44e111a29e2bb91dd694c494"

#define RedirectUrl @"http://sns.whalecloud.com/sina2/callback" //回调地址

#endif
