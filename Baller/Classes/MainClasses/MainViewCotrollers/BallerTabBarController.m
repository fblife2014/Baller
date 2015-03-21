//
//  BallerTabBarController.m
//  Baller
//
//  Created by malong on 14/11/23.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "BallerTabBarController.h"
#import "Baller_PersonalInfoViewController.h"

#import "Baller_LoginView.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"

@interface BallerTabBarController ()<UIViewControllerTransitioningDelegate>

@end

@implementation BallerTabBarController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    [self createTabBarItemImage];
    
#pragma mark 如果用户已经登录，不需要再加载登录界面
    if ([USER_DEFAULT valueForKey:Baller_UserInfo])return;
    
#pragma mark 如果用户未登录，不需加载登录界面
    __WEAKOBJ(weakSelf, self);
    Baller_LoginView * baller_loginView = [[Baller_LoginView alloc]initWithFrame:[UIScreen mainScreen].bounds dismissBlock:^(BOOL isLogin){
        __WEAKOBJ(weakLoginView, baller_loginView);
        if (isLogin) {
            [weakLoginView removeFromSuperview];
        }else{
            //界面跳转
            weakSelf.navigationController.navigationBarHidden = YES;
            Baller_PersonalInfoViewController * vc = [Baller_PersonalInfoViewController new];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.title = NSLocalizedString(@"CompletePersonalInfo", nil);
            
            [weakSelf.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:NULL];
        }

    }];
    
    baller_loginView.targetViewController = self;
    
    [self.view addSubview:baller_loginView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)createTabBarItemImage
{
    NSArray *imageArray = @[@"tabbar_message",@"tabbar_ballPark",@"tabbar_my"];
    NSArray *selectedImageArray = @[@"tabbar_message_selected",@"tabbar_ballPark_selected",@"tabbar_my_selected"];
    
    for (int i=0; i<self.tabBar.items.count; i++) {
        
        UITabBarItem *item = self.tabBar.items[i];
        item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        UIImage *image = [UIImage imageNamed:imageArray[i]];
        if (IOS7) {
            image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        UIImage * selectedImage =  [UIImage imageNamed:selectedImageArray[i]];
        
        if (IOS7) {
            selectedImage=[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        item.image = image;
        item.selectedImage = selectedImage;
    }
    
    [self.tabBar setBarTintColor:UIColorFromRGB(0X2e3d51)];
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = [UIColor whiteColor];
    [self setSelectedIndex:1];
    
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
