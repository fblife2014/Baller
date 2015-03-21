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
@interface Baller_PlayerCardViewController ()

{
    __weak Baller_CardView * _playCardView;
    Baller_CardView * playCardView;
}

@end

@implementation Baller_PlayerCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSubViews];
}

- (void)showSubViews{
 
    switch (_ballerCardType) {
        case kBallerCardType_FirstBorn:
        case kBallerCardType_MyPlayerCard:
            [self setMyPlayerCardSubviews];
            break;
            
        default:
            break;
    }
}

/*!
 *  @brief  个人信息框
 */
- (Baller_CardView *)playCardView
{
    if (!_playCardView) {
        playCardView = [[Baller_CardView alloc]initWithFrame:CGRectMake(TABLE_SPACE_INSET, 10.0, ScreenWidth-2*TABLE_SPACE_INSET, self.view.frame.size.height-20.0) playerCardType:self.ballerCardType];
        __BLOCKOBJ(blockPlayCard, playCardView);
        [AFNHttpRequestOPManager getWithSubUrl:Baller_get_user_attr parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode]?:@""} responseBlock:^(id result, NSError *error) {
            
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
        
        [self.view addSubview:_playCardView = playCardView];
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
    
    self.navigationItem.title = @"我的球员卡";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseQiuChang:) name:@"ChooseZhuChang" object:nil];
    if ([USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData])
    {
        UIImage * image = [UIImage imageWithData:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]];
        [self showBlurBackImageViewWithImage:image];
        
        [[[self playCardView] headImageButton] setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImage]] placeholderImage:[UIImage imageNamed:@"ballPark_default"]];
        
    }else{
        [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"]];
        [self playCardView];

    }
    
    if (self.ballerCardType == kBallerCardType_FirstBorn) {
        self.navigationItem.rightBarButtonItem = [ViewFactory getABarButtonItemWithTitle:@"进入主页" titleEdgeInsets:UIEdgeInsetsZero target:self selection:@selector(goToMainView)];
    }
    
}
-(void)chooseQiuChang:(NSNotification *) sender
{
    Baller_MyAttentionBallPark *currentBallPark = sender.object;
    [playCardView ->ballParkButton setTitle:currentBallPark.court_name forState:UIControlStateNormal];
}
#pragma mark 按钮方法
/*!
 *  @brief  进入主页方法
 */
- (void)goToMainView{
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
