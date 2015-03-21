//
//  SXViewConrollerManager.h
//  SXHYB
//
//  Created by malong on 14-4-25.
//  Copyright (c) 2014年 sanxian. All rights reserved.
//


#import <Foundation/Foundation.h>

@class PopingAnimator;
@class BaseViewController;

@interface MLViewConrollerManager : NSObject <UINavigationControllerDelegate>

@property (nonatomic,strong) UIViewController * rootViewController; //当前根控制器

@property (nonatomic, weak) UINavigationController * navigationController;

@property (nonatomic, strong) PopingAnimator* popAnimator;    //把动画效果设置为类的一个属性，实现多个操作中共享

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition* interactionController;


+ (MLViewConrollerManager *)sharedVCMInstance;

+ (void)clearDelegate;   //清空代理

- (void)setRootController:(UIViewController*)rootViewController;

- (UIViewController *)rootViewController;


//推入下一个视图控制器，并把下一个视图控制器需要的信息带过去
+ (void)pushToTheViewController:(NSString *)viewControllerName
                   transferInfo:(id)transferInfo;

+ (void)popToLastViewController;

+ (void)popToRootViewController;

@end
