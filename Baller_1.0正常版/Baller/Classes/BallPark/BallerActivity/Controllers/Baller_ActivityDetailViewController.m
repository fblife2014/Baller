//
//  Baller_ActivityDetailViewController.m
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_ActivityDetailViewController.h"
#import "Baller_InfoItemView.h"

@interface Baller_ActivityDetailViewController ()
{
    UIView * bottomView;
    UIButton * bottomButton;
}
@end

@implementation Baller_ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动详情";
    [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"]];
    [self setupSubViews];
    // Do any additional setup after loading the view.
}
/*!
 *  @brief  设置子视图
 */
- (void)setupSubViews{
    
    UIButton * collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    collectButton.frame = CGRectMake(0.0, 0.0, 60.0, NavigationBarHeight);
    [collectButton addTarget:self action:@selector(collectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    collectButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    collectButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -15.0);
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithCustomView:collectButton];
    self.navigationItem.rightBarButtonItem = barItem;
    
    
    float space = NUMBER(22.0, 20.0, 15.0, 15.0);
    
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(space, 1.5*space, ScreenWidth-2*space, 5*PersonInfoCell_Height)];
    bottomView.backgroundColor = BALLER_CORLOR_CELL;
    bottomView.layer.cornerRadius = NUMBER(30.0, 25.0, 20.0, 20.0);
    bottomView.clipsToBounds = YES;
    [self.view addSubview:bottomView];
    
    NSArray * colors = @[BALLER_CORLOR_CELL,[UIColor whiteColor],BALLER_CORLOR_CELL,[UIColor whiteColor],BALLER_CORLOR_NAVIGATIONBAR];
    NSArray * titles = @[@"主题",@"备注",@"时间",@"已参加用户",_haveJoined?@"退出活动":@"加入活动"];
    NSArray * details = @[@"求三对三",@"不怕虐的来！",@"12:00",@"8/15"];
    
    for (int i = 0; i < colors.count; i++) {
        
        if (i<4) {
            Baller_InfoItemView * itemView = [[Baller_InfoItemView alloc]initWithFrame:CGRectMake(0.0, i*PersonInfoCell_Height, ScreenWidth-2*space, PersonInfoCell_Height) title:titles[i] placeHolder:nil];
            itemView.infoTextField.text = details[i];
            itemView.backgroundColor = colors[i];
            itemView.infoTextField.font = SYSTEM_FONT_S(15.0);
            itemView.titleLabel.font = SYSTEM_FONT_S(15.0);
            [bottomView addSubview:itemView];
            
        }else{
            bottomButton = [ViewFactory getAButtonWithFrame:CGRectMake(0.0, 4*PersonInfoCell_Height, ScreenWidth-2*space, PersonInfoCell_Height) nomalTitle:titles[4] hlTitle:titles[4] titleColor:[UIColor whiteColor] bgColor:_haveJoined?BALLER_CORLOR_RED:BALLER_CORLOR_NAVIGATIONBAR nImage:nil hImage:nil action:@selector(bottomButtonAction) target:self buttonTpye:UIButtonTypeCustom];
            [bottomView addSubview:bottomButton];
        }
    }
    
}

- (void)setHaveJoined:(BOOL)haveJoined{
    if (_haveJoined == haveJoined) {
        return;
    }
    
    _haveJoined = haveJoined;
    
    if (!_haveJoined) {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        bottomButton.backgroundColor = BALLER_CORLOR_RED;
        [bottomButton setTitle:@"退出活动" forState:UIControlStateNormal];
        [bottomButton setTitle:@"退出活动" forState:UIControlStateHighlighted];
    }else{
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        bottomButton.backgroundColor = BALLER_CORLOR_NAVIGATIONBAR;
        [bottomButton setTitle:@"加入活动" forState:UIControlStateNormal];
        [bottomButton setTitle:@"加入活动" forState:UIControlStateHighlighted];
    }
    
    
}



#pragma mark 点击方法

- (void)collectButtonAction{
    
}
- (void)bottomButtonAction{

    self.haveJoined = !_haveJoined;
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
