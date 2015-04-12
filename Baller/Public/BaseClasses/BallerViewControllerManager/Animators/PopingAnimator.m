//
//  Animator.h
//  NavigationTransitionTest
//
//  Created by malong on 14/11/5.
//  Copyright (c) 2014年 malong. All rights reserved.
//

//源代码出处：https://github.com/objcio/issue5-view-controller-transitions


#import "PopingAnimator.h"
#import "UIView+ML_BlurView.h"

@implementation PopingAnimator

//设置过渡时间
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

//重写交互式动画效果
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    [[transitionContext containerView] addSubview:fromViewController.view];
    [toViewController.view bringSubviewToFront:toViewController.view.blurView];
    fromViewController.view.alpha = 1.0;
    toViewController.view.alpha = 0.5;
    toViewController.view.frame = CGRectMake(-ScreenWidth, toViewController.view.frame.origin.y, ScreenWidth, toViewController.view.frame.size.height);

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.frame = CGRectMake(0.0, toViewController.view.frame.origin.y, ScreenWidth, toViewController.view.frame.size.height);
        toViewController.tabBarController.tabBar.frame = CGRectMake(0.0, ScreenHeight-TabBarHeight, ScreenWidth, TabBarHeight);

        fromViewController.view.frame = CGRectMake(ScreenWidth, fromViewController.view.frame.origin.y, ScreenWidth, fromViewController.view.frame.size.height);
        fromViewController.view.transform = CGAffineTransformMakeScale(1., 1.0);
        toViewController.view.alpha = 1.0;

    } completion:^(BOOL finished) {

        fromViewController.view.transform = CGAffineTransformIdentity;
        //结束过场切换
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
    
    
}

@end
