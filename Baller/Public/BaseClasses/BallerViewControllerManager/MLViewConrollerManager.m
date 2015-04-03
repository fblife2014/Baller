//
//  SXViewConrollerManager.m
//  SXHYB
//
//  Created by malong on 14-4-25.
//  Copyright (c) 2014年 sanxian. All rights reserved.
//

#import "MLViewConrollerManager.h"
#import "BaseViewController.h"
#import "PopingAnimator.h"


@implementation MLViewConrollerManager

+ (MLViewConrollerManager *)sharedVCMInstance
{
    __strong static MLViewConrollerManager * _sharedObject = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
    
}

+ (void)clearDelegate{
    
    [[self class]sharedVCMInstance].navigationController = nil;
    [[self class]sharedVCMInstance].popAnimator = nil;
    
}


- (void)setRootController:(UIViewController*)rootViewController{
    if (_rootViewController) {
        _rootViewController = nil;
    }
    _rootViewController = rootViewController;
    
    if (IOS7) {
        //获取navigationController
        self.navigationController = self.rootViewController.navigationController;
        
        
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.rootViewController.view addGestureRecognizer:panRecognizer];
        self.navigationController.delegate = self;
    
        self.popAnimator = [PopingAnimator new];
    }
 
}

- (UIViewController *)rootViewController{
    return  _rootViewController;
}


+ (void)pushToTheViewController:(NSString *)viewControllerName transferInfo:(id)transferInfo{
    
    if (viewControllerName && [NSClassFromString(viewControllerName) isSubclassOfClass:[BaseViewController class]])
    {
        BaseViewController * nextvc = [[NSClassFromString(viewControllerName) alloc]init];
        nextvc.pushInfo = transferInfo;
        nextvc.hidesBottomBarWhenPushed = YES;
        [[[[self class] sharedVCMInstance] rootViewController].navigationController pushViewController:nextvc animated:YES];
    }
    
}



+ (void)popToLastViewController
{
    [MLViewConrollerManager clearDelegate];
    [[[[self class] sharedVCMInstance] rootViewController].navigationController popViewControllerAnimated:YES];
    
    
}

+ (void)popToRootViewController
{
    
    [MLViewConrollerManager clearDelegate];

    [[[[self class] sharedVCMInstance] rootViewController].navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark 控制器间切换动画

- (void)pan:(UIPanGestureRecognizer*)recognizer
{
    UIView* view = self.navigationController.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //手势启动
        CGPoint location = [recognizer locationInView:view];
        if (location.x <  CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) { // left half
            self.interactionController = [UIPercentDrivenInteractiveTransition new];  //生成新的UIPercentDrivenInteractiveTransition对象
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        //手势状态改变后的处理
        
        CGPoint translation = [recognizer translationInView:view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.interactionController updateInteractiveTransition:d];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        //手势结束后的处理
        if ([recognizer velocityInView:view].x > 0) {
            [self.interactionController finishInteractiveTransition];
        } else {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }
    
}


#pragma mark UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        //返回一个UIViewControllerAnimatedTransitioning对象，实现过渡动画效果
        return self.popAnimator;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    DLog(@"self.interactionController = %@",self.interactionController);
    return self.interactionController;
}


@end
