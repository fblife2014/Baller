//
//  Baller_NetworkInterfaces.h
//  Baller
//
//  Created by malong on 15/2/27.
//  Copyright (c) 2015年 malong. All rights reserved.
//


extern NSString * const Baller_get_code; //1、获取验证码
extern NSString * const Baller_register; //2、注册
extern NSString * const Baller_login;    //3、登陆
extern NSString * const Baller_get_user_info; //4、获取个人信息
extern NSString * const Baller_get_user_attr; //5、获取球员属性信息
extern NSString * const Baller_update_user_attr; //6、更新球员属性
extern NSString * const Baller_update_user_info; //7、更新个人资料
extern NSString * const Baller_update_user_photo; //8、更新个人头像
extern NSString * const Baller_court_create;        //20、创建球场
extern NSString * const Baller_get_court_info;      //21、获取球场详情
extern NSString * const Baller_attend_court;          //22、关注球场
extern NSString * const Baller_auth_court;          //23、认证球场
extern NSString * const Baller_get_nearby_courts; //24、获取附近球场
extern NSString * const Baller_activity_create;    //25、发布活动
extern NSString * const Baller_update_court_img;    //27、更新球场图片

extern NSString * const Baller_logout;  //28、注销登录


#import <Foundation/Foundation.h>

@interface Baller_NetworkInterfaces : NSObject

@end
