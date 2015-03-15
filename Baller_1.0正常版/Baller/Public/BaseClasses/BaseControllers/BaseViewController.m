//
//  BaseViewController.m
//  LightApp
//
//  Created by malong on 14/11/4.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "BaseViewController.h"
#import "Masonry.h"
#import "UIView+ML_BlurView.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.page = 1;
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.view.backgroundColor = UIColorFromRGB(0xe7e7e7);

    
    // Do any additional setup after loading the view from its nib.
}

/*!
 *  @brief  模糊背景
 *
 *  @param image 模糊背景视图
 */
- (void)showBlurBackImageViewWithImage:(UIImage *)image
{
    if (image) {
        [self.blurBackImageView setImage:image];
        [self.blurBackImageView showBlurWithDuration:0.0 blurStyle:kUIBlurEffectStyleLight hidenViews:nil];
    }else{
        [self.view showBlurWithDuration:0.0 blurStyle:kUIBlurEffectStyleLight hidenViews:nil];
    }
    self.blurBackImageView.frame = CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight);
     
}


- (void)removeOldBlurView{
    [self.blurBackImageView removeOldBlurEffectView];

}

- (UIImageView *)blurBackImageView
{
    if (!_blurBackImageView) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
      [self.view addSubview:_blurBackImageView = imageView];
    }
    return _blurBackImageView;
}


- (UIScrollView *)bottomScrollView
{
    if (!_bottomScrollView) {
        UIScrollView * scrollView = [UIScrollView new];
        scrollView.backgroundColor = CLEARCOLOR;
        scrollView.frame = self.view.frame;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_bottomScrollView = scrollView];
    }
    return _bottomScrollView;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[MLViewConrollerManager sharedVCMInstance]setRootController:self];
    
    DLog(@"_pushinfo = %@",_pushInfo);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    self.view.backgroundColor = UIColorFromRGB(0Xe6e6e6);
    // Dispose of any resources that can be recreated.
}


#pragma mark 视图设置




#pragma mark 视图控制器跳转
- (void)PopToLastViewController{
    
    [MLViewConrollerManager clearDelegate];

    [self.navigationController popViewControllerAnimated:YES];
    

}
- (void)PopToRootViewController{
    
    [MLViewConrollerManager clearDelegate];
  
    
    [self.navigationController popToRootViewControllerAnimated:YES];

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
