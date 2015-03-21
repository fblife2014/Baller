//
//  Baller_NetworkInterfaces.m
//  Baller
//
//  Created by malong on 15/2/27.
//  Copyright (c) 2015年 malong. All rights reserved.
//

NSString * const Baller_get_code = @"&c=user&m=get_code"; //1、获取验证码

NSString * const Baller_register= @"&c=user&m=register"; //2、注册

NSString * const Baller_login= @"&c=user&m=login";    //3、登陆

NSString * const Baller_get_user_info= @"&c=user&m=get_user_info"; //4、获取个人信息

NSString * const Baller_get_user_attr= @"&c=user&m=get_user_attr"; //5、获取球员属性信息

NSString * const Baller_update_user_attr= @"&c=user&m=update_user_attr"; //6、更新球员属性

NSString * const Baller_update_user_info= @"&c=user&m=update_user_info"; //7、更新个人资料

NSString * const Baller_update_user_photo= @"&c=user&m=update_user_photo"; //8、更新个人头像
NSString * const BallerUpdateHeadImageNotification = @"BallerUpdateHeadImageNotification";  //个人头像更新通知


NSString * const Baller_logout = @"&c=user&m=login_out";  //9、退出登录
NSString * const BallerLogoutThenLoginNotification = @"BallerLogoutThenLoginNotification";  //注销后从新等登录通知
NSString * const Baller_get_back_password = @"&c=user&m=get_back_password";  //10、找回密码，重置密码

NSString * const Baller_msg_switch = @"&c=user&m=msg_switch";   //11、开/关消息通知接口
NSString * const Baller_my_attentio = @"&c=my&m=attentio";   //12、关注/取消关注

NSString * const Baller_change_password = @"&c=user&m=change_password";    //修改密码


NSString * const Baller_court_create = @"&c=court&m=create";        //20、创建球场

NSString * const Baller_get_court_info = @"&c=court&m=get_court_info";      //21、获取球场详情

NSString * const Baller_attend_court = @"&c=court&m=attend_court";          //22、关注球场

NSString * const Baller_auth_court = @"&c=court&m=auth_court";          //23、认证球场

NSString * const Baller_get_nearby_courts = @"&c=court&m=get_nearby_courts"; //24、获取附近球场

NSString * const Baller_update_court_img = @"&c=court&m=update_court_img";    //25、更新球场图片

NSString * const Baller_get_ballers_by_court_id = @"&c=court&m=get_ballers_by_court_id"; //26、获取某球场球员列表

NSString * const Baller_get_attend_courts = @"&c=court&m=get_attend_courts"; //27、获取我关注的球场列表




NSString * const Baller_activity_create = @"&c=activity&m=create";    //36、发布活动

NSString * const Baller_get_activities = @"&c=activity&m=get_activities";  //37、获取活动列表

NSString * const Baller_activities_join = @"&c=activity&m=join_activities";  //38、加入活动

NSString * const Baller_activity_out =
@"&c=activity&m=out_activity";  //39、 退出、解散活动

NSString * const Baller_activity_get_info = @"&c=activity&m=get_activity_info";   //40、获取活动详情
NSString * const Baller_activity_favo = @"&c=activity&m=favo_activity";       //41、收藏活动
NSString * const Baller_activity_cancel_favo = @"&c=activity&m=cancel_favo_activity";//42、取消收藏活动
NSString * const Baller_get_special_activities = @"&c=activity&m=get_special_activities";//43、获取某些活动列表 我发起的、收藏的、参加过的、评价过、待评价的
NSString * const Baller_invite_join_activity = @"&c=activity&m=invite_join_activity";//44、邀请好友加入某活动



NSString * const Baller_team_create = @"&c=team&m=create";              //50、创建球队
NSString * const Baller_team_join_team = @"&c=team&m=join_team";        //51、申请加入球队
NSString * const Baller_team_check_join = @"&c=team&m=check_join";     //52、队长审核加入申请
NSString * const Baller_get_teams_by_court_id = @"&c=team&m=get_teams_by_court_id";//53、获取某球场球队列表
NSString * const Baller_get_nearby_teams = @"&c=team&m=get_nearby_teams";//54、附近的球队列表
NSString * const Baller_get_team_info = @"&c=team&m=get_team_info";//55、根据team_id获取球队详情接口

NSString * const Baller_get_my_team = @"&c=team&m=get_my_team";         //56、获取我的球队详情接口
NSString * const Baller_get_friend_list = @"&c=my&m=get_friend_list";   //57、获取我的好友接口
NSString * const Baller_get_attention = @"&c=my&m=attention";           //58、关于/取消关注
@implementation Baller_NetworkInterfaces

@end
