//
//  Baller_PersonalCenterViewController.m
//  Baller
//
//  Created by malong on 15/1/16.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_PersonalInfoViewController.h"
#import "Baller_PlayerCardViewController.h"

#import "Masonry.h"
#import "Baller_PersonalInfoView.h"
#import "UIView+ML_BlurView.h"


@interface Baller_PersonalInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    __weak Baller_PersonalInfoView * _personalInfoView;

}
@end

@implementation Baller_PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserInfo];
    
    if ([USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData])
    {
        UIImage * image = [UIImage imageWithData:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]];
        [self showBlurBackImageViewWithImage:image belowView:nil];
        
    }else{
        [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"] belowView:nil];
    }
    
    [self personalInfoView];
}

#pragma mark 网络请求
- (void)getUserInfo
{    
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_user_info parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode]} responseBlock:^(id result, NSError *error) {
        if (error) {
            return ;
        }
        if([[result valueForKey:@"errorcode"] integerValue] == 0){
            
            NSDictionary * userinfo = [result valueForKey:@"user_info"];
            [USER_DEFAULT setValue:userinfo forKey:Baller_UserInfo];
            [USER_DEFAULT synchronize];
            NSArray * titles = @[NSLocalizedString(@"Height", nil),NSLocalizedString(@"Weight", nil),NSLocalizedString(@"ParkPosition", nil),NSLocalizedString(@"Sex", nil)];
            NSArray * placeHolders = @[@"cm",@"kg",NSLocalizedString(@"Position", nil),NSLocalizedString(@"M/F", nil)];
            
            NSArray * infoDetails = @[$str(@"%@ cm",[userinfo valueForKey:@"height"]),$str(@"%@ kg",[userinfo valueForKey:@"weight"]),[userinfo valueForKey:@"position"],[[userinfo valueForKey:@"gender"] integerValue]==1?@"男":@"女"];
            [_personalInfoView addPersonInfoViewWithTitles:titles placeHolders:placeHolders infoDetails:infoDetails canEdited:YES originY:(_personalInfoView.frame.size.height-5*PersonInfoCell_Height) circleRadius:3.5];

        }
    }];
}
#pragma mark 加载视图
/*!
 *  @brief  个人信息框
 */
- (Baller_PersonalInfoView *)personalInfoView
{
    if (!_personalInfoView) {
        Baller_PersonalInfoView * personalInfoView = [[Baller_PersonalInfoView alloc]initWithFrame:CGRectMake(NUMBER(22.0, 20, 15, 15.0), 10.0, ScreenWidth-2*NUMBER(22.0, 20, 15, 15.0), 7.5*PersonInfoCell_Height)];
        [self.view addSubview:_personalInfoView = personalInfoView];
        
        __WEAKOBJ(weakSelf, self);
        _personalInfoView.doneButtonClickedBlock = (^(NSDictionary * personalInfo){
            //更新个人资料
            [AFNHttpRequestOPManager postWithSubUrl:Baller_update_user_info parameters:personalInfo responseBlock:^(id result, NSError *error) {
                
                if (error) {
                    
                }else{
                    if (0 == [[result valueForKey:@"errorcode"] intValue]) {
                        [self getUserInfo];
                    }
                }
            }];
            if (weakSelf.presentingViewController) {
                
                //跳转到下一页
                Baller_PlayerCardViewController * playerCardViewController = [[Baller_PlayerCardViewController alloc]init];
                playerCardViewController.ballerCardType = kBallerCardType_FirstBorn;
                [weakSelf.navigationController pushViewController:playerCardViewController animated:YES];
                
            }else{
                [self.navigationController popViewControllerAnimated:YES];

            }
            
          
        });

    }
    return _personalInfoView;
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
