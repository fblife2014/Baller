//
//  Baller_PlayerCardViewController.m
//  Baller
//
//  Created by malong on 15/1/17.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_PlayerCardViewController.h"
#import "UIButton+AFNetworking.h"
#import "Baller_MyAttentionBallPark.h"
#import "Baller_BallerFriendListModel.h"

@interface Baller_PlayerCardViewController ()

@end

@implementation Baller_PlayerCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSubViews];
}

- (void)showSubViews{
    if (_friendModel) {
        _uid = _friendModel.friend_uid;
        self.navigationItem.title = _friendModel.friend_user_name;
        _photoUrl = _friendModel.friend_user_photo;
    }
    if (_userName) {
        self.navigationItem.title = _userName;
    }
    switch (_ballerCardType) {
        case kBallerCardType_FirstBorn:
        case kBallerCardType_MyPlayerCard:
            self.navigationItem.title = @"我的球员卡";
            break;
        case kBallerCardType_OtherBallerPlayerCard:
            self.navigationItem.title = _userName;
            break;
            
        default:
            break;
    }
    [self setMyPlayerCardSubviews];

}

/*!
 *  @brief  个人信息框
 */
- (Baller_CardView *)playCardView
{
    if (!_playCardView) {
        _playCardView = [[Baller_CardView alloc]initWithFrame:CGRectMake(TABLE_SPACE_INSET, 10.0, ScreenWidth-2*TABLE_SPACE_INSET, self.view.frame.size.height-20.0) playerCardType:self.ballerCardType];
        if (_activity_id)_playCardView.activity_id = _activity_id;
        if (_uid) {
            _playCardView.uid = _uid;
            
        }else{
            __BLOCKOBJ(blockPlayCard, _playCardView);
            [AFNHttpRequestOPManager getWithSubUrl:Baller_get_user_attr parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode]} responseBlock:^(id result, NSError *error) {
                
                if([result isKindOfClass:[NSDictionary class]]){
                    blockPlayCard.abilityDetails =
                    @[@(MAX([[result valueForKey:@"shoot"] floatValue]/1000.0, 0.4)),
                      @(MAX([[result valueForKey:@"assists"] floatValue]/1000.0, 0.4)),
                      @(MAX([[result valueForKey:@"backboard"] floatValue]/1000.0, 0.4)),
                      @(MAX([[result valueForKey:@"steal"] floatValue]/1000.0, 0.4)),
                      @(MAX([[result valueForKey:@"over"] floatValue]/1000.0, 0.4)),
                      @(MAX([[result valueForKey:@"breakthrough"] floatValue]/1000.0, 0.4))];
                }
                
            }];

        }
        
        [self.view addSubview:_playCardView];
        [self.view bringSubviewToFront:_playCardView];
        
    }
    return _playCardView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 我的球员卡界面情况

- (void)setMyPlayerCardSubviews{
    if (_photoUrl) {
        
        [[[self playCardView] headImageButton]setImageForState:UIControlStateNormal withURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_photoUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [self showBlurBackImageViewWithImage:image belowView:[self playCardView]];
        } failure:^(NSError *error) {
            [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"] belowView:[self playCardView]];
        }];
        
    }else{
        if ([USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData])
        {
            UIImage * image = [UIImage imageWithData:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]];
            [self showBlurBackImageViewWithImage:image belowView:nil];
            [[[self playCardView] headImageButton] setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImage]] placeholderImage:[UIImage imageNamed:@"manHead"]];
            
        }else{
            [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"] belowView:nil];
            [self playCardView];
            
        }
    }

    
    if (self.ballerCardType == kBallerCardType_FirstBorn) {
        self.navigationItem.rightBarButtonItem = [ViewFactory getABarButtonItemWithTitle:@"进入主页" titleEdgeInsets:UIEdgeInsetsZero target:self selection:@selector(goToMainView)];
    }else if(self.presentingViewController){
                self.navigationItem.leftBarButtonItem = [ViewFactory getABarButtonItemWithTitle:@"返回" titleEdgeInsets:UIEdgeInsetsZero target:self selection:@selector(goToMainView)];
    }
    
}

#pragma mark 按钮方法
/*!
 *  @brief  进入主页方法
 */
- (void)goToMainView
{
    [(UIViewController *)self.navigationController.viewControllers[0] dismissViewControllerAnimated:YES completion:NULL];
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
