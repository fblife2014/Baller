//
//  Baller_LoginView.h
//  Baller
//
//  Created by malong on 15/1/9.
//  Copyright (c) 2015年 malong. All rights reserved.
//

/*!
 登录状态枚举值，根据给登录界面设置不同的枚举值，做不同的操作
 */
typedef enum {
    kWaitingForLogin = 0,           //等待登录，即正常待登录界面状态
    kLoginSuccess = 1,              //登录成功，即登录操作成功后的处理状态
    kWaitingForRegister = 2,        //等待注册，即正常的待注册界面
    kRegisterSuccess = 3,           //注册成功，即注册成功后的处理状态
    kResetPassword = 4,             //重置密码，即忘记密码，点击后的状态

}LoginStatus;

typedef void (^DismissBlock)(BOOL isLogin);

#import <UIKit/UIKit.h>

/*!
 *  @brief  登录视图界面
 */
@interface Baller_LoginView : UIView

- (id)initWithFrame:(CGRect)frame dismissBlock:(DismissBlock)block;

@property(nonatomic,assign)UIViewController *targetViewController;//目标controller

@end



#pragma mark LoginScrollView
/*!
 *  @brief  登录视图界面上的滚动视图，各用来统一管理登录控件
 */
@interface LoginScrollView : UIScrollView

/*!
 *  @brief  当前登录状态
 */
@property (nonatomic, assign)LoginStatus loginStatus;

@property(nonatomic,assign)UIViewController *targetViewController;//目标controller


@end






