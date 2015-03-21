//
//  Baller_NetworkInterfaces.h
//  Baller
//
//  Created by malong on 15/2/27.
//  Copyright (c) 2015年 malong. All rights reserved.
//


extern NSString * const Baller_get_code;            //1、获取验证码
extern NSString * const Baller_register;            //2、注册
extern NSString * const Baller_login;               //3、登陆
extern NSString * const Baller_get_user_info;       //4、获取个人信息
extern NSString * const Baller_get_user_attr;       //5、获取球员属性
extern NSString * const Baller_update_user_attr;    //6、更新球员属性
extern NSString * const Baller_update_user_info;    //7、更新个人资料
extern NSString * const Baller_update_user_photo;   //8、更新个人头像
extern NSString * const BallerUpdateHeadImageNotification;  //个人头像更新通知

extern NSString * const Baller_logout;              //9、退出登录
extern NSString * const BallerLogoutThenLoginNotification;  //注销后从新等登录通知

extern NSString * const Baller_get_back_password;   //10、找回密码，重置密码
extern NSString * const Baller_msg_switch;          //11、开/关消息通知接口
extern NSString * const Baller_my_attentio;         //12、关注/取消关注

extern NSString * const Baller_change_password;     //15、修改密码


extern NSString * const Baller_court_create;        //20、创建球场
extern NSString * const Baller_get_court_info;      //21、获取球场详情
extern NSString * const Baller_attend_court;        //22、关注球场
extern NSString * const Baller_auth_court;          //23、认证球场
extern NSString * const Baller_get_nearby_courts;   //24、获取附近球场
extern NSString * const Baller_update_court_img;    //25、更新球场图片
extern NSString * const Baller_get_ballers_by_court_id; //26、获取某球场球员列表
extern NSString * const Baller_get_attend_courts; //27、获取我关注的球场列表


extern NSString * const Baller_activity_create;     //36、发布活动
extern NSString * const Baller_get_activities;      //37、获取活动列表
extern NSString * const Baller_activities_join;     //38、加入活动
extern NSString * const Baller_activity_out;        //39、退出解散活动
extern NSString * const Baller_activity_get_info;   //40、获取活动详情
extern NSString * const Baller_activity_favo;       //41、收藏活动
extern NSString * const Baller_activity_cancel_favo;//42、取消收藏活动
extern NSString * const Baller_get_special_activities;//43、获取某些活动列表 我发起的、收藏的、参加过的、评价过、待评价的
extern NSString * const Baller_invite_join_activity;//44、邀请好友加入某活动
extern NSString * const Baller_team_create;         //50、创建球队
extern NSString * const Baller_team_join_team;      //51、申请加入球队
extern NSString * const Baller_team_check_join;     //52、队长审核加入申请
extern NSString * const Baller_get_teams_by_court_id;//53、获取某球场球队列表
extern NSString * const Baller_get_nearby_teams;    //54、附近的球队列表

extern NSString * const Baller_get_team_info;       //55、根据team_id获取球队详情接口
extern NSString * const Baller_get_my_team;         //56、获取我的球队详情接口
extern NSString * const Baller_get_friend_list;     //57、获取我的好友接口
extern NSString * const Baller_get_attention;       //58、关于/取消关注
#import <Foundation/Foundation.h>

@interface Baller_NetworkInterfaces : NSObject

@end
