//
//  Baller_NetworkInterfaces.m
//  Baller
//
//  Created by malong on 15/2/27.
//  Copyright (c) 2015年 malong. All rights reserved.
//

NSString * const Baller_get_code = @"&m=get_code"; //1、获取验证码
NSString * const Baller_register= @"&m=register"; //2、注册
NSString * const Baller_login= @"&c=user&m=login";    //3、登陆
NSString * const Baller_get_user_info= @"&c=user&m=get_user_info"; //4、获取个人信息
NSString * const Baller_get_user_attr= @"&c=user&m=get_user_attr"; //5、获取球员属性信息
NSString * const Baller_update_user_attr= @"&c=user&m=update_user_attr"; //6、更新球员属性
NSString * const Baller_update_user_info= @"&c=user&m=update_user_info"; //7、更新个人资料
NSString * const Baller_update_user_photo= @"&c=user&m=update_user_photo"; //8、更新个人头像
NSString * const Baller_court_create = @"&c=court&m=create";        //20、创建球场
NSString * const Baller_get_court_info = @"&c=court&m=get_court_info";      //21、获取球场详情
NSString * const Baller_attend_court = @"&c=court&m=attend_court";          //22、关注球场
NSString * const Baller_auth_court = @"&c=court&m=auth_court";          //23、认证球场
NSString * const Baller_get_nearby_courts = @"&c=court&m=get_nearby_courts"; //24、获取附近球场
NSString * const Baller_activity_create = @"&c=activity&m=create";    //25、发布活动
NSString * const Baller_update_court_img = @"&c=court&m=update_court_img";    //27、更新球场图片
NSString * const Baller_logout = @"&c=user&m=login_out";  //28、注销登录


#import "Baller_NetworkInterfaces.h"

@implementation Baller_NetworkInterfaces

@end
