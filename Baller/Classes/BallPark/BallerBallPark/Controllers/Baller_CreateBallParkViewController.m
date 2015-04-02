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
{
    __block NSMutableDictionary * chosedPositionInfo;
}
@end

@implementation Baller_CreateBallParkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建球场";
    chosedPositionInfo = [NSMutableDictionary dictionary];
    Baller_CardView * createCardView = [[Baller_CardView alloc]initWithFrame:CGRectMake(TABLE_SPACE_INSET, 10.0, ScreenWidth-2*TABLE_SPACE_INSET, self.view.frame.size.height-20.0) playerCardType:kBallerCardType_CreateBallPark];
    __WEAKOBJ(weakCardView, createCardView);

    createCardView.bottomButtonClickedBlock = ^(BallerCardType cardType){
        if ([[weakCardView.createBallParkView.ballParkInfos valueForKey:@"name"] length] == 0) {
            [Baller_HUDView bhud_showWithTitle:@"请输入球场名！"];
            return ;
        }else if(!chosedPositionInfo.allValues.count){
            [Baller_HUDView bhud_showWithTitle:@"请选择球场位置！"];
            return;
        }else if (!weakCardView.createBallParkView.ballParkImageView.image){
            [Baller_HUDView bhud_showWithTitle:@"未上传球场图片！"];
        }
        NSDictionary * createInfo = @{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"court_name":[weakCardView.createBallParkView.ballParkInfos valueForKey:@"name"],@"address":[chosedPositionInfo valueForKey:@"address"],@"latitude":[chosedPositionInfo valueForKey:@"latitude"],@"longitude":[chosedPositionInfo valueForKey:@"longitude"]};
        NSData * imageData = nil;
        if (weakCardView.createBallParkView.ballParkImageView.image) {
            imageData = UIImageJPEGRepresentation(weakCardView.createBallParkView.ballParkImageView.image, 0.5);
        }
        
        [AFNHttpRequestOPManager postImageWithSubUrl:Baller_court_create parameters:createInfo fileName:@"pic" fileData:imageData?imageData:nil fileType:@"image/jpg" responseBlock:^(id result, NSError *error) {
            if (error)return ;
            if ([[result valueForKey:@"errorcode"] intValue] == 0) {
                [Baller_HUDView bhud_showWithTitle:[result valueForKey:@"msg"]];
                [self PopToLastViewController];
            }else{
                [Baller_HUDView bhud_showWithTitle:[error valueForKey:@"msg"]];
            }
        }];
    };
    
    if ([USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]) {
        UIImage * headImage = [UIImage imageWithData:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]];
        
        [self showBlurBackImageViewWithImage:headImage belowView:nil];
        [[createCardView headImageButton]setBackgroundImage:headImage forState:UIControlStateNormal];
        
    }else{
        [[createCardView headImageButton] setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImage]] placeholderImage:[UIImage imageNamed:@"ballPark_default"]];
        
    }

    __WEAKOBJ(weakSelf, self);
    createCardView.createBallParkView.autoAnnotion = ^(BOOL isAutoAnnotion){
        Baller_AnnotationMapViewController * anntionMapVC = [[Baller_AnnotationMapViewController alloc]init];
        anntionMapVC.autoAnnotion = isAutoAnnotion;
        anntionMapVC.posionCallBack = ^(NSDictionary * positonInfo){
            [chosedPositionInfo removeAllObjects];
            [chosedPositionInfo setValuesForKeysWithDictionary:positonInfo];
            DLog(@"chosedPositionInfo = %@",chosedPositionInfo);

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
