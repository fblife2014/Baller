//
//  AppDelegate.m
//  Baller
//
//  Created by malong on 14/11/23.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "AppDelegate.h"
#import <MAMapKit/MAMapKit.h>
#import "RCIM.h"
#import "MobClick.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"

@interface AppDelegate ()
{
    CLLocationManager * _locationManager;

}
@end

@implementation AppDelegate

+ (instancetype)sharedDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions NS_AVAILABLE_IOS(6_0){
    
    [AFNHttpRequestOPManager checkNetWorkStatus];
    [self registerAPNS];
    [self setLocation];
    [self setNavigationBar];
    [self getTokenFromRC];
    [self userUM];

    return YES;
}

#pragma mark 从融云获取token

-(void)getTokenFromRC
{
    if ([USER_DEFAULT valueForKey:Baller_UserInfo] && ![USER_DEFAULT valueForKey:Baller_RCToken]) {
        //向融云请求token
        [AFNHttpRequestOPManager getRCTokenWithUserId:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"] userName:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"user_name"] portrait_uri:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"photo"] responseBlock:^(id result, NSError *error) {
            DLog(@"result = %@",result);
            if (0 == [[result valueForKey:@"errorcode"] intValue]) {
                [USER_DEFAULT setValue:[result valueForKey:@"token"] forKey:Baller_RCToken];
                [self connectRC];
            }
        }];
    }
}

#pragma mark 连接融云服务器。

- (void)connectRC
{
    if ([USER_DEFAULT valueForKey:Baller_RCToken]) {
        [RCIM connectWithToken:[USER_DEFAULT valueForKey:Baller_RCToken] completion:^(NSString *userId) {
            // 此处处理连接成功。
            NSLog(@"Login successfully with userId: %@.", userId);
            
        } error:^(RCConnectErrorCode status) {
            // 此处处理连接错误。
            NSLog(@"Login failed.");
        }];
    }
}


#pragma mark--使用友盟统计

-(void)userUM{
    [MobClick startWithAppkey:UMKEY];
    
    [UMSocialData setAppKey:UMKEY];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:RedirectUrl];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:QQAPPID appKey:QQAPPKEY url:@"http://www.umeng.com/social"];
    
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WXAPPID appSecret:WXAPPSECRET url:@"http://www.umeng.com/social"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [RCIM initWithAppKey:Baller_RongCloudAppKey deviceToken:nil];
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Register to receive notifications.
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // Handle the actions.
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

// 获取苹果推送权限成功。
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 设置 deviceToken。
    [[RCIM sharedRCIM] setDeviceToken:deviceToken];

    BACKGROUND_BLOCK(^{
        NSString* deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        DLog(@"deviceTokenString = %@",deviceTokenString);
        [USER_DEFAULT setValue:deviceTokenString forKey:Baller_UserInfo_Devicetoken];
        
    });

}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}


#pragma mark 处理推送通知
- (void)registerAPNS{
    // 在 iOS 8 下注册苹果推送，申请推送权限。
    if (IOS8) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                             |UIUserNotificationTypeSound
                                                                                             |UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else if (IOS7){
        // 注册苹果推送，申请推送权限。
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }

}



//判断推送是否打开
- (BOOL)pushNotificationOpen

{
    if (IOS8)
    {
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        return (types & UIRemoteNotificationTypeAlert);
        
    }
    else
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        return (types & UIRemoteNotificationTypeAlert);
    }
    
}



#pragma mark 开启定位
- (void)setLocation{
    _locationManager =[[CLLocationManager alloc] init];
    
    // fix ios8 location issue
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
#ifdef __IPHONE_8_0
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [_locationManager performSelector:@selector(requestAlwaysAuthorization)];//用这个方法，plist中需要NSLocationAlwaysUsageDescription
        }
        
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [_locationManager performSelector:@selector(requestWhenInUseAuthorization)];//用这个方法，plist里要加字段NSLocationWhenInUseUsageDescription
        }
        [_locationManager startUpdatingLocation];
        
#endif
    }
    

}


#pragma mark   设置导航栏
- (void)setNavigationBar{
    [[UINavigationBar appearance] setBarTintColor:RGB(44, 60, 80)]; //ios7以后，使用这个方法设置导航栏的颜色
    
    //真机调试时，ios7.1里面不能通过如下方法translucent设置为NO
    if (IOS8) {
        [UINavigationBar appearance].translucent = NO;    //关闭模糊效果
    }
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];   //给返回按钮着色
    

    //    //修改返回图片
//        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back"]];
//        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
    
    
    /*
     使用导航栏的titleTextAttributes属性来定制导航栏的文字风格。在text attributes字典中使用如下一些key，可以指定字体、文字颜色、文字阴影色以及文字阴影偏移量：
     UITextAttributeFont – 字体key
     UITextAttributeTextColor – 文字颜色key
     UITextAttributeTextShadowColor – 文字阴影色key
     UITextAttributeTextShadowOffset – 文字阴影偏移量key
     */
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];

    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           SYSTEM_FONT_S(19.0), NSFontAttributeName, nil]];
    
    
}



@end
