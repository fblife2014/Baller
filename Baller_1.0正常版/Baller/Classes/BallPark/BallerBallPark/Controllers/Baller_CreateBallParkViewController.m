//
//  Baller_CreateBallParkViewController.m
//  Baller
//
//  Created by malong on 15/1/24.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_CreateBallParkViewController.h"
#import "Baller_AnnotationMapViewController.h"

#import "Baller_CardView.h"

@interface Baller_CreateBallParkViewController ()

@end

@implementation Baller_CreateBallParkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建球场";
    [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"]];
    Baller_CardView * createCardView = [[Baller_CardView alloc]initWithFrame:CGRectMake(TABLE_SPACE_INSET, 10.0, ScreenWidth-2*TABLE_SPACE_INSET, self.view.frame.size.height-20.0) playerCardType:kBallerCardType_CreateBallPark];
    
    __WEAKOBJ(weakSelf, self);
    createCardView.createBallParkView.autoAnnotion = ^(BOOL isAutoAnnotion){
        Baller_AnnotationMapViewController * anntionMapVC = [[Baller_AnnotationMapViewController alloc]init];
        anntionMapVC.autoAnnotion = isAutoAnnotion;
        anntionMapVC.posionCallBack = ^(NSDictionary * positonInfo){
            DLog(@"positonInfo = %@",positonInfo);
        };
        [weakSelf.navigationController pushViewController:anntionMapVC animated:YES];
        
    };
    [self.view addSubview:createCardView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
