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
extern NSString * const BallerUpdateUserInfoNotification;  //个人头像更新通知

extern NSString * const Baller_logout;              //9、退出登录
extern NSString * const BallerOpenLocationNotification;//打开定位成功通知
extern NSString * const BallerLoginSuccessNotification;//登录通知成功通知
extern NSString * const BallerLogoutThenLoginNotification;  //注销后从新等登录通知

extern NSString * const Baller_get_back_password;   //10、找回密码，重置密码
extern NSString * const Baller_msg_switch;          //11、开/关消息通知接口
extern NSString * const Baller_my_attention;         //12、关注/取消关注
extern NSString * const Baller_get_friend_list;     //13、获取我的好友接口
extern NSString * const Baller_select_my_court;     //14、选择我的主场

extern NSString * const Baller_change_password;     //15、修改密码

extern NSString * const Baller_search_user;    //16、搜索用户

extern NSString * const Baller_evaluate_activity;   //17、评价球员
extern NSString * const Baller_get_msg; //18-1、获取我的消息列表
extern NSString * const Baller_del_msg; //18-2、获取我的消息列表
extern NSString * const Baller_get_msg_info; //18-3、获取我的消息列表

extern NSString * const Baller_court_create;        //20、创建球场
extern NSString * const Baller_get_court_info;      //21、获取球场详情
extern NSString * const Baller_attend_court;        //22、关注球场
extern NSString * const Baller_cancel_attend_court; //22-2、取消关注球场

extern NSString * const Baller_auth_court;          //23、认证球场
extern NSString * const Baller_get_nearby_courts;   //24、获取附近球场
extern NSString * const Baller_update_court_img;    //25、更新球场图片
extern NSString * const Baller_get_ballers_by_court_id; //26、获取某球场球员列表
extern NSString * const Baller_get_attend_courts; //27、获取我关注的球场列表
extern NSString * const Baller_get_attend_user_by_court; //28、关注球场的球员列表
extern NSString * const Baller_get_my_courts; //29、关注球场的球员列表
extern NSString * const Baller_upload_share_pic; //30、上传分享球员卡
extern NSString * const Baller_user_share; //30.1、上传分享球员卡


extern NSString * const Baller_activity_create;     //36、发布活动
extern NSString * const Baller_get_activities;      //37、获取活动列表
extern NSString * const Baller_activities_join;     //38、加入活动
extern NSString * const Baller_activity_out;        //39、退出解散活动
extern NSString * const Baller_activity_get_info;   //40、获取活动详情
extern NSString * const Baller_activity_favo;       //41、收藏活动
extern NSString * const Baller_activity_cancel_favo;//42、取消收藏活动
extern NSString * const Baller_get_special_activities;//43、获取某些活动列表 我发起的、收藏的、参加过的、评价过、待评价的
extern NSString * const Baller_invite_join_activity;//44、邀请好友加入某活动
extern NSString * const Baller_get_no_appraised_by_activity;//46、根据活动id获取待评价人员列表

extern NSString * const Baller_team_create;         //50、创建球队
extern NSString * const Baller_team_join_team;      //51、申请加入球队
extern NSString * const Baller_team_check_join;     //52、队长审核加入申请
extern NSString * const Baller_get_teams_by_court_id;//53、获取某球场球队列表
extern NSString * const Baller_get_nearby_teams;    //54、附近的球队列表

extern NSString * const Baller_get_team_info;       //55、根据team_id获取球队详情接口
extern NSString * const Baller_get_my_team;         //56、获取我的球队详情接口
extern NSString * const Baller_team_out;            //57、退出、解散球队
extern NSString * const Baller_team_change_leader;  //58、更换队长
extern NSString * const Baller_team_check_invite_join;  //59、处理加入球队的邀请接口
extern NSString * const Baller_get_team_info_by_ti_id;  //60、根据邀请加入球队的id，获取球场详情

#import <Foundation/Foundation.h>

@interface Baller_NetworkInterfaces : NSObject

@end
