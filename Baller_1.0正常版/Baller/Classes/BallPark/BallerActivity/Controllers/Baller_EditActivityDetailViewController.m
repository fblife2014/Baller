//
//  Baller_EditActivityDetailViewController.m
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_EditActivityDetailViewController.h"
#import "Baller_InfoItemView.h"

@interface Baller_EditActivityDetailViewController ()<UITextFieldDelegate>
{
    UIView * bottomView;
}
@end

@implementation Baller_EditActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑活动详情";
    [self showBlurBackImageViewWithImage:[UIImage imageNamed:@"ballPark_default"]];
    [self setupSubViews];
    // Do any additional setup after loading the view from its nib.
}

/*!
 *  @brief  设置子视图
 */
- (void)setupSubViews{
    float space = NUMBER(22.0, 20.0, 15.0, 15.0);
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(space, 1.5*space, ScreenWidth-2*space, 5*PersonInfoCell_Height)];
    bottomView.backgroundColor = BALLER_CORLOR_CELL;
    bottomView.layer.cornerRadius = NUMBER(30.0, 25.0, 20.0, 20.0);
    bottomView.clipsToBounds = YES;
    [self.view addSubview:bottomView];
    
    NSArray * colors = @[BALLER_CORLOR_CELL,[UIColor whiteColor],BALLER_CORLOR_CELL,[UIColor whiteColor],BALLER_CORLOR_NAVIGATIONBAR];
    NSArray * titles = @[@"主题",@"备注",@"时间",@"人数上限",@"发起活动"];
    NSArray * placeHolders = @[@"输入主题",@"可选",@"必填",@"由你而定"];

    for (int i = 0; i < colors.count; i++) {

        if (i<4) {
            Baller_InfoItemView * itemView = [[Baller_InfoItemView alloc]initWithFrame:CGRectMake(0.0, i*PersonInfoCell_Height, ScreenWidth-2*space, PersonInfoCell_Height) title:titles[i] placeHolder:placeHolders[i]];
            itemView.backgroundColor = colors[i];
            itemView.infoTextField.font = SYSTEM_FONT_S(17.0);
            itemView.titleLabel.font = SYSTEM_FONT_S(17.0);
            itemView.infoTextField.delegate = self;
            itemView.tag= 100+i;
            itemView.infoCanEdited = YES;
            if (i<3) {
                itemView.infoTextField.returnKeyType = UIReturnKeyNext;
            }else{
                itemView.infoTextField.returnKeyType = UIReturnKeyGo;

            }
            [bottomView addSubview:itemView];
            
        }else{
            UIButton * launchButton = [ViewFactory getAButtonWithFrame:CGRectMake(0.0, 4*PersonInfoCell_Height, ScreenWidth-2*space, PersonInfoCell_Height) nomalTitle:titles[4] hlTitle:titles[4] titleColor:[UIColor whiteColor] bgColor:BALLER_CORLOR_NAVIGATIONBAR nImage:nil hImage:nil action:@selector(launchButtonAction) target:self buttonTpye:UIButtonTypeCustom];
            [bottomView addSubview:launchButton];
        }
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*!
 *  @brief  发起活动按钮方法
 */
- (void)launchButtonAction{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark uitextfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    Baller_InfoItemView * itemView = (Baller_InfoItemView *)[textField superview];
    
    if (itemView.tag == 103) {
        [self launchButtonAction];
    }else{
        Baller_InfoItemView * nextItemView = (Baller_InfoItemView *)[bottomView viewWithTag:(itemView.tag+1)];
        [nextItemView.infoTextField becomeFirstResponder];
    }
    return YES;
}

@end
